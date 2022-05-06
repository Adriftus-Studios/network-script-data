oxygen_command:
  type: command
  name: oxygen
  debug: false
  description: Replinishes or deflates a player<&sq>s oxygen, or your own
  usage: /oxygen (player) <&lt>0-20<&gt>
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
    - if <context.args.is_empty>:
      - oxygen <player.max_oxygen.sub[<player.oxygen.in_ticks>]> mode:add
      - narrate "All of your oxygen was replenished"
      - stop

    - else if <context.args.size> > 2:
      - narrate "<&c>Invalid syntax - /oxygen (player) <&lt>0-20<&gt>"
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

    - if <[oxygen]> > 20:
      - narrate "<&c>Invalid usage - oxygen must be set below 20"
      - stop

    - else if <[oxygen]> < 0:
      - narrate "<&c>Invalid usage - oxygen must be at or above 0"
      - stop

    - if <[oxygen].contains[.]>:
      - narrate "<&c>Invalid usage - oxygen cannot be a decimal"
      - stop

    - if <[player].oxygen.in_ticks> > <[oxygen].mul[20]>:
      - oxygen <[player].oxygen.in_ticks.sub[<[oxygen].mul[20]>]> mode:remove player:<[player]>
      - if <[player]> != <player>:
        - narrate "<&a><[player].name><&sq>s oxygen was deflated"
      - narrate "<&c>Your oxygen deflates" targets:<[player]>

    - else:
      - oxygen <[oxygen].mul[20].sub[<[player].oxygen.in_ticks>]> mode:add player:<[player]>
      - if <[player]> != <player>:
        - narrate "<&a><[player].name><&sq>s oxygen was replenished"
      - narrate "<&c>Your oxygen replenishes" targets:<[player]>
