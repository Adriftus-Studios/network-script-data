ping_command:
  type: command
  name: ping
  debug: false
  description: Shows yours, or another player's ping
  usage: /ping (player)
  permission: behr.essentials.ping
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
  # % ██ [ check if player is typing too much    ] ██
    - if <context.args.size> > 1:
      - narrate "<&c>Invalid usage - /ping (player)"

  # % ██ [ check if typing another player or not ] ██
    - if <context.args.is_empty>:
      - narrate "<&a>Your ping is <player.ping>"

    - else:
      - define player <server.match_player[<context.args.first>].if_null[null]>
      - if !<[player].is_truthy>:
        - narrate "<&c>Invalid player by the name of <context.args.first>"
        - stop

      - narrate "<[player].name><&sq>s ping is <[player].ping>"
