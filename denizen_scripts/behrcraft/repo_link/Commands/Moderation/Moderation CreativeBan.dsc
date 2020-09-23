CreativeBan_Command:
    type: command
    name: creativeban
    debug: false
    description: Bans a a player from creative mode.
    usage: /creativeban <&lt>Player<&gt> <&lt>Duration<&gt> (reason)
    permission: Behrry.Moderation.CreativeBan
    aliases:
        - bancreativemode
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
            - define Reason "You can only temporarily creative-ban someone for up to three days."
            - inject Command_Error Instantly

    # % ██ [ Check if player is a moderator ] ██
        - if <[User].in_group[Moderation]>:
            - if <[User]> == <player>:
                - narrate Colorize_Red "You cannot ban yourself."
                - stop
            - else if <list[Behr_riley|Behrry|CatEatsLasagna].contains[<[User].name>]>:
                - narrate Colorize_Red "This player cannot be banned from creative."
                - stop

    # % ██ [ Check if reason is specified ] ██
        - if <context.args.get[3]||null> != null:
            - define Reason <context.raw_args.after[<context.args.first><&sp>]>
            - if <[User].is_online>:
                - narrate targets:<[User]> "<proc[Colorize].context[You were banned from Creative for:|red]> <[Reason]>"
            - narrate targets:<server.online_players.filter[in_group[Moderation]]> "<proc[User_Display_Simple].context[<[User]>]> <&e>was banned from creative for: <&a><[Reason]>"
            - flag <[User]> Behrry.Moderation.CreativeBan:<[Reason]> duration:<[Duration]>
        - else:
            - narrate targets:<[User]> "<proc[Colorize].context[You were banned from Creative.|red]>"
            - narrate targets:<server.online_players.filter[in_group[Moderation]]> "<proc[User_Display_Simple].context[<[User]>]> <&e>was banned from creative."
            - flag <[User]> Behrry.Moderation.CreativeBan:<[Reason]> duration:<[Duration]>
