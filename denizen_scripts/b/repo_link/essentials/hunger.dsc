hunger_command:
  type: command
  name: hunger
  debug: false
  description: Hungers or satiates another player's or your own hunger
  usage: /hunger (player) <&lt>#<&gt>
  permission: behr.essentials.hunger
  aliases:
    - feed
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
  # % ██ [ check if typing too many or no arguments ] ██
    - if <context.args.is_empty> || <context.args.size> > 2:
      - narrate "<&c>Invalid usage - /hunger (player) <&lt>#<&gt>"
      - stop

  # % ██ [ check if using self or named player      ] ██
    - if <context.args.size> == 1:
      - define player <player>
      - define level <context.args.first>

    - else:
      - define player <server.match_player[<context.args.first>].if_null[null]>
      - if !<[player].is_truthy>:
        - narrate "<&c>Invalid player by the name of <context.args.first>"
        - stop
      - define level <context.args.last>

  # % ██ [ check hunger level ] ██
    - if !<[level].is_integer>:
      - narrate "<&c>Hunger must be a number"
      - stop

    - if <[level]> > 20:
      - narrate "<&c>Hunger must be less than 20"
      - stop

    - if <[level]> < 0:
      - narrate "<&c>Hunger must be between 0-20"
      - stop

    - if <[level].contains_text[.]>:
      - narrate "<&c>Hunger cannot be a decimal"
      - stop

  # % ██ [ check food adjustment direction & narrate ] ██
  # % ██ [ satiate hunger                            ] ██
    - if <[player].food_level> > <[level]>:
      - if <[player]> != <player>:
        - narrate "<&a><[player].name>'s hunger was satiated"
      - narrate targets:<[player]> "<&a>Your hunger was satiated"

  # % ██ [ did nothing / stayed the same             ] ██
    - else if <[player].food_level> == <[level]>:
      - narrate "<&e>Nothing interesting happens"
      - stop

  # % ██ [ starve the player                         ] ██
    - else if <[player].food_level> < <[level]>:
      - if <[player]> != <player>:
        - narrate "<[player].name><&sq>s hunger was intensified"
      - narrate targets:<[player]> "<&c>Your hunger intensifies"

  # % ██ [ adjust the satiation and food level       ] ██
    - adjust <[player]> food_level:<[level]>
    - feed <[player]> saturation:20
