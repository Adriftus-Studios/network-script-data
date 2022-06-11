clear_inventory_command:
  type: command
  name: clear_inventory
  debug: false
  description: Clears yours or another player<&sq>s inventory
  usage: /clear_inventory (player)
  permission: behr.essentials.clear_inventory
  aliases:
    - clearinv
    - invclear
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
  # % ██ [ check if tryping arguments ] ██
    - if <context.args.is_empty>:
        - define player <player>

  # % ██ [ check if player is truthy  ] ██
    - else if <context.args.size> == 1:
      - define player <server.match_offline_player[<context.args.first>].if_null[null]>
      - if !<[player].is_truthy>:
        - narrate "<&c>Invalid player by the name of <context.args.first>"
        - stop

  # % ██ [ player typed it wrongly    ] ██
    - else:
      - narrate "<&c>Invalid usage - /clear_inventory (player)"

  # % ██ [ clear the inventory        ] ██
    - inventory clear d:<[player].inventory>
    - if <[player]> != <player>:
      - narrate targets:<player> "<&a><[player].name>'s Inventory was cleared"
    - narrate targets:<[player]> "<&a>Inventory cleared"
