gmsp_Command:
    type: command
    name: gmsp
    debug: false
    description: Adjusts your gamemode to Spectator Mode.
    admindescription: Adjusts another players or your own gamemode to Spectator Mode
    usage: /gmsp
    adminusage: /gmsp (Player)
    permission: behrry.essentials.gmsp
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
        - if <[User].gamemode> == Spectator:
            - if <[User]> == <player>:
                - narrate targets:<player> "<proc[Colorize].context[You are already in Spectator Mode.|red]>"
            - else:
                - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is already in Spectator Mode.|red]>"
        - else:
            - if <[User]> != <player>:
                - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context['s Gamemode changed to:|red]> <&e>Spectator"
            - else:
                - narrate targets:<[User]> "<proc[Colorize].context[Gamemode changed to:|green]> <&e>Spectator"
            - adjust <[User]> gamemode:Spectator
