Playtime_Command:
    type: command
    name: playtime
    debug: false
    description: Shows you a player's current playtime.
    usage: /playtime <&lt>Player<&gt>
    permission: Behr.essentials.playtime
    aliases:
        - pt
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - inject All_Player_Tabcomplete
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.size> > 1:
            - inject Command_Syntax
        
    # % ██ [ Check if specifying another player ] ██
        - if <context.args.is_empty>:
            - define User <player>
        - else:
            - define User <context.args.first>
            - inject Player_Verification_Offline
        
    # % ██ [ Check if player is online ] ██
        - if <[User].is_online>:
            - define PDays <&e><[User].statistic[PLAY_ONE_MINUTE].div[1728000].round_down><&f>
            - define PHours <&e><[User].statistic[PLAY_ONE_MINUTE].div[72000].round_down.mod[24]><&f>
            - define PMinutes <&e><[User].statistic[PLAY_ONE_MINUTE].div[1200].round_down.mod[60]><&f>
            - define FirstDays <&e><util.time_now.duration_since[<[User].first_played_time>].in_days.round_down><&f>
        - else:
            - define PDays <[User].flag[Behr.Essentials.lastPDays]>
            - define PHours <[User].flag[Behr.Essentials.lastPHours]>
            - define PMinutes <[User].flag[Behr.Essentials.lastPMinutes]>
            - define FirstDays <[User].flag[Behr.Essentials.lastFirstDays]>

    # % ██ [ Send Message ] ██
        - Define Text "<proc[User_Display_Simple].context[<[User]>]> <&2>P<&a>laytime<&2>: <[PDays]> <&2>d<&a>ays<&2>, <[PHours]> <&2>h<&a>ours<&2>, <[PMinutes]> <&2>m<&a>inute<&2>s <&b><&pipe> <&2>F<&a>irst <&2>L<&a>ogin: <[FirstDays]> <&2>d<&a>ays <&2>a<&a>go<&2>."
        - narrate <[Text]>

Playtime_Handler:
    type: world
    debug: false
    events:
        on player quits:
        - flag <player> Behr.Essentials.lastPDays:<&e><player.statistic[PLAY_ONE_MINUTE].div[1728000].round_down><&f>
        - flag <player> Behr.Essentials.lastPHours:<&e><player.statistic[PLAY_ONE_MINUTE].div[72000].round_down.mod[24]><&f>
        - flag <player> Behr.Essentials.lastPMinutes:<&e><player.statistic[PLAY_ONE_MINUTE].div[1200].round_down.mod[60]><&f>
        - flag <player> Behr.Essentials.lastFirstDays:<&e><util.time_now.duration_since[<player.first_played_time>].in_days.round_down><&f>
