# | ███████████████████████████████████████████████████████████
# % ██    /unban - returns you to where you teleported from
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | furnish script, create out of combat bypass | cooldown | Bypass monsters near
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
        #@ Verify args
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly
        - define User <context.args.get[1]>
        - inject Player_Verification_Offline Instantly

        #@ Verify if banned
        - if !<[User].is_banned>:
            - narrate format:Colorize_Red "Player is not banned."
            - stop
        - else:
            - ban remove <[User]>
            - announce format:Colorize_Green "<[User].name> was unbanned."