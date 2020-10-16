TabOffline_Command:
    type: command
    name: tabofflinemode
    debug: false
    description: Enables offline player tab-completion for moderation commands
    usage: /tabofflinemode (Player)
    permission: Behr.Essentials.Tabofflinemode
    aliases:
        - taboffline
        - tomode
        - offlinetab
    tab complete:
        - if <player.in_group[Moderation]>:
            - inject Online_Player_Tabcomplete
    script:
    # % ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax

        - if <context.args.size> > 1:
            - inject Command_Syntax

    # % ██ [ Check if specifying a player ] ██
        - if <context.args.size> == 1:
            - if <player.has_flag[Behr.Essentials.tabofflinemode]>:
                - flag <player> Behr.Essentials.tabofflinemode:!
            - else:
                - flag <player> Behr.Essentials.tabofflinemode
        - else:
            - define User <context.args.first>
            - inject Player_Verification_Offline
            - if <player.in_group[Moderation]>:
                - if <player.has_flag[Behr.Essentials.tabofflinemode]>:
                    - flag <[User]> Behr.Essentials.tabofflinemode:!
                - else:
                    - flag <[User]> Behr.Essentials.tabofflinemode
            - else:
                - narrate "<proc[Colorize].context[<[User].name> is not a moderator.|red]>"
