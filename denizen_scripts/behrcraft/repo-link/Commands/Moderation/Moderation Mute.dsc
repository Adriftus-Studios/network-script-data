Mute_Command:
    type: data
    name: mute
    debug: false
    description: Mutes a player
    usage: /mute <&lt>Player<&gt> (Remove)
    permission: behrry.moderation.mute
    tab complete:
        - if !<player.has_flag[behrry.essentials.tabofflinemode]>:
            - if <context.args.size||0> == 0:
                - determine <server.online_players.parse[name].exclude[<player.name>]>
            - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <server.online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.first>]]>
            - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
                - determine remove
            - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <[Arg2].filter[starts_with[remove]]>
        - else:
            - if <context.args.size||0> == 0:
                - determine <server.players.parse[name].exclude[<player.name>]>
            - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <server.players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.first>]]>
            - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
                - determine remove
            - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <[Arg2].filter[starts_with[remove]]>
                
    script:
        - if <context.args.size> > 2 || <context.args.size> < 1:
            - inject Command_Syntax Instantly
            
        - define User <context.args.first>
        - inject Player_Verification_Offline Instantly
        - if <context.args.get[2]||null> == null:
            - if <player.has_flag[behrry.moderation.muted]>:
                - narrate "<proc[Colorize].context[Player is already muted.|Red]>"
            - else:
                - flag <[User]> behrry.moderation.muted
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[was muted.|Red]>"
        - else if <context.args.get[2]> == remove:
            - flag <[User]> behrry.moderation.muted:!
        - else:
            - inject Command_Syntax Instantly
