
enchanted_book_command:
  type: command
  usage: /ebook
  name: ebook
  tab completions:
    1: <server.flag[custom_enchant_data.valid_enchants]>
    2: <list[1|2|3]>
    3: <server.online_players.parse[name]>
  permission: adriftus.staff
  description: gives the player an enchanted book with the specified enchantment name and level
  debug: false
  script:
  - define 3 <context.args.get[3].if_null[<player.name>]>
  - if <context.args.size> < 2:
    - narrate "<&c>Please input a valid enchantment and level."
    - stop
  - if !<server.flag[custom_enchant_data.valid_enchants].contains_any[<context.args.first>]>:
    - narrate "<&c>Please input a valid enchantment."
    - stop
  - if <context.args.get[2]> > <script[<context.args.get[1]>_enchantment].data_key[max_level]> || <context.args.get[2]> < <script[<context.args.get[1]>_enchantment].data_key[min_level]> || !<context.args.get[2].matches_character_set[0123456789]>:
    - narrate "<&c>Please input a valid level for <&6><context.args.get[1]>. <&a><script[<context.args.first>_enchantment].data_key[min_level]> <&c>to <&a><script[<context.args.first>_enchantment].data_key[max_level]>"
    - stop
  - if !<server.online_players.parse[name].contains_any[<[3]>]>:
    - narrate "<&c>Please input a valid player."
    - stop
  - give to:<server.match_player[<[3]>].inventory> <proc[enchanted_book_procedural_generator].context[<context.args.get[1]>|<context.args.get[2]>]>
  - narrate "<&6>Gave <&e><context.args.first> <context.args.get[2].proc[arabic_to_roman]> <&6>to <&e><[3]>"

#TODO Finish this eventually

enchant_fix_command:
  type: task
  usage: /enchant
  permission: adriftus.staff
  name: enchant
  description: trying to fix tab complete
  tab completions:
    1: <server.enchantments.parse[name]>
    2: <list[1|2|3]>
    3: <server.online_players.parse[name]>

  debug: false
  script:
  - define 3 <context.args.get[3].if_null[<player.name>]>
  - if <context.args.size> < 3:
    - narrate "<&c>Please input a valid enchantment and level."
    - stop
  - if !<server.flag[custom_enchant_data.valid_enchants].contains_any[<context.args.first>]>:
    - narrate "<&c>Please input a valid enchantment."
    - stop
  - if <context.args.get[2]> > <script[<context.args.get[1]>_enchantment].data_key[max_level]> || <context.args.get[2]> < <script[<context.args.get[1]>_enchantment].data_key[min_level]> || !<context.args.get[2].matches_character_set[0123456789]>:
    - narrate "<&c>Please input a valid level for <&6><context.args.get[1]>. <&a><script[<context.args.first>_enchantment].data_key[min_level]> <&c>to <&a><script[<context.args.first>_enchantment].data_key[max_level]>"
    - stop
  - if !<server.online_players.parse[name].contains_any[<[3]>]>:
    - narrate "<&c>Please input a valid player."
    - stop
  - give to:<server.match_player[<[3]>].inventory> <proc[enchanted_book_procedural_generator].context[<context.args.get[1]>|<context.args.get[2]>]>
  - narrate "<&6>Gave <&e><context.args.first> <context.args.get[2].proc[arabic_to_roman]> <&6>to <&e><[3]>"
