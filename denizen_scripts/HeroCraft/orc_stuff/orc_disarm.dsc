orc_disarm_command:
  type: command
  name: orcdisarm
  usage: /orcdisarm player
  description: drops the players held item
  Permission: adriftus.admin
  script:
    - define player <server.match_player[<context.args.get[1]>]>
    - if <[player]||null> != null && <[player].item_in_hand||null> != null:
      - define item <[player].item_in_hand>
      - take <[item]> from:<[player].inventory>
      - wait 10t
      - drop <[item]> <[player].location>
