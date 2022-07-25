dummy_economy:
  type: economy
  debug: false
  priority: normal
  name single: dollar
  name plural: dollars
  digits: 2
  format: $<[amount]>
  balance: <player.flag[money].if_null[<server.flag[money.<[player]>].if_null[0]>]>
  has: <player.flag[money].is[or_more].than[<[amount]>].if_null[<server.flag[money.<[player]>].is[or_more].than[<[amount]>]>]>
  withdraw:
    - if <player.exists>:
      - if <script.parsed_key[has]>:
        - flag <player> money:-:<[amount]>
      - else:
        - determine "<&c>Insufficient Funds"
    - else:
      - flag server money.<[player]>:-:<[amount]>
  deposit:
    - if <player.exists>:
      - flag <player> money:+:<[amount]>
    - else:
      - flag server money.<[player]>:+:<[amount]>

bal_command:
  type: command
  name: balance
  description: Used to change gamemode adventure
  usage: /balance (Name)
  debug: false
  aliases:
  - bal
  script:
  - if !<player.has_permission[adriftus.staff]> || <context.args.is_empty>:
        - narrate "<green>You have <player.formatted_money> coins"
        - stop
  - define player <server.match_player[<context.args.first>].if_null[null]>
  - if <[player]> == null:
    - narrate "<red><bold>Please Use A Name Who is Online"
    - stop
  - else:
    - narrate "<green><[Player].name.to_uppercase> has <[player].formatted_money>"
    - stop