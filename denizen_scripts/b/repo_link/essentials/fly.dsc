fly_command:
  type: command
  name: fly
  debug: false
  description: Grants flight to yourself or another player
  usage: /fly (player)
  permission: behr.essentials.fly
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
    - if <context.args.size> > 1:
      - narrate "<&c>Invalid usage. /fly (player)"
      - stop

    - if <context.args.is_empty>:
      - define player <player>
    - else:
      - define player <server.match_offline_player[<context.args.first>].if_null[null]>
      - if !<[player].is_truthy>:
        - narrate "<&c>Invalid player by the name of <context.args.first>"
        - stop

    - adjust <[player]> can_fly:!<[player].can_fly>
    - if <[player]> != <player>:
      - if <[player].can_fly>:
        - narrate "<&a><[player].name> flight enabled"
        - narrate "<&a> Flight enabled" targets:<[player]>
      - else:
        - narrate "<&a><[player].name> flight disabled"
        - narrate "<&a>Flight disabled" targets:<[player]>
    - else:
      - if <player.can_fly>:
        - narrate "<&a>Flight enabled"
      - else:
        - narrate "<&a>Flight disabled"
