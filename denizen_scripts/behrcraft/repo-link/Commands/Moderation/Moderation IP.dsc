IP_Command:
    type: command
    name: ip
    debug: false
    description: pulls the specified player's IP address
    usage: /ip <&lt>Player<&gt>
    permission: behrry.essentials.ip
    aliases:
        - userip
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - if !<player.has_flag[behrry.essentials.tabofflinemode]>:
                - if <context.args.size||0> == 0:
                    - determine <server.list_online_players.parse[name].exclude[<player.name>]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.list_online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
            - else:
                - if <context.args.size||0> == 0:
                    - determine <server.list_players.parse[name].exclude[<player.name>]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.list_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
    script:
    - if <context.args.get[1]||null> == null || <context.args.get[3]||null> != null:
        - inject Command_Syntax Instantly
    - define User <context.args.get[1]>
    - inject Player_Verification_Offline Instantly
    - narrate "<proc[Colorize].context[<[User].name>(|yellow]><&r><[User].name.display><&r><proc[Colorize].context[) IP address: <[User].ip>|yellow]>"
