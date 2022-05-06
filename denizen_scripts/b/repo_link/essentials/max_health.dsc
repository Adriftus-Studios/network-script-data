max_health_command:
  type: command
  name: max_health
  debug: false
  description: Adjusts another player's or your max health from 1 to 100.
  usage: /max_health (player) <&lt>1-100<&gt>
  aliases:
    - maxhp
  permission: behr.essentials.max_health
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
  # % ██ [ check if typing too many or no arguments ] ██
    - if <context.args.is_empty> || <context.args.size> > 2:
      - narrate "<&c>Invalid usage - /max_health (player) <&lt>1-100<&gt>"
      - stop

  # % ██ [ check if specifying another player       ] ██
    - if <context.args.size> == 2:
      - define player <server.match_player[<context.args.first>].if_null[null]>
      - if !<[player].is_truthy>:
        - narrate "<&c>Invalid player by the name of <context.args.first>"
        - stop
      - define max_hp <context.args.last>

    # % ██ [ default to using themself              ] ██
    - else:
      - define player <player>
      - define max_hp <context.args.first>


  # % ██ [ check maximum health input               ] ██
    - if !<[max_hp].is_integer>:
      - narrate "<&c>Invalid usage - Health is measured as a number."
      - stop

    - if <[max_hp]> < 1:
      - narrate "<&c>Invalid usage - Health cannot be negative or below 1."
      - stop

    - if <[max_hp].contains[.]>:
      - narrate "<&c>Invalid usage - Health cannot have a decimal."
      - stop

    - if <[max_hp]> > 100:
      - narrate "<&c>Invalid usage - Health can range up to 100."
      - stop

  # % ██ [ adjust player's maximum health           ] ██
    - adjust <[player]> max_health:<[max_hp]>
    - if <[player]> != <player>:
      - narrate "<[player].name><&sq>s maximum health adjusted to <[max_hp]>"
    - narrate targets:<[player]> "Maximum health adjusted to <[max_hp]>"
