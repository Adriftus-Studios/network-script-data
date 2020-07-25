Suicide_Command:
    type: command
    name: suicide
    debug: false
    description: Kills yourself.
    usage: /suicide
    permission: Behr.Essentials.Suicide
    script:
    # % ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax

    # % ██ [ Check player's Gamemode ] ██
        - if <list[spectator|creative].contains[<player.gamemode>]>:
            - repeat 10:
                - animate <player> animation:hurt
                - wait 2t
            - adjust <player> health:0
            - stop
    # % ██ [ Check for Cooldown ] ██
        - if <player.has_flag[Behr.Essentials.SucideCooldown]> && !<player.in_group[Moderation]>:
            - narrate "<proc[Colorize].context[Suicide Cooldown:|red]> <player.flag[Behr.Essentials.SucideCooldown].expiration.formatted>"
            - stop

    # % ██ [ Kill Self ] ██
        - while <player.health> > 0:
            - adjust <player> no_damage_duration:1t
            - hurt <player> 1
            - wait 2t
        - flag player Behr.Essentials.SucideCooldown duration:12h
