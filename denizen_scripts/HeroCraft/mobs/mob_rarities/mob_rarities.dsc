mob_rarity_handler:
  type: world
  debug: false
  data:
    ranged: stray|evoker|illusioner|skeleton|blaze
  events:
    after monster spawns:
    - stop if:<context.entity.exists.not>
    - if <context.entity.is_mythicmob.if_null[false]> || <context.entity.has_flag[no_modify]>:
      - stop
    - if <context.entity.entity_type> != creeper:
      - flag <context.entity> emboldable
    - define rarity_roll <util.random.int[1].to[10000].div[10000]>
    - stop if:<[rarity_roll].is_more_than[<server.flag[custom_mob_data.mob_spawn_rates].keys.last>]>
    - foreach <server.flag[custom_mob_data.mob_spawn_rates].keys>:
      - if <[rarity_roll]> <= <[value]>:
        - define rarity <server.flag[custom_mob_data.mob_spawn_rates].get[<[value]>]>
        - foreach stop
    - define suffix_master_list <server.flag[custom_mob_data.valid_suffixes]>
    ## For debugging, modify the server's valid prefix/suffix flags
    - define suffix_master_list <[suffix_master_list].replace[Vortexer].with[Impulsor].replace[leaping].with[Impulsor].replace[clingy].with[Impulsor]> if:<script.data_key[data.ranged].contains_any[<context.entity.entity_type>]>
    - foreach <server.flag[custom_mob_data.valid_prefixes].random[<script[rarity_data_table].data_key[<[rarity]>.prefixes]>]> as:attribute:
      - flag <context.entity> <[attribute]>
      - define prefix_list:->:<[attribute]>
    - foreach <[suffix_master_list].random[<script[rarity_data_table].data_key[<[rarity]>.suffixes]>]> as:attribute:
      - flag <context.entity> <[attribute]>
      - define suffix_list:->:<[attribute]>
    - adjust <context.entity> "custom_name:<script[rarity_data_table].data_key[<[rarity]>.color].parsed><[prefix_list].space_separated.to_titlecase> <context.entity.proc[entity_name]> <[suffix_list].insert[The].at[1].space_separated.to_titlecase.if_null[]>"
    - adjust <context.entity> custom_name_visible:true
    - flag <context.entity> rare_mob:<script[rarity_data_table].data_key[<[rarity]>.slaying]>
    - inject custom_mob_modifier_spawn

custom_mob_modifier_spawn:
  type: task
  debug: false
  script:
    - wait 1t
    - if <[prefix_list].contains_any[fortified]>:
      - health <context.entity> <context.entity.health_max.mul[2]> heal

rarity_data_table:
  type: data
  uncommon:
    color: <&a>
    prefixes: 1
    suffixes: 0
    slaying: 1
  rare:
    color: <&b>
    prefixes: 2
    suffixes: 0
    slaying: 2
  epic:
    color: <&d>
    prefixes: 2
    suffixes: 1
    slaying: 3
  legendary:
    color: <&6>
    prefixes: 2
    suffixes: 2
    slaying: 4
  godly:
    color: <gold><bold>
    prefixes: 5
    suffixes: 3
    slaying: 5
  dread:
    color: <&c><bold>
    prefixes: 8
    suffixes: 4
    slaying: 6
  insane:
    color: <dark_red><bold>
    prefixes: <util.scripts.filter_tag[<[filter_value].starts_with[custom_mob_prefix_]>].size||8>
    suffixes: <util.scripts.filter_tag[<[filter_value].starts_with[custom_mob_suffix_]>].size||4>
    slaying: 10

