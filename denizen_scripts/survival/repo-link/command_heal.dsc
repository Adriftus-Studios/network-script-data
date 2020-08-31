heal_command:
    type: command
    name: heal
    aliases:
    - feed
    usage: /heal (player)
    description: Heals a player
    permission: adriftus.staff
    script:
    - if <context.args.size> > 1:
        - inject command_syntax
    - if <context.args.is_empty>:
        - heal <player>
        - feed 20 <player>
    - else:
        - define user <context.args.first>
        - inject player_verification
        - heal <[user]>
        - feed 20 <[user]>
