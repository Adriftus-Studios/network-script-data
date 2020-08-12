TPAccept_Command:
    type: command
    name: tpaccept
    debug: false
    description: Accepts a teleport request sent to you.
    usage: /tpaccept (<&lt>Player<&gt>)
    permission: Behr.Essentials.tpaccept
    tab complete:
        - define Blacklist <server.list_online_players.filter[has_flag[Behr.Moderation.Hide]].include[<Player>]>
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
            
        - narrate format:Colorize_Green "Teleport request accepted" targets:<[User]>|<player>

        - flag <player> Behr.Essentials.Teleport.Request:<[Flag].exclude[<[User]>]>
        - choose <[TeleportMap].get[RequestType]>:
            - case TeleportTo:
                - flag <[User]> Behr.Essentials.Teleport.Back:<[User].location>
                - teleport <[User]> <[Loc]>
            - case TeleportHere:
                - flag <player> Behr.Essentials.Teleport.Back:<player.location>
                - teleport <player> <[Loc]>