mob_drop_handler:
  type: world
  debug: false
  events:
    on entity_flagged:rare_mob killed by player:
    - if <context.entity.has_flag[resurrecting]>:
      - stop
    - stop if:<util.random_chance[95]>
    - define drop_type drop
    - if <context.entity.has_flag[explosive]>:
      - define drop_type give
    - if <util.random.int[1].to[10]> > 9:
      - define chance <element[1]>
    - choose <context.entity.flag[rare_mob].add[<[chance]||0>]>:
      - case 1:
        - define rarity common
        - define rarity_color <&f>
      - case 2:
        - define rarity uncommon
        - define rarity_color <&a>
      - case 3:
        - define rarity rare
        - define rarity_color <&b>
      - case 4:
        - define rarity very_rare
        - define rarity_color <&d>
      - case 5 6 7:
        - define rarity very_rare
        - define rarity_color <&d>
        - if <[drop_type]> == drop:
          - repeat 2:
            - inject enchanted_book_mob_drop_compiler
        - if <[drop_type]> == give:
          - repeat 2:
            - inject enchanted_book_mob_give_compiler
        - stop
    - if <[drop_type]> == drop:
      - inject enchanted_book_mob_drop_compiler
    - if <[drop_type]> == give:
      - inject enchanted_book_mob_give_compiler

enchanted_book_mob_drop_compiler:
  type: task
  debug: false
  definitions: rarity|rarity_color
  script:
    - define enchantment <server.flag[custom_enchant_data.rarity.<[rarity]>].random>
    - define level <util.random.int[1].to[<server.flag[custom_enchant_data.<[enchantment]>.max]>]>
    - drop <proc[enchanted_book_procedural_generator].context[<[enchantment].before[_enchantment]>|<[level]>]> <context.entity.location> save:dropped_entity
    - wait 1t
    - adjust <entry[dropped_entity].dropped_entity> custom_name:<[rarity_color].parsed>Enchanted<&sp>Book<&sp>(<[enchantment].before[_enchantment].replace[_].with[<&sp>].to_titlecase><&sp><[level].proc[arabic_to_roman]>)
    - adjust <entry[dropped_entity].dropped_entity> custom_name_visible:true

rarity_info_table:
  type: data
  uncommon: <&a>
  rare: <&b>
  epic: <&d>
  legendary: <&6>
  godly: <gold><bold>
  dread: <&c><bold>
  insane: <dark_red><bold>

enchanted_book_mob_give_compiler:
  type: task
  debug: false
  definitions: rarity
  script:
    - define enchantment <server.flag[custom_enchant_data.rarity.<[rarity]>].random>
    - define level <util.random.int[1].to[<server.flag[custom_enchant_data.<[enchantment]>.max]>]>
    - give <proc[enchanted_book_procedural_generator].context[<[enchantment].before[_enchantment]>|<[level]>]>
    - playsound <player.location> sound:entity_item_pickup

process_mob_data_reload:
  type: world
  debug: false
  events:
    after script reload:
      - run process_mob_attributes_task
    after server start:
      - run process_mob_attributes_task

process_mob_attributes_task:
  type: task
  debug: false
  data:
    spawn_chances:
      uncommon: 10
      rare: 5
      epic: 1
      legendary: 0.5
      godly: 0.1
      dread: 0.01
      insane: 0.001
  script:
    - flag server custom_mob_data:!
    - foreach <util.scripts.filter[name.advanced_matches[custom_mob_prefix_*]].parse[name.after[custom_mob_prefix_]]> as:prefix:
      - flag server custom_mob_data.valid_prefixes:->:<[prefix]>
    - narrate targets:<server.online_players.filter[has_permission[admin]]> <&e>Mob<&SP>Prefix<&SP>Data<&6><&SP>Compiled.
    - foreach <util.scripts.filter[name.advanced_matches[custom_mob_suffix_*]].parse[name.after[custom_mob_suffix_]]> as:suffix:
      - flag server custom_mob_data.valid_suffixes:->:<[suffix]>
    - narrate targets:<server.online_players.filter[has_permission[admin]]> <&e>Mob<&SP>Suffix<&SP>Data<&6><&SP>Compiled.
    - define map <script.data_key[data.spawn_chances].invert>
    - define new_map <map>
    - define total 0
    - foreach <[map].keys.numerical>:
      - define new_map <[new_map].with[<[value].add[<[total]>].div[100]>].as[<[map].get[<[value]>]>]>
      - define total <[total].add[<[value]>]>
    - flag server custom_mob_data.mob_spawn_rates:<[new_map]>

#TO DO:
#custom_mob_prefix_Alchemical_prefix_task:
#  Type: world
#  debug: false
#  events: