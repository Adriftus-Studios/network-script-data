Tempban_Command:
    type: command
    name: tempban
    debug: false
    description: tempbans a player.
    usage: /tempban <&lt>Player<&gt> <&lt>Duration<&gt> (reason)
    permission: behrry.moderation.tempban
    tab complete:
        - inject All_Player_Tabcomplete Instantly
    script:
    # % ██ [ Verify args ] ██
        - if <context.args.get[2]||null> == null:
            - inject Command_Syntax Instantly
    # % ██ [ Verify player ] ██
        - define User <context.args.first>
        - inject Player_Verification_Offline Instantly

    # % ██ [ Verify duration ] ██
        - define Duration <context.args.get[2]>
        - if <duration[<[Duration]>]||null> == null:
            - define Reason "Invalid Duration."
            - inject Command_Error Instantly
        - if <[Duration]> > <duration[3d]>:
            - define Reason "You can only temp-ban someone for up to three days."
            - inject Command_Error Instantly

    # % ██ [ Check if player is a moderator ] ██
        - if <[User].in_group[Moderation]>:
            - if <[User]> == <player>:
                - narrate Colorize_Red "You cannot ban yourself."
                - stop
            - else if <list[Behr_riley|Behrry|CatEatsLasagna].contains[<[User].name>]>:
                - narrate Colorize_Red "This player cannot be banned."
                - stop

    # % ██ [ Check if reason is specified ] ██
        - if <context.args.get[3]||null> != null:
            - define Reason <context.raw_args.after[<context.args.first><&sp>]>
            - announce "<proc[User_Display_Simple].context[<[User]>]> <&e>was banned for: <&a><[Reason]>"
            - ban <[User]> duration:<[Duration]> reason:<[Reason]>
        - else:
            - announce "<[User].name> was banned."
            - ban <[User]> duration:<[Duration]>
