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

    # % ██ [ Check player arg ] ██
        - define User <context.args.first>
        - inject Player_Verification_Offline

        - if <[User].has_flag[Behr.Essentials.Teleport.Requests]>:
            - define TeleportMap <[User].flag[Behr.Essentials.Teleport.Requests]>
        - else:
            - define TeleportMap <map>

        - inject Locally TeleportPrompt
    TeleportPrompt:
        - define HoverA "<proc[Colorize].context[Teleport To:|Green]><&nl><proc[User_Display_Simple].context[<player>]>"
        - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
        - define CommandA "tpaccept <player.name>"
        - define Accept <proc[msg_cmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>
    
        - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
        - define DisplayB <&c>[<&4><&chr[2716]><&c>]
        - define CommandB "tpdecline <player.name>"
        - define Decline <proc[msg_cmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>
    
        - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
        - define DisplayC <&c>[<&4><&chr[2716]><&c>]
        - define CommandC "tphere <[User].name> Cancel"
        - define Cancel <proc[msg_cmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>
    
        - flag <[User]> Behr.Essentials.Teleport.Request:<[TeleportMap].with[<player>].as[<map.with[RequestType].as[TeleportHere].with[Location].as[<player.location>]>]> duration:3m

        - narrate targets:<[User]> "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <proc[User_Display_Simple].context[<player>]> <proc[Colorize].context[sent a Teleport Request.|green]>"
        - narrate targets:<player> "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <proc[User_Display_Simple].context[<[User]>]><&2>."
