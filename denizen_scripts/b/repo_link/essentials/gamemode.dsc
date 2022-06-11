gamemode_command:
  type: command
  name: gamemode
  debug: false
  description: Adjusts another user or your gamemode
  usage: /gamemode (player) <&lt>adventure|creative|spectator|survival<&gt>
  permission: behr.essentials.gamemode
  tab completions:
    1: <server.online_players.parse[name].exclude[<player.name>].include[<list[adventure|creative|spectator|survival].exclude[<player.gamemode>]>]>
    2: <list[adventure|creative|spectator|survival].exclude[<server.match_player[<context.args.first>].gamemode.if_null[invalid]>]>
  aliases:
    - gma
    - gmc
    - gms
    - gmsp
  script:
  # % ██ [ check if using too many arguments      ] ██
    - if <context.args.size> > 2:
      - narrate "<&c>Too many arguments"
      - stop

  # % ██ [ check if not using arguments at all    ] ██
    - if <context.args.is_empty>:

  # % ██ [ check if using a shorthand alias       ] ██
      - define alias_map <map[gma=adventure;gmc=creative;gms=survival;gmsp=spectator]>
      - define gamemode <[alias_map].get[<context.alias>]>
      - if !<context.alias.advanced_matches[<[alias_map].keys>]>:
        - narrate "<&c>Invalid gamemode, you want any of <list[adventure|creative|spectator|survival].exclude[<player.gamemode>].parse[to_titlecase].separated_by[/]>"
        - stop

  # % ██ [ check if already in the gamemode       ] ██
      - if <player.gamemode.advanced_matches[<[gamemode]>]>:
        - narrate "<&a>You're already in <[gamemode].to_titlecase>"
        - stop

  # % ██ [ change the gamemode, tell the player   ] ██
      - adjust <player> gamemode:<[gamemode]>
      - narrate "<&a>Set gamemode to <[gamemode].to_titlecase>"
      - stop

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
        - narrate "<&a>You're already in <[gamemode].to_titlecase>"
      - stop

  # % ██ [ change the gamemode, tell the player(s) ] ██
    - adjust <[player]> gamemode:<[gamemode]>
    - if <[player]> != <player>:
      - narrate "<&a><player.name> set your gamemode to <[gamemode].to_titlecase>"
    - narrate "<&a>Set gamemode to <[gamemode].to_titlecase>"
