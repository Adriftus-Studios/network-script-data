Kick_Command:
    type: data
    name: kick
    debug: false
    description: Kicks a player.
    usage: /kick <&lt>Player<&gt> (reason)
    permission: behrry.moderation.kick
    tab complete:
        - inject Online_Player_Tabcomplete Instantly
    script:
    # % ██ [ Verify args ] ██
        - if <context.args.size> == 0:
            - inject Command_Syntax Instantly
        - define User <context.args.first>
        - inject Player_Verification Instantly

        - if <[User].in_group[Moderation]>:
            - if <[User]> == <player>:
                - narrate format:Colorize_Red "You cannot kick yourself."
                - stop
            - else if <[User]> == <server.match_player[Behr]||false>:
                - narrate format:Colorize_Red "This player cannot be kicked."
                - stop
            - else if !<player.in_group[Administrator]>:
                - narrate format:Colorize_Red "Not strong enough permission."
                - stop

        - if <context.args.get[2]||null> != null:
            - define Reason <context.raw_args.after[<context.args.first><&sp>]>
            - announce "<proc[User_Display_Simple].context[<[User]>]> <&e>was kicked for: <&a><[Reason]>"
            - flag <[User]> behrry.moderation.kicked duration:1s
            - kick <[User]> reason:<[Reason]>
        - else:
            - announce "<[User]> was kicked."
            - kick <[User]>
