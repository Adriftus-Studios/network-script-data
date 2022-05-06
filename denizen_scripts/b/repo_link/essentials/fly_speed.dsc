fly_speed_command:
  type: command
  debug: false
  name: fly_speed
  usage: /fly_speed (player) <&lt>speed<&gt>
  description: Changes yours or another player<&dq>s fly speed
  script:
    - if <context.args.is_empty>:
      - narrate "<&a>Your fly speed is <player.fly_speed.mul[10].round_to[2]>"
      - stop
    - else if <context.args.size> > 2:
      - narrate "<&c>Invalid syntax - /fly (player) <&lt>speed<&gt>"
      - stop
    - else if !<context.args.first.is_decimal>:
      - define player <server.match_player[<context.args.first>].if_null[null]>
      - if !<[player].is_truthy>:
        - narrate "<&c>Invalid player by the name <context.args.first>"
        - stop

    - define speed <context.args.last>
    - adjust <[player]> fly_speed:<[speed].div[10]>
    - if <[player]> != <player>:
      - narrate "<&a><[player].name>s fly speed set to <[speed]>"
    - narrate targets:<[player]> "<&a>Fly speed set to <[speed]>"
