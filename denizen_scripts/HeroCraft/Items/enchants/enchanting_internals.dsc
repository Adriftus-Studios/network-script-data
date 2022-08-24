process_enchantment_data_reload:
  type: world
  debug: false
  events:
    on script reload:
      - run process_enchantment_data_task
      - run enchanting_book_compiler
      - narrate targets:<server.online_players.filter[has_permission[admin]]> <&e>Scripts<&SP><&6>Reloaded.

process_enchantment_data_start:
  type: world
  debug: false
  events:
    on server start:
      - run process_enchantment_data_task
      - run enchanting_book_compiler

process_enchantment_data_task:
  type: task
  debug: false
  script:
    - flag server custom_enchant_data:!
    - foreach <server.scripts.filter[container_type.equals[enchantment]].parse[name]> as:denizen_enchant:
      - if <script[<[denizen_enchant]>].data_key[data.item_slots]||null> == null:
        - foreach next
      - flag server custom_enchant_data.<[denizen_enchant]>.rarity:<script[<[denizen_enchant]>].data_key[rarity]>
      - flag server custom_enchant_data.<[denizen_enchant]>.max:<script[<[denizen_enchant]>].data_key[max_level]>
      - flag server custom_enchant_data.<[denizen_enchant]>.data.item_slots:<script[<[denizen_enchant]>].data_key[data.item_slots]>
      - flag server custom_enchant_data.rarity.<script[<[denizen_enchant]>].data_key[rarity]>:->:<[denizen_enchant]>
      - flag server custom_enchant_data.valid_enchants:->:<[denizen_enchant].before[_enchantment].to_titlecase>
      - flag server custom_enchant_data.valid_enchants_matcher:->:denizen<&co><[denizen_enchant].before[_enchantment].to_titlecase>
    - narrate targets:<server.online_players.filter[has_permission[admin]]> <&e>Enchantment<&SP>Data<&6><&SP>Compiled.

enchanting_book_compiler:
  type: task
  debug: false
  script:
    - define book_pages <list[]>
    - foreach <server.flag[custom_enchant_data.valid_enchants].alphabetical> as:enchant:
      - define title <[enchant].replace_text[_].with[<&sp>]><&co>
      - define rarity Rarity<&co><&sp><script[<[enchant]>_enchantment].data_key[rarity].to_titlecase>
      - define slot Items<&co><&sp><script[<[enchant]>_enchantment].data_key[data.item_slots].separated_by[,<&sp>].replace_text[_].with[<&sp>].to_titlecase>
      - define max_level Maximum<&sp>Level<&co><&sp><script[<[enchant]>_enchantment].data_key[max_level].proc[arabic_to_roman]>
      - define effect Effect<&co><&nl><script[<[enchant]>_enchantment].data_key[data.effect].separated_by[<&nl>].replace_text[_].with[<&sp>]>
      - define book_pages <[book_pages].include[<[title]><&nl><[rarity]><&nl><[slot]><&nl><[max_level]><&nl><&nl><[effect]>]>
    - flag server enchantment_book_pages:<[book_pages]>
    - narrate targets:<server.online_players.filter[has_permission[admin]]> <&e>Enchantment<&SP>Book<&SP><&6>Compiled.


enchant_anvil_renamer:
  type: world
  debug: false
  events:
    on player prepares anvil craft item:
      - if <context.inventory.slot[3].material.name> == air || <context.inventory.slot[2].has_flag[no_custom_enchants]> || <context.inventory.slot[1].has_flag[no_custom_enchants]>:
        - stop
#      - define item_lore <list[]>
#      - foreach <context.item.enchantments>:
#        - define enchantment_name <context.item.enchantments.get[<[loop_index]>].to_titlecase>
#        - define enchantment_level <context.item.enchantment_map.get[<[enchantment_name]>].proc[arabic_to_roman]>
#        - define item_lore <[item_lore].include[<&7><[enchantment_name].replace_text[_].with[<&sp>].to_titlecase><&sp><[enchantment_level]>]>
      - determine passively <context.item.proc[build_item_enchantment_lore]>

enchanted_book_highlighter:
  type: world
  debug: false
  events:
    on player drops enchanted_book:
      - if <server.flag[custom_enchant_data.valid_enchants].contains_any[<context.item.display.after[(].replace_text[<&sp>].with[_].before_last[_].if_null[fail]>]>:
        - adjust <context.entity> custom_name:<context.item.display>
        - adjust <context.entity> custom_name_visible:true
