smite_command:
    type: command
    name: smite
    usage: /smite (player)
    description: hits a player with lightning
    permission: adriftus.staff
    script:
    - if <context.args.size> > 1:
        - inject command_syntax
    - else if <context.args.is_empty>:
        - strike no_damage <player.curson_on>
    - else:
        - define user <context.args.first>
        - inject player_verification
        - strike no_damage <[user].location>
