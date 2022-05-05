smite_command:
  type: command
  debug: false
  name: smite
  command: smite
  usage: /smite (tool/player)
  description: Smites a player by name, or gives you the smite stick
  permission: smite
  script:
    - if !<player.advanced_matches[<list[xeane|kyu|Drunken_Scot|_behr|aj_4real|mutim|Grumblinn].parse_tag[<server.match_player[<[parse_value]>].if_null[invalid]>]>]>:
      - narrate "<&e>nothing interesting happens."
      - stop

    - if <context.args.is_empty>:
      - give smite_stick
      - narrate "<&a>You've been given the powered Stick of Smite"
    - else if <context.args.size> > 1:
      - narrate "<&c>Invalid usage - <&6>/<&e>smite <&6>(<&e>tool<&6>/<&e>player<&6>)"
    - else if <context.args.first> == tool:
      - give smite_stick
      - narrate "<&a>You've been given the powered Stick of Smite"
    - else:
      - define player <context.args.first>
      - if <server.match_player[<[player]>].is_truthy>:
        - strike <[player].location>
      - else:
        - narrate "<&c>Invalid player by the name<&4><&co> <context.args.first>"

smite_stick:
  type: item
  debug: false
  material: stick
  display name: <&6>Smite St<&e>i<&6>ck
  lore:
    - Click to Smite!

smite_stick_handler:
  type: world
  debug: false
  events:
    on player clicks block with:smite_stick:
      - stop if:!<player.advanced_matches[<list[xeane|kyu|Drunken_Scot|_behr|aj_4real|mutim|Grumblinn].parse_tag[<server.match_player[<[parse_value]>].if_null[invalid]>]>]>
      - if <player.target.is_truthy>:
        - strike <player.target.location>
      - else:
        - strike <player.cursor_on.if_null[<player.location.forward[10].highest>]>
