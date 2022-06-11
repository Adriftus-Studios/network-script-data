######################################
#####                            #####
#####                            #####
#####     Enchanting Systems     #####
#####                            #####
#####                            #####
######################################

enchanted_book_procedural_generator:
  type: procedure
  definitions: enchant|level
  debug: false
  script:
  - define rarity_color_slot <server.enchantments.parse[name].find[<[enchant]>]>
  - choose <server.enchantments.get[<[rarity_color_slot]>].rarity>:
    - case COMMON:
      - define color <&a>
    - case UNCOMMON:
      - define color <&b>
    - case RARE:
      - define color <&d>
    - case VERY_RARE:
      - define color <&6>
  - determine enchanted_book[display_name=<[color]>Enchanted<&sp>Book<&sp>(<[enchant].replace[_].with[<&sp>].to_titlecase><&sp><[level].proc[arabic_to_roman]>);enchantments=<[enchant]>,<[level]>;lore=<&7><[enchant].replace[_].with[<&sp>].to_titlecase><&sp><[level].proc[arabic_to_roman]>]


loot_table_lore_fixer:
  type: world
  debug: false
  events:
    on loot generates:
      - define loot_to_add <list[]>
      - foreach <context.items> as:item:
        - if <server.scripts.filter[container_type.equals[enchantment]].parse[name.before[_enchantment]].contains_any[<[item].enchantments>]>:
          - define item_lore <list[]>
          - foreach <[item].enchantments>:
            - define enchantment_name <[item].enchantments.get[<[loop_index]>].to_titlecase>
            - define enchantment_level <[item].enchantment_map.get[<[enchantment_name]>].proc[arabic_to_roman]>
            - define item_lore <[item_lore].include[<&7><[enchantment_name].replace[_].with[<&sp>].to_titlecase><&sp><[enchantment_level]>]>
            - define loot_to_add <[loot_to_add].include[<[item].with[lore=<[item_lore]>].with[hides=ENCHANTS]>]>
            - foreach next
          - foreach next
        - define loot_to_add <[loot_to_add].include[<[item]>]>
      - determine passively LOOT:<[loot_to_add]>

enchantment_table_lore_fixer:
  type: world
  debug: false
  events:
    on item enchanted:
      - define enchantment_map <map>
      - narrate <context.enchants>
      - if !<server.scripts.filter[container_type.equals[enchantment]].parse[name.before[_enchantment]].contains_any[<context.enchants.keys>]>:
        - stop
      - define lore_list <list[]>
      - foreach <context.enchants> as:enchant_level key:enchant_applied:
        - if <server.scripts.filter[container_type.equals[enchantment]].parse[name.before[_enchantment]].contains_any[<[enchant_applied]>]>:
          - define enchantment_map <[enchantment_map].with[<[enchant_applied]>].as[<[enchant_level]>]>
          - define lore_list <[lore_list].include[<&7><[enchant_applied].replace[_].with[<&sp>].to_titlecase><&sp><[enchant_level].proc[arabic_to_roman]>]>
      - determine passively result:<context.item.with[lore=<[lore_list]>].with[hides=enchants]>


enchantment_explainer_book_item:
  type: item
  material: written_book
  mechanisms:
    book_title: Custom Enchantments and You!
    book_author: Eutherin
    book_pages: <server.flag[enchantment_book_pages]>

enchantment_book_updater:
  type: world
  debug: false
  events:
    on player clicks lectern:
      - if <context.location.has_flag[enchanting_book_lectern]>:
        - determine passively cancelled
        - adjust <player> show_book:enchantment_explainer_book_item[book_pages=<server.flag[enchantment_book_pages]>]
        - if !<player.inventory.list_contents.parse[script.name].contains_any[enchantment_explainer_book_item]>:
          - give enchantment_explainer_book_item
          - repeat 3:
            - playsound sound:ITEM_BOOK_PAGE_TURN <player.location>
            - wait <util.random.int[3].to[8]>t
