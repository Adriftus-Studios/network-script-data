Spawner_Command:
    type: command
    name: Spawner
    debug: false
    description: Gives you a spawner of the specified entity.
    usage: /Spawner <&lt>Type<&gt> (Player) (#)
    permission: Behrry.Moderation.Spawner
    tab complete:
        - define Arg1 <server.material_types.filter[contains[spawn_egg]].parse[name.before[_spawn_egg]]>
        - define Arg2 <server.online_players.parse[name]>
        - inject MultiArg_Command_Tabcomplete Instantly
    script:
    # % ██ [  Correct syntax? ] ██
        - if <context.args.is_empty>:
            - inject Command_Syntax Instantly

        - if <context.args.size> > 3:
            - inject Command_Syntax Instantly

    # % ██ [  Define Data ] ██
        - define Type <context.args.first.to_titlecase>
        - if <server.material_types.filter[contains[spawn_egg]].parse[name.before[_spawn_egg]].contains[<[Type]>]>:
            - define Item <item[Spawner].with[display_name=<[Type]><&sp>Spawner;nbt=key/<[Type]>]>

    # % ██ [ Choose Arg Count ] ██
        - choose <context.args.size>:
            - case 1:
                - define User <player>
                - define Quantity 1
            - case 2:
                - define User <context.args.get[2]>
                - inject Player_Verification_Offline_NullReturn Instantly
                - if <[User]> == null:
                    - define User <player>
                    - define Quantity <context.args.get[2]>
            - case 3:
                - define User <context.args.get[2]>
                - inject Player_Verification_Offline Instantly
                - define Quantity <context.args.get[3]>

        - inject Locally QuantityCheck Instantly
        
        - give <[Item]> to:<[User].inventory> quantity:<[Quantity]>

    QuantityCheck:
            - if !<[Quantity].is_integer>:
                - define Reason "Quantities are Integers."
                - inject Command_Error Instantly
            
            - if <[Quantity].contains[.]>:
                - define Reason "Quantities cannot contain decimals."
                - inject Command_Error Instantly
            
            - if <[Quantity]> > 64:
                - define Reason "Quantity cannot exceed 64."
                - inject Command_Error Instantly

            - if <[Quantity]> < 1:
                - define Reason "Quantity cannot be less than zero."
                - inject Command_Error Instantly
            
            - if !<[User].inventory.can_fit[<[Item].with[quantity=<[Quantity]>]>]>:
                - define Reason "Not enough room."
                - inject Command_Error Instantly

entangle:
    type: item
    display name: <&5><&l>Entangle
    material: cobweb
nature_spellbook_gui:
    type: inventory
    title: <&a><&l>Spellbook of Nature
    size: 9
    slots:
        - [entangle] [] [] [] [] [] [] [] []
