TPHere_Command:
    type: command
    name: tphere
    debug: false
    description: Requests a player to teleport to you.
    usage: /tphere <&lt>Player<&gt> (Cancel)
    permission: Behr.essentials.tphere
    aliases:
        - tpahere
    tab complete:
        - define Blacklist <server.online_players.filter[has_flag[Behr.Moderation.Hide]].include[<Player>]>
        - inject Online_Player_Tabcomplete
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.is_empty> || <context.args.size> > 2:
            - inject Command_Syntax

    # - ██ [ Temporary Event Handle ] ██
        - if <player.has_flag[Event.InEvent]>:
            - narrate format:Colorize_Red "You cannot do that during an event."
            - stop
        
    # % ██ [ Check if requesting Everyone ] ██
        - if <context.args.first> == everyone:
            - foreach <server.online_players.exclude[<player>]> as:User:
            # % ██ [ Reroute command for each player ] ██
                - execute as_player "tphere <[User].name>"
            - stop
        - else:
            - define User <context.args.first>
            - inject Player_Verification

    # % ██ [ Check if User is Player ] ██
        - if <[User]> == <player>:
            - narrate format:colorize_yellow "Nothing interesting happens."
            - stop

    # % ██ [ Check second Arg ] ██
        - if <context.args.get[2]||null> != null:
        # % ██ [ Check if canceling request ] ██
            - if <context.args.get[2]||null> != Cancel:
                - inject Command_Syntax
            - else:
            # % ██ [ Check if player has request open ] ██
                - if <[User].has_flag[Behr.Essentials.teleport.request]>:
                    - if <[User].flag[Behr.Essentials.teleport.request].parse[before[/]].contains[<player>]>:
                        - narrate targets:<[User]>|<player> "<proc[Colorize].context[Teleport request cancelled.|green]>"
                        - define KeyValue <[User].flag[Behr.Essentials.teleport.request].map_get[<player>]>
                        - flag <[User]> Behr.Essentials.teleport.request:<-:<player>/<[KeyValue]>
                        - stop
                    - else:
                        - narrate "<proc[Colorize].context[No teleport request found.|red]>"
                        - stop
                - else:
                    - narrate "<proc[Colorize].context[No teleport request found.|red]>"
                    - stop

    # % ██ [ Check if User is still queued a request ] ██
        - if <[User].has_flag[Behr.Essentials.teleport.request]>:
            - if <[User].flag[Behr.Essentials.teleport.request].parse[before[/]].contains[<player>]>:
                - narrate format:Colorize_Red "Teleport request still pending."
                - stop

    # % ██ [ Format Buttons ] ██
        - define HoverA "<proc[Colorize].context[Teleport To:|Green]><&nl><proc[User_Display_Simple].context[<player>]>"
        - define DisplayA "<&a>[<&2><&l><&chr[2714]><&r><&a>]"
        - define CommandA "tpaccept <player.name>"
        - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>
    
        - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
        - define DisplayB "<&c>[<&4><&chr[2716]><&c>]"
        - define CommandB "tpdecline <player.name>"
        - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>
    
        - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
        - define DisplayC "<&c>[<&4><&chr[2716]><&c>]"
        - define CommandC "tphere <[User].name> Cancel"
        - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>
    
    # % ██ [ Adjust Flags ] ██
        - flag <[User]> Behr.Essentials.teleport.request:->:<player>/<player.location> duration:3m

    # % ██ [ Print to Players ] ██
        - narrate targets:<[User]> "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <proc[User_Display_Simple].context[<player>]> <proc[Colorize].context[sent a Teleport Request.|green]>"
        - narrate targets:<player> "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <proc[User_Display_Simple].context[<[User]>]><&2>."
