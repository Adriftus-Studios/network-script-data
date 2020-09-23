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
        - if <context.args.size> > 1:
            - inject Command_Syntax

        - if !<player.has_flag[Behr.Essentials.Teleport.Request]>:
            - narrate format:Colorize_Red "No teleport request found."
            - stop
        - define Flag <player.flag[Behr.Essentials.Teleport.Request].as_map>

        - if <context.args.is_empty>:
            - define User <[Flag].keys.first>
            - define TeleportMap <[Flag].get[<[Flag].keys.first>]>
            - define Loc <[TeleportMap].get[Location]>
        - else:
            - define User <context.args.first>
            - inject Player_Verification_Offline
            - if !<[Flag].contains[<[User]>]>:
                - narrate format:Colorize_Red "No teleport request found."
                - stop
            - define TeleportMap <[Flag].get[<[User]>]>
            - define Loc <[TeleportMap].get[Location].add[0.01,0.01,0.01]>
            
        - flag <player> Behr.Essentials.Teleport.Request:<[Flag].exclude[<[User]>]>

    # % ██ [ Print to Players ] ██
        - narrate targets:<player> "<proc[Colorize].context[Teleport request declined.|green]>"
        - narrate targets:<[User]> "<proc[User_Display_Simple].context[<player>]> <proc[Colorize].context[declined your teleport request.|green]>"
