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
                    - determine <server.online_players.parse[name].exclude[<player.name>]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.first>]]>
            - else:
                - if <context.args.size||0> == 0:
                    - determine <server.players.parse[name].exclude[<player.name>]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.first>]]>
    script:
    - if <context.args.first||null> == null || <context.args.get[3]||null> != null:
        - inject Command_Syntax Instantly
    - define User <context.args.first>
    - inject Player_Verification_Offline Instantly
    - narrate "<proc[Colorize].context[<[User].name>(|yellow]><&r><[User].name.display><&r><proc[Colorize].context[) IP address: <[User].ip>|yellow]>"
