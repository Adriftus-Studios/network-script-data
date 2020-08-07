Teleport_Command:
    type: command
    name: teleport
    debug: false
    description: Teleports you to the first player, or the first player to the second.
    usage: /teleport <&lt>PlayerName<&gt>
    adminusage: /teleport <&lt>PlayerName<&gt> (<&lt>PlayerName<&gt>)*
    permission: Behr.Essentials.Teleport
    tab complete:
        - define Blacklist <server.online_players.filter[has_flag[Behrry.Moderation.Hide]].include[<Player>]>
        - inject Online_Player_Tabcomplete
    aliases:
        - tp
        - tpa
    script:
    # % ██ [ Check args ] ██
        - if <context.args.is_empty>:
            - inject Command_Syntax

    # % ██ [ Check player arg ] ██
        - define User <context.args.first>
        - inject Player_Verification_Offline

    # % ██ [ Check for multi-player teleporting ] ██
        - if <context.args.size> < 2:
        # % ██ [ Check if trying to teleport to self ] ██
            - if <[User]> == <player>:
                - define reason "You cannot teleport to yourself."
                - inject Command_Error
        # % ██ [ Check if Moderator, bypass ] ██
            - if <player.in_group[Moderation]> && <[User].name> != Behr_Riley:
                - flag <Player> Behr.Essentials.teleport.back:<player.location>
                - teleport <player> <[User].location>
                - narrate "<proc[Colorize].context[You were teleported to:|green]> <&r><[User].display_name>"
            - else:
        # % ██ [ Check if player is still requested ] ██
                - if <[User].flag[Behr.Essentials.teleport.request].parse[before[/]].contains[<Player>]||false>:
                    - narrate format:Colorize_Red "Teleport request still pending."
                    - stop

            # - ██ [ Temporary Event Handle ] ██
                - if <player.has_flag[Event.InEvent]>:
                    - narrate format:Colorize_Red "You cannot do that during an event."
                    - stop

                - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><proc[User_Display_Simple].context[<player>]>"
                - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
                - define CommandA "tpaccept <player.name>"
                - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

                - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
                - define DisplayB <&c>[<&4><&chr[2716]><&c>]
                - define CommandB "tpdecline <player.name>"
                - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

                - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
                - define DisplayC <&c>[<&4><&chr[2716]><&c>]
                - define CommandC "tp <[User].name> Cancel"
                - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>

                - flag <[User]> Behr.Essentials.teleport.requesttype:->:<player>/teleportto duration:3m
                - flag <[User]> Behr.Essentials.teleport.request:->:<player>/<[User].location> duration:3m

                - narrate targets:<[User]> "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <proc[User_Display_Simple].context[<player>]> <proc[Colorize].context[is requesting to teleport to you.|green]>"
                - narrate targets:<player> "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <proc[User_Display_Simple].context[<[User]>]><&2>."
        - else:
        # % ██ [ Check if canceling ] ██
            - if <context.args.get[2]||null> == Cancel:
                - if <[User].has_flag[Behr.Essentials.teleport.request]>:
                    - if <[User].flag[Behr.Essentials.teleport.request].parse[before[/]].contains[<player>]>:
                        - narrate targets:<[User]>|<player> Format:Colorize_Green "Teleport request cancelled."
                        - define KeyValue <[User].flag[Behr.Essentials.teleport.request].map_get[<player>]>
                        - flag <[User]> Behr.Essentials.teleport.request:<-:<player>/<[KeyValue]>
                        - stop
                    - else:
                        - narrate Format:Colorize_Red "No teleport request found."
                        - stop
                - else:
                    - narrate Format:Colorize_Red "No teleport request found."
                    - stop

                - if <[User].has_flag[Behr.Essentials.teleport.request]>:
                    - if <[User].flag[Behr.Essentials.teleport.request].parse[before[/]].contains[<player>]>:
                        - narrate Format:Colorize_Red "Teleport request still pending."
                        - stop

        # % ██ [ Check if a moderator ] ██
            - if !<player.in_group[Moderation]>:
                - inject Admin_Permission_Denied

        # % ██ [ Teleport multiple people to last player ] ██
            - foreach <context.raw_args.split[<&sp>].first.to[<context.args.size.sub[1]>]> as:User:
                - inject Player_Verification
                - if <[PlayerList].contains[<[User]>]||false>:
                    - define reason "<proc[Player_Display_Simple].context[<[User]>]> was entered more than once."
                    - inject Command_Error
                - if <[User]> == <player>:
                    - define reason "You cannot teleport to yourself."
                    - inject Command_Error
                - define PlayerList:->:<[User]>
            - define User <context.args.last>
            - inject Player_Verification
            - foreach <[PlayerList]> as:Player:
                - flag <[Player]> Behr.Essentials.teleport.back:<[player].location>
                - teleport <[Player]> <[User].location>
                - narrate targets:<[Player]> "<proc[Colorize].context[You were teleported to:|green]> <&r><[User].display_name>"
            - if <[PlayerList].size> > 1:
                - define WasWere were
            - else:
                - define WasWere was
            - narrate targets:<[User]> "<[PlayerList].parse[display_name].formatted> <&r><proc[Colorize].context[<[WasWere]> teleported to you.|green]>"
