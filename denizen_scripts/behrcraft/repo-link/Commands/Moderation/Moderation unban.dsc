Unban_Command:
    type: command
    name: unban
    debug: false
    description: Unbans a player.
    usage: /unban <&lt>Player<&gt>
    permission: behrry.moderation.unban
    tab complete:
        - inject All_Player_Tabcomplete Instantly
    script:
    # % ██ [ Verify args ] ██
        - if <context.args.is_empty>:
            - inject Command_Syntax Instantly
        - define User <context.args.first>
        - inject Player_Verification_Offline Instantly

    # % ██ [ Verify if banned ] ██
        - if !<[User].is_banned>:
            - narrate format:Colorize_Red "Player is not banned."
            - stop
        - else:
            - ban remove <[User]>
            - announce format:Colorize_Green "<[User].name> was unbanned."
