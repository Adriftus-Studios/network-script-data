gma_Command:
  type: command
  name: gamemode
  debug: false
  description: Adjusts another user or your gamemode
  usage: /gamemode (Player) <&lt>adventure|creative|spectator|survival<&gt>
  permission: behrry.essentials.gamemode
  tab completion: <server.online_players.parse[name]>
  script:
  # % ██ [ check if using too many arguments      ] ██
    - if <context.args.size> > 2:
      - narrate "<&c>Too many arguments"
      - stop

  # % ██ [ check if not using arguments at all    ] ██
    - if <context.args.is_empty>:
      - narrate "<&c>Invalid usage, type a gamemode to switch to.

  # % ██ [ check if using another player          ] ██
    - else if <context.args.size> == 2:
      - define player <server.match_offline_player[<context.args.first>].if_null[null]>

  # % ██ [ check if the player is truthy          ] ██
      - if !<[player].is_truthy>:
        - narrate "<&c>Invalid player by the name of <&dq><context.args.first>"
        - stop
      - else:
        - define player <[player]>
    - else:
      - define player <player>

  # % ██ [ check if using a valid gamemode         ] ██
    - define gamemode <context.args.last>
    - if !<[gamemode].advanced_matches[adventure|creative|spectator|survival]>:
      - narrate "<&c>Invalid gamemode, you want any of <list[adventure|creative|spectator|survival].exclude[<[player].gamemode>].parse[to_titlecase].separated_by[/]>"
      - stop

  # % ██ [ check if already in the gamemode        ] ██
    - if <[player].gamemode> == <[gamemode]>:
      - if <[player]> != <player>:
        - narrate "<&c><[player].name> is already in <[gamemode].to_titlecase>"
      - else:
        - narrate "<&a>You're already in the <[gamemode].to_titlecase>"
      - stop

  # % ██ [ change the gamemode, tell the player(s) ] ██
    - adjust <[player]> gamemode:<[gamemode]>
    - if <[player]> != <player>:
      - narrate "<&a><player.name> set your gamemode to <[gamemode].to_titlecase>"
    - narrate "<&a>Set gamemode to <[gamemode].to_titlecase>"
