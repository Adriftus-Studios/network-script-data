gma_Command:
    type: command
    name: gma
    debug: false
    description: Adjusts your gamemode to Adventure Mode.
    admindescription: Adjusts another players or your own gamemode to Adventure Mode
    usage: /gma
    adminusage: /gma (Player)
    permission: behrry.essentials.gma
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - inject Online_Player_Tabcomplete Instantly
    script:
    # % ██ [   Check Args ] ██
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly
        
    # % ██ [   Check if specifying Player ] ██
        - if <context.args.first||null> == null:
            - define User <player>
        - else:
        # % ██ [   Check if player is a moderator ] ██
            - if <player.groups.contains[Moderation]>:
                - define User <context.args.first>
                - inject Player_Verification Instantly
            - else:
                - inject Admin_Permission_Denied Instantly

    # % ██ [   Check User's Gamemode ] ██
        - if <[User].gamemode> == Adventure:
            - if <[User]> == <player>:
                - narrate targets:<player> "<proc[Colorize].context[You are already in Adventure Mode.|red]>"
            - else:
                - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is already in Adventure Mode.|red]>"
        - else:
            - if <[User]> != <player>:
                - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context['s Gamemode changed to:|red]> <&e>Adventure"
            - else:
                - narrate targets:<[User]> "<proc[Colorize].context[Gamemode changed to:|green]> <&e>Adventure"
            - adjust <[User]> gamemode:Adventure
