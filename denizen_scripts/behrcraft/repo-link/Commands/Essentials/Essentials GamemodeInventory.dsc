gamemodeinventory_Command:
    type: command
    name: gamemodeinventory
    debug: false
    description: Adjusts your inventory to the gamemode inventory specified.
    admindescription: Adjusts another player's or your inventory to the gamemode inventory specified.
    usage: /gamemodeinventory <&lt>Gamemode<&gt>
    adminusage: /gamemodeinventory (Player) <&lt>Gamemode<&gt>
    permission: Behr.Essentials.GamemodeInventory
    aliases:
        - gminv
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - define Arg1 <list[Adventure|Creative|Survival|Spectator].exclude[<player.gamemode>]>
            - inject OneArg_Command_Tabcomplete Instantly
    script:
        - if <context.args.is_empty> || <context.args.size> > 2:
            - inject Command_Syntax Instantly
        - else if <context.args.size> == 1:
            - define User <player>
            - if <list[Adventure|Creative|Survival|Spectator].contains[<context.args.first>]>:
                - define Gamemode <context.args.first>
        - else if <context.args.size> == 2:
            - if <player.groups.contains[Moderation]>:
                - define User <context.args.first>
                - define Player_Verification Instantly
                - if <list[Adventure|Creative|Survival|Spectator].contains[<context.args.get[2]>]>:
                    - define Gamemode <context.args.get[2]>
                - else:
                    - inject Command_Syntax Instantly
            - else:
                - inject Admin_Permission_Denied Instantly
        - else:
            - else:
                - inject Command_Syntax Instantly

        - if !<list[Adventure|Creative|Survival|Spectator].exclude[<[User].gamemode>].contains[<[Gamemode]>]>:
            - if <[User]> != <player>:
                - narrate "<proc[Colorize].context[does not have a saved <[Gamemode]> inventory while in <[Gamemode]> Mode.|red]>"
            - else:
                - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop

        - flag player Gamemode.Inventory.Changebypass
        - inventory clear
        - inventory set d:<player.inventory> o:<player.flag[Gamemode.Inventory.<[Gamemode]>].as_list>
