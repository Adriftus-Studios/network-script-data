head_command:
  type: command
  name: head
  debug: false
  description: Gives yours or another player<&sq>s head.
  usage: /head (player)
  permission: behr.essentials.head
  script:
  # % ██ [ check if not using arguments ] ██
    - if <context.args.is_empty>:
      - give <player.skull_item>
      - stop

  # % ██ [ give head                    ] ██
    - define player <server.match_offline_player[<context.args.first>].if_null[null]>

    - give player_head[skull_skin=<[player].name>]
