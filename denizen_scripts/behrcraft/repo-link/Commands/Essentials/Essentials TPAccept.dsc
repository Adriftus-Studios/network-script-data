TPAccept_Command:
    type: command
    name: tpaccept
    debug: false
    description: Accepts a teleport request sent to you.
    usage: /tpaccept (<&lt>Player<&gt>)
    permission: Behr.Essentials.tpaccept
    tab complete:
        - define Blacklist <server.online_players.filter[has_flag[Behr.Moderation.Hide]].include[<Player>]>
        - Inject Online_Player_Tabcomplete
    script:
        - if !<context.args.is_empty>:
            - if <context.args.size> > 1:
                - inject Command_Syntax

    # - ██ [ Temporary Event Handle ] ██
        - if <player.has_flag[Event.InEvent]>:
            - narrate format:Colorize_Red "You cannot do that during an event."
            - stop

        - if <player.has_flag[Behr.Essentials.Teleport.Request]>:
            - if <context.args.is_empty>:
                - define User <player.flag[Behr.Essentials.Teleport.Request].first.before[/]>
                - define Loc <player.flag[Behr.Essentials.Teleport.Request].first.after[/]>
            - else:
                - define User <context.args.first>
                - inject Player_Verification_Offline
                - if <player.flag[Behr.Essentials.Teleport.Request].parse[before[/]].contains[<[User]>]>:
                    - define Loc <player.flag[Behr.Essentials.Teleport.Request].map_get[<[User]>]>
                - else:
                    - narrate "<proc[Colorize].context[No teleport request found.|red]>"
                    - stop
            
            - narrate targets:<[User]>|<player> "<proc[Colorize].context[Teleport request accepted.|green]>"
            - if <player.has_flag[Behr.Essentials.Teleport.Requesttype]>:
                - if <player.flag[Behr.Essentials.Teleport.Requesttype].map_get[<[User]>]||false> == teleportto:
                    - flag <player> Behr.Essentials.Teleport.Requesttype:<-:<[User]>/teleportto
                    - flag <player> Behr.Essentials.Teleport.Request:<-:<[User]>/<[Loc]>
                    - flag <[User]> Behr.Essentials.Teleport.Back:<[User].location>
                    - teleport <[User]> <player.location.add[0.01,0,0.01]>
            - else:
                - flag <player> Behr.Essentials.Teleport.Request:<-:<[User]>/<[Loc]>
                - flag <player> Behr.Essentials.Teleport.Back:<player.location>
                - teleport <player> <[Loc].add[0.01,0,0.01]>

        - else:
            - narrate "<proc[Colorize].context[No teleport request found.|red]>"
