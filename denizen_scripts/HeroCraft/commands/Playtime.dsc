command_playtime:
  type: command
  name: playtime
  description: Used to find Playtime of player
  usage: /playtime (Name)
  script:
  - if !<player.has_permission[adriftus.staff]> || <context.args.size> < 1:
      - narrate "<&e>You have played for <&b><duration[<player.statistic[PLAY_ONE_MINUTE]>t].formatted><&e>."
      - stop
  - else:
    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> = null:
      - narrate "<&c>Unknown Player<&co><&e> <context.args.get[1]>"
      - stop
    - else:
      - narrate "<&a><[target].name> has played for <duration[<player.statistic[PLAY_ONE_MINUTE]>t].formatted><&e>."


