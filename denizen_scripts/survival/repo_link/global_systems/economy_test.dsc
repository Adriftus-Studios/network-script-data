test_economy:
  type: economy
  priority: normal
  # The name of the currency in the singular (such as dollar or euro).
  name single: dollar
  # The name of the currency in the plural (such as dollars or euros).
  name plural: dollars
  # How many digits after the decimal to include. For example, '2' means '1.05' is a valid amount, but '1.005' will be rounded.
  digits: 2
  # Format the standard output for the money in human-readable format. Use <amount> for the actual amount to display.
  # Fully supports tags.
  format: $<amount.format_number>
  # A tag that returns the balance of a linked player. Use a 'proc[]' tag if you need more complex logic.
  # Must return a decimal number.
  balance: <player.flag[money]||0>
  # A tag that returns a boolean indicating whether the linked player has the amount specified by auto-tag <amount>.
  # Use a 'proc[]' tag if you need more complex logic.
  # Must return 'true' or 'false'.
  has: <player.flag[money].is[or_more].than[<amount>]>
  # A script that removes the amount of money needed from a player.
  # Note that it's generally up to the systems calling this script to verify that the amount can be safely withdrawn, not this script itself.
  # However you may wish to verify that the player has the amount required within this script.
  # The script may determine a failure message if the withdraw was refused. Determine nothing for no error.
  # Use def 'amount' for the amount to withdraw.
  withdraw:
  - flag <player> money:-:<[amount]>
  # A script that adds the amount of money needed to a player.
  # The script may determine a failure message if the deposit was refused. Determine nothing for no error.
  # Use def 'amount' for the amount to deposit.
  deposit:
  - flag <player> money:+:<[amount]>

economy_initialize:
  type: world
  events:
    on player joins:
    - if !<player.has_flag[money]>:
      - flag player money:400

economy_balance_check_command:
  type: command
  name: balance
  aliases:
    - bal
    - money
  script:
    - narrate <&2>----------------------------
    - narrate "<&a>Coins: <&e><player.money.round_to[2]>"
    - narrate "<&a>Adriftus Coins: <&e>0"
    - narrate <&2>----------------------------
  
economy_balance_top:
  type: command
  name: balance_top
  aliases:
    - baltop
    - balancetop
    - richest
  script:
    - narrate <&a>-----------------------------
    - narrate "<&a>----    Top Balances    -----"
    - narrate <&a>-----------------------------
    - foreach <server.players.filter[flag[money].is[!=].to[null]].sort_by_number[money].reverse.get[1].to[10]>:
      - narrate "<&e><[loop_index]>. <[value].name><&co> <&b><server.economy.format[<[value].flag[money].round_to[2]>]>"

economy_bank_note:
  type: item
  material: paper
  display name: <&a>Bank Note
  lore:
  - "<&e>Right click while holding to deposit."

economy_bank_note_events:
  type: world
  events:
    on player right clicks with:economy_bank_note:
    - ratelimit <player> 2t
    - narrate "<&b>You have deposited <&a><server.economy.format[<context.item.nbt[value]>]> into your account!"
    - give money quantity:<context.item.nbt[value]>
    - wait 1t
    - take <context.item>

economy_withdraw:
  type: command
  name: withdraw
  script:
    - define amount <context.args.first||null>
    - if <[amount]> == null:
      - narrate "<&c>You must specify how much you want to withdraw."
      - stop
    - else if <player.money> < <[amount]>:
      - narrate "<&c>You don't have enough money."
      - stop
    - money take quantity:<[amount]>
    - give "<item[economy_bank_note].with[nbt=value/<[amount]>;lore=<&a>------------------------|<&e>Value<&co> <&a><server.economy.format[<[amount]>]>|<&e>Right click while holding to deposit.|<&a>------------------------]>"
    - narrate "<&b>You have withdrawn <&a><server.economy.format[<[amount]>]><&b> from your account."
    - narrate "<&b>Check your inventory for the bank note."

economy_pay:
  type: command
  name: pay
  tab complete:
    - determine <server.online_players.parse[name].filter[to_lowercase.starts_with[<context.raw_args.before_last[<&sp>].to_lowercase>]]>
  script:
    - if <context.args.size> != 2:
      - inject command_syntax
    - define amount <context.args.get[2]>
    - define payee <context.args.first>
    - if !<[amount].is_integer>:
      - narrate "<&c>You must specify how much you want to pay."
      - stop
    - else if <player.money> < <[amount]>:
      - narrate "<&c>You don't have enough money for that."
      - stop
    - else if <player.name.to_lowercase> == <[payee].to_lowercase>:
      - narrate "<&c>You cannot pay yourself money."
      - stop
    - else if <[amount]> < 0:
      - narrate "<&c>You cannot pay a negative amount."
      - stop
    - define user <context.args.first>
    - inject Player_Verification
    - money take quantity:<[amount]> from:<player>
    - money give quantity:<[amount]> to:<[user]>
    - narrate "<&c>You have paid <[user].display_name> <&a><server.economy.format[<[amount]>]><&c> from your account." targets:<player>
    - narrate "<&c>You have been paid <&a><server.economy.format[<[amount]>]><&c> from <player.display_name>." targets:<[user]>
