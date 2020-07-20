Ban_Command:
    type: command
    name: ban
    debug: false
    description: bans a player.
    usage: /ban <&lt>Player<&gt> (reason)
    permission: behrry.moderation.ban
    tab complete:
        - inject All_Player_Tabcomplete Instantly
    script:
    # @ ██ [  Verify args ] ██
        - if <context.args.get[2]||null> == null:
            - inject Command_Syntax Instantly
    # @ ██ [  Verify player ] ██
        - define User <context.args.get[1]>
        - inject Player_Verification_Offline Instantly

    # @ ██ [  Check if player is a moderator ] ██
        - if <[User].in_group[Moderation]>:
            - if <[User]> == <player>:
                - narrate Colorize_Red "You cannot ban yourself."
                - stop
            - else if <list[Behr_riley|Behrry|CatEatsLasagna].contains[<[User].name>]>:
                - narrate Colorize_Red "This player cannot be banned."
                - stop

    # @ ██ [  Check if reason is specified ] ██
        - if <context.args.get[2]||null> != null:
            - define Reason <context.raw_args.after[<context.args.get[1]><&sp>]>
            - announce "<proc[User_Display_Simple].context[<[User]>]> <&e>was banned for: <&a><[Reason]>"
            - ban <[User]> reason:<[Reason]>
        - else:
            - announce "<[User].name> was banned."
            - ban <[User]>
