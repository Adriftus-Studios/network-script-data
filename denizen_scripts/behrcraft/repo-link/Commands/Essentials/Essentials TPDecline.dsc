TPDecline_Command:
    type: command
    name: tpdecline
    debug: false
    description: Declines a teleport request sent to you.
    usage: /tpdecline (<&lt>Player<&gt>)
    permission: Behr.Essentials.tpdecline
    tab complete:
        - if <context.args.size||0> == 0:
            - determine <server.online_players.parse[name].exclude[<player.name>]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax

    # % ██ [ Check if player has a request ] ██
        - if <player.has_flag[Behr.Essentials.teleport.request]>:
        # % ██ [ Check if player is specifying player ] ██
            - if <context.args.get[1]||null> == null:
                - define User <player.flag[Behr.Essentials.teleport.request].get[1].before[/]>
                - define Loc <player.flag[Behr.Essentials.teleport.request].get[1].after[/]>
            - else:
                - define User <context.args.get[1]>
                - inject Player_Verification_Offline
            # % ██ [ Check if player is requested a teleport ] ██
                - if <player.flag[Behr.Essentials.teleport.request].parse[before[/]].contains[<[User]>]>:
                    - define Loc <player.flag[Behr.Essentials.teleport.request].map_get[<[User]>]>
                - else:
                    - narrate "<proc[Colorize].context[No teleport request found.|red]>"
                    - stop

        # % ██ [ Check teleport request type, adjust flags ] ██
            - if <player.flag[Behr.Essentials.teleport.requesttype].map_get[<[User]>]||false> == teleportto:
                - flag <player> Behr.Essentials.teleport.requesttype:<-:<[User]>/teleportto
            - flag <player> Behr.Essentials.teleport.request:<-:<[User]>/<[Loc]>

        # % ██ [ Print to Players ] ██
            - narrate targets:<player> "<proc[Colorize].context[Teleport request declined.|green]>"
            - narrate targets:<[User]> "<proc[User_Display_Simple].context[<player>]> <proc[Colorize].context[declined your teleport request.|green]>"
        - else:
            - narrate "<proc[Colorize].context[No teleport request found.|red]>"
