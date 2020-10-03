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

    # % ██ [ Check single arg usage ] ██
        - if <context.args.size> == 1:
            - if <[User]> == <player>:
                - narrate format:Colorize_Yellow "Nothing interesting happens."
            - else:
                - inject Locally Permission_Check
        - else:
            - if <player.in_group[Moderator]>:
                - define User2 <[User]>
                - define User <context.args.get[2]>
                - inject Player_Verification_Offline
                - flag <[User2]> behr.essentials.teleport.back:<map.with[location].as[<[User2].location>].with[world].as[<[User2].location.world.name>]>
                - teleport <[User2]> <[User].location>
            - else:
                - define reason "Not enough permission"

    # % ██ [ Check for Request flag ] ██
    Permission_Check:
        - if !<player.in_group[Moderation]> || <context.args.contains_any[-r|-req|-request]>:
            - inject Locally Teleport_Prompt
        - else:
            - flag player behr.essentials.teleport.back:<map.with[location].as[<player.location>].with[world].as[<player.world.name>]>
            - teleport <player> <[User].location>
    Teleport_Prompt:
        - if <[User].has_flag[Behr.Essentials.Teleport.Requests]>:
            - define TeleportMap <[User].flag[Behr.Essentials.Teleport.Requests]>
        - else:
            - define TeleportMap <map>

        - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><proc[User_Display_Simple].context[<player>]>"
        - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
        - define CommandA "tpaccept <player.name>"
        - define Accept <proc[msg_cmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

        - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
        - define DisplayB <&c>[<&4><&chr[2716]><&c>]
        - define CommandB "tpdecline <player.name>"
        - define Decline <proc[msg_cmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

        - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
        - define DisplayC <&c>[<&4><&chr[2716]><&c>]
        - define CommandC "tp <[User].name> Cancel"
        - define Cancel <proc[msg_cmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>

        - flag <[User]> Behr.Essentials.Teleport.Request:<[TeleportMap].with[<player>].as[<map.with[RequestType].as[TeleportTo].with[Location].as[<[User].location>]>]> duration:3m

        - narrate targets:<[User]> "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <proc[User_Display_Simple].context[<player>]> <proc[Colorize].context[is requesting to teleport to you.|green]>"
        - narrate targets:<player> "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <proc[User_Display_Simple].context[<[User]>]><&2>."
