gms_Command:
    type: command
    name: gms
    debug: false
    description: Adjusts your gamemode to Survival Mode.
    admindescription: Adjusts another players or your own gamemode to Survival Mode
    usage: /gms
    adminusage: /gms (Player)
    permission: behrry.essentials.gms
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - inject Online_Player_Tabcomplete Instantly
    script:
    # % ██ [   Check Args ] ██
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly
        
    # % ██ [   Check if specifying Player ] ██
        - if <context.args.is_empty>:
            - define User <player>
        - else:
        # % ██ [   Check if player is a moderator ] ██
            - if <player.groups.contains[Moderation]>:
                - define User <context.args.first>
                - inject Player_Verification Instantly
            - else:
                - inject Admin_Permission_Denied Instantly

    # % ██ [   Check User's Gamemode ] ██
        - if <[User].gamemode> == Survival:
            - if <[User]> == <player>:
                - narrate targets:<player> "<proc[Colorize].context[You are already in Survival Mode.|red]>"
            - else:
                - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is already in Survival Mode.|red]>"
        - else:
            - if <[User]> != <player>:
                - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context['s Gamemode changed to:|red]> <&e>Survival"
            - else:
                - narrate targets:<[User]> "<proc[Colorize].context[Gamemode changed to:|green]> <&e>Survival"
            - adjust <[User]> gamemode:Survival
