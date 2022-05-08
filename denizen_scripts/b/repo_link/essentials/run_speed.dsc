run_speed_command:
  type: command
  name: run_speed
  debug: false
  description: adjusts your run-speed up to 10.
  usage: /run_speed (player) <&lt><&ns><&gt>/default
  aliases:
    - walk_speed
  permission: behr.essentials.run_speed
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name].include[default]>
    2: default
  script:
    - if <context.args.size> > 2:
      - narrate "<&c>Invalid usage - /run_speed (player) <&lt><&ns><&gt>/default"
      - stop

    - else if <context.args.is_empty>:
      - narrate "<&a>Your <context.alias.before[_]> is <player.walk_speed.mul[10].round_to[2]>"
      - stop

    - else if <context.args.size> == 2:
      - define player <server.match_player[<context.args.first>].if_null[null]>
      - if !<[player].is_truthy>:
        - narrate "<&c>Invalid player by the name of <context.args.first>"
        - stop
      - define speed <context.args.last>

    - else:
      - define player <player>
      - define speed <context.args.last>

    - if <[speed].is_decimal>:
      - narrate "<&c>Invalid usage - speed has to be a number"
      - stop

    - else if <[speed]> > 10:
      - narrate "<&c>Invalid usage - speed must be below 10"
      - stop

    - else if <[speed]> < 0:
      - narrate "<&c>Invalid usage - speed must be at or above 0"
      - stop

    - else if <[speed]> == <[player].walk_speed.mul[10]>:
      - narrate "<&e>Nothing interesting happens"
      - stop

    - adjust <[player]> walk_speed:<[speed].div[10]>
    - if <[player]> != <player>:
      - narrate "<[player].name><&sq>s <context.alias.before[_]> speed set to <[speed]>"
    - narrate targets:<[player]> "<context.alias.before[_]> speed set to <[speed]>"
