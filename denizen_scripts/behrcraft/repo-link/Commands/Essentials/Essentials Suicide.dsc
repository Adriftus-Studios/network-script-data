# | ███████████████████████████████████████████████████████████
# % ██    /suicide - A permanent solution to a temporary problem, for all situations!
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | furnish script | cooldown | Bypass monsters near
Suicide_Command:
    type: command
    name: suicide
    debug: false
    description: Kills yourself.
    usage: /suicide
    permission: behrry.essentials.suicide
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly

    # @ ██ [  Check player's Gamemode ] ██
        - if <list[spectator|creative].contains[<player.gamemode>]>:
            - repeat 10:
                - animate <player> animation:hurt
                - wait 2t
            - adjust <player> health:0
            - stop
    #@ Check for Cooldown
        - if <player.has_flag[Behrry.Essentials.SucideCooldown]> && !<player.in_group[Moderation]>:
            - narrate "<proc[Colorize].context[Suicide Cooldown:|red]> <player.flag[Behrry.Essentials.SucideCooldown].expiration.formatted>"
            - stop

    # @ ██ [  Kill Self ] ██
        - while <player.health> > 0:
            - adjust <player> no_damage_duration:1t
            - hurt <player> 1
            - wait 2t
        - flag player Behrry.Essentials.SucideCooldown duration:12h
