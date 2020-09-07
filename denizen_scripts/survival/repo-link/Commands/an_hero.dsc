Suicide_Command:
    type: command
    name: suicide
    debug: false
    description: Kills yourself.
    usage: /suicide
    alias:
    - anhero
    permission: adriftus
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

    # % ██ [ Kill Self ] ██
        - define Gamemode <player.gamemode>
        - while <player.health> > 0 && <player.is_online> && <player.gamemode> == <[Gamemode]>:
            - adjust <player> no_damage_duration:1t
            - hurt <player> 1
            - wait 2t
