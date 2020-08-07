TPDecline_Command:
    type: command
    name: tpdecline
    debug: false
    description: Declines a teleport request sent to you.
    usage: /tpdecline (<&lt>Player<&gt>)
    permission: Behr.Essentials.tpdecline
    tab complete:
        - define Blacklist <server.online_players.filter[has_flag[Behr.Moderation.Hide]].include[<Player>]>
        - Inject Online_Player_Tabcomplete
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax

    # - ██ [ Temporary Event Handle ] ██
        - if <player.has_flag[Event.InEvent]>:
            - narrate format:Colorize_Red "You cannot do that during an event."
            - stop

    # % ██ [ Check if player has a request ] ██
        - if <player.has_flag[Behr.Essentials.teleport.request]>:
        # % ██ [ Check if player is specifying player ] ██
            - if <context.args.first||null> == null:
                - define User <player.flag[Behr.Essentials.teleport.request].first.before[/]>
                - define Loc <player.flag[Behr.Essentials.teleport.request].first.after[/]>
            - else:
                - define User <context.args.first>
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
