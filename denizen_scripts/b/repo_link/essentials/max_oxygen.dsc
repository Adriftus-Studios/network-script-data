max_oxygen_command:
  type: command
  name: max_oxygen
  debug: false
  description: Changes another player or your maximum oxygen capacity in seconds
  usage: /max_oxygen (player) <&lt><&ns>/default<&gt>
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name].include[default]>
    2: default
  script:
    - if <context.args.is_empty>:
      - narrate "<&c>Invalid syntax - /max_oxygen (player) <&lt><&ns>/default<&gt>"
      - stop

    - else if <context.args.size> > 2:
      - narrate "<&c>Invalid syntax - /max_oxygen (player) <&lt><&ns>/default<&gt>"
      - stop

    - else if <context.args.size> == 2:
      - define player <server.match_player[<context.args.first>].if_null[null]>
      - if !<[player].is_truthy>:
        - narrate "<&c>Invalid player by the name <context.args.first>"
        - stop

      - define oxygen <context.args.last>

    - else if <context.args.size> == 1:
      - define player <player>
      - define oxygen <context.args.first>

    - else if !<[oxygen].is_integer>:
      - narrate "<&c>Invalid usage - oxygen must be a number"
      - stop

    - if <[oxygen]> > 2000:
      - narrate "<&c>Invalid usage - oxygen must be set below 2000"
      - stop

    - else if <[oxygen]> < 0:
      - narrate "<&c>Invalid usage - oxygen must be at or above 0"
      - stop

    - if <[oxygen].contains[.]>:
      - narrate "<&c>Invalid usage - oxygen cannot be a decimal"
      - stop

    - if <[player].max_oxygen.in_seconds> > <[oxygen]>:
      - oxygen <[oxygen].mul[20]> type:maximum player:<[player]>
      - oxygen <[oxygen].mul[20]> mode:set player:<[player]>
      - if <[player]> != <player>:
        - narrate "<&a><[player].name><&sq>s maximum oxygen was deflated"
      - narrate "<&c>Your oxygen deflates and is now lower capacity" targets:<[player]>

    - else:
      - oxygen <[oxygen].mul[20]> mode:maximum player:<[player]>
      - oxygen <[oxygen].mul[20]> mode:set player:<[player]>
      - if <[player]> != <player>:
        - narrate "<&a><[player].name><&sq>s maximum oxygen was inflated"
      - narrate "<&c>Your oxygen replenishes and is now higher capacity" targets:<[player]>
