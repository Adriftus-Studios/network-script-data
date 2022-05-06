friend_command:
  type: command
  name: friend
  debug: false
  description: Adds or removes a player to or from your friends list
  usage: /friend <&lt>player<&gt> (remove)
  permission: behr.essentials.friend
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
    2: remove
  script:
  # % ██ [ check if typing nothing            ] ██
    - if <context.args.is_empty>:
      - if <player.has_flag[behr.essentials.friends]>:
        - narrate "<&a>You have <player.flag[behr.essentials.friends].size> friends<&co><n><player.flag[behr.essentials.friends].parse_tag[<&e>- <&a><[parse_value].name>].separated_by[<n>]>"
      - else:
        - narrate "<&c>You have no friends"
      - stop

  # % ██ [ check if typing too many arguments     ] ██
    - else if <context.args.size> > 2:
      - narrate "<&c>Invalid usage - /friend <&lt>player<&gt> (remove)"
      - stop

  # % ██ [ check the player being used            ] ██
    - else if !<context.args.is_empty>:
      - define player <server.match_offline_player[<context.args.first>].if_null[null]>
      - if !<[player].is_truthy>:
        - narrate "<&c>Invalid player by the name of <context.args.first>"
        - stop

  # % ██ [ check if removing from friends list    ] ██
    - if <context.args.size> == 2:
      - if !<context.args.last.advanced_matches[remove|delete|defriend]>:
        - narrate "<&c>Invalid usage - /friend <&lt>player<&gt> (remove)"

  # % ██ [ check if removing someone not a friend ] ██
      - else if !<player.flag[behr.essentials.friends].contains[<[player]>]>:
        - narrate "<&c><[player].name> isn<&sq>t on your friends list"

  # % ██ [ remove a friend from friends list      ] ██
      - else:
        - flag player behr.essentials.friends.<[player]>:!
        - narrate "<&a>Removed <[player].name> from your friends list"

  # % ██ [ check if player is already a friend    ] ██
    - else:
      - if <player.flag[behr.essentials.friends].contains[<[player]>]>:
        - narrate "<&c><[player].name> is already on your friends list"

  # % ██ [ add a new friend to friends list       ] ██
      - else:
        - flag player behr.essentials.friends.<[player]>:<util.time_now>
        - narrate "<&a>Added<[player].name> to your friends list"
        - if <[player].flag[behr.essentials.friends].contains[<player>]>:
          - narrate "<&2>You're already on their friends list"
