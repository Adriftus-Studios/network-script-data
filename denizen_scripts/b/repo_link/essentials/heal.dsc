heal_command:
  type: command
  name: heal
  debug: false
  description: Heals a player or yourself
  usage: /heal (player)
  permission: behr.essentials.heal
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
    - if <context.args.is_empty>:
      - define player <player>

    - else if <context.args.size> == 1:
      - define player <server.match_player[<context.args.first>].if_null[null]>
      - if !<[player].is_truthy>:
        - narrate "<&c>Invalid player by the name of <context.args.first>"
        - stop

    - else:
      - narrate "<&c>Invalid syntax - /heal (player)"
      - stop

    - heal <[player]>
    - adjust <[player]> food_level:20
    - if <[player]> != <player>:
        - narrate "<[player].name> was healed"
    - narrate targets:<[player]> "You were healed"
