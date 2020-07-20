# | ███████████████████████████████████████████████████████████
# % ██    /Mute - Adjusts a player's mute
# | ██
# % ██  [ Command ] ██
Mute_Command:
    type: command
    name: mute
    debug: false
    description: Mutes a player
    usage: /mute <&lt>Player<&gt> (Remove)
    permission: behrry.moderation.mute
    tab complete:
        - if !<player.has_flag[behrry.essentials.tabofflinemode]>:
            - if <context.args.size||0> == 0:
                - determine <server.list_online_players.parse[name].exclude[<player.name>]>
            - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <server.list_online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
            - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
                - determine remove
            - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <[Arg2].filter[starts_with[remove]]>
        - else:
            - if <context.args.size||0> == 0:
                - determine <server.list_players.parse[name].exclude[<player.name>]>
            - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <server.list_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
            - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
                - determine remove
            - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <[Arg2].filter[starts_with[remove]]>
                
    script:
        - if <context.args.size> > 2 || <context.args.size> < 1:
            - inject Command_Syntax Instantly
            
        - define User <context.args.get[1]>
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
