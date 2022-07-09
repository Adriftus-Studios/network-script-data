dummy_economy:
  type: economy
  debug: false
  priority: normal
  name single: dollar
  name plural: dollars
  digits: 2
  format: $<[amount]>
  balance: <player.flag[money].if_null[<server.flag[money.<[player]>]>]>
  has: <player.flag[money].is[or_more].than[<[amount]>].if_null[<server.flag[money.<[player]>]>]>
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