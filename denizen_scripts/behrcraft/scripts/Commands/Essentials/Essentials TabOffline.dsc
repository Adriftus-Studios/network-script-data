TabOffline_Command:
    type: command
    name: tabofflinemode
    debug: false
    description: Enables offline player tab-completion for moderation commands
    usage: /tabofflinemode (Player)
    permission: behrry.essentials.tabofflinemode
    aliases:
        - taboffline
        - tomode
        - offlinetab
    tab complete:
        - if <player.groups.in_group[Moderation]>:
            - inject Online_Player_Tabcomplete Instantly
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly
        
    # @ ██ [  Check if specifying a player ] ██
        - if <context.args.get[1]||null> == null:
            - if <player.has_flag[behrry.essentials.tabofflinemode]>:
                - flag <player> behrry.essentials.tabofflinemode:!
            - else:
                - flag <player> behrry.essentials.tabofflinemode
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification_Offline Instantly
            - if <player.groups.in_group[Moderation]>:
                - if <player.has_flag[behrry.essentials.tabofflinemode]>:
                    - flag <[User]> behrry.essentials.tabofflinemode:!
                - else:
                    - flag <[User]> behrry.essentials.tabofflinemode
            - else:
                - narrate "<proc[Colorize].context[<[User].name> is not a moderator.|red]>"
