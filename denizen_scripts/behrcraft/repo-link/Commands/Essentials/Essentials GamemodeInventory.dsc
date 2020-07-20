gamemodeinventory_Command:
    type: command
    name: gamemodeinventory
    debug: false
    description: Adjusts your inventory to the gamemode inventory specified.
    admindescription: Adjusts another player's or your inventory to the gamemode inventory specified.
    usage: /gamemodeinventory <&lt>Gamemode<&gt>
    adminusage: /gamemodeinventory (Player) <&lt>Gamemode<&gt>
    permission: Behrry.Essentials.GamemodeInventory
    aliases:
        - gminv
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - define Arg1 <list[Adventure|Creative|Survival|Spectator].exclude[<player.gamemode>]>
            - inject OneArg_Command_Tabcomplete Instantly
    script:
        - if <context.args.get[3]||null> != null || <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly
        - if <context.args.get[2]||null> != null:
            - if <player.groups.contains[Moderation]>:
                - define User <context.args.get[1]>
                - define Player_Verification Instantly
                - if <list[Adventure|Creative|Survival|Spectator].contains[<context.args.get[2]>]>:
                    - define Gamemode <context.args.get[2]>
                - else:
                    - inject Command_Syntax Instantly
            - else:
                - inject Admin_Permission_Denied Instantly
        - else:
            - define User <player>
            - if <list[Adventure|Creative|Survival|Spectator].contains[<context.args.get[1]>]>:
                - define Gamemode <context.args.get[1]>
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