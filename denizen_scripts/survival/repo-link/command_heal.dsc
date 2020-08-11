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
        - narrate "<&c>More than one argument was specified, correct usage is /heal (player)"
        - stop
    - if <context.args.is_empty>:
        - heal 20 <player>
        - feed 20 <player>
    - else:
        - define player <server.match_player[<context.args.first>]||null>
        - if <[player]> == null:
            - narrate "<&c>Invalid player, correct usage is /heal (player)"
            - stop
        - heal 20 <[player]>
        - feed 20 <[player]>
