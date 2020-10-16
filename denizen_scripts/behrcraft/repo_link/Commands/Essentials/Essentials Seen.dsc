Seen_Command:
    type: command
    name: seen
    debug: false
    description: Shows you a when a player was last online.
    usage: /seen <&lt>Player<&gt>
    permission: Behr.Essentials.Seen
    tab complete:
        - inject All_Player_Tabcomplete
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.is_empty> || <context.args.size> > 1:
            - inject Command_Syntax
            
    # % ██ [ Check Player ] ██
        - define User <context.args.first>
        - inject Player_Verification_Offline

    # % ██ [ Define Time ] ██
        - define Days "<&e><util.date.time.duration.sub[<[User].last_played>].in_days.round_down> <&2>d<&a>ays<&2>,"
        - define Hours "<&e><util.date.time.duration.sub[<[User].last_played>].time.hour.round_down> <&2>h<&a>ours<&2>,"
        - define Minutes <&e><util.date.time.duration.sub[<[User].last_played>].time.minute.round_down>

    # % ██ [ Print Message ] ██
        - Define Text "<proc[User_Display_Simple].context[<[User]>]> <&2>l<&a>ast <&2>s<&a>een <[Days]> <[Hours]> <[Minutes]> <&2>m<&a>inutes <&2>a<&a>go<&2>."
        - narrate <[Text]>
