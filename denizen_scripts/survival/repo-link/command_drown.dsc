drown_command:
    type: command
    name: drown
    usage: /drown (player)
    description: plays a drown animation
    permission: adriftus.staff
    script:
    - if <context.args.size> > 1:
        - inject command_syntax
    - else if <context.args.is_empty>:
        - animate animation:HURT_DROWN <player>
    - else:
        - define user <context.args.first>
        - inject player_verification
        - animate animation:HURT_DROWN <[user]>
