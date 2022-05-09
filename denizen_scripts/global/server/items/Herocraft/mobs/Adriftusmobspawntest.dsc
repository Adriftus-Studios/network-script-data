mob_rarity_handler:
  type: world
  debug: false
  data:
    ranged: stray|evoker|illusioner|skeleton|blaze
  events:
    after monster spawns:
    - stop if:<context.entity.exists.not>
    - if <context.entity.is_mythicmob> || <context.entity.from_spawner> || <context.entity.has_flag[no_modify]>:
      - stop
    - if <context.entity.entity_type> != creeper:
      - flag <context.entity> emboldable
    - define rarity_roll <util.random.int[1].to[10000].div[1000]>
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
      - define sufix_list:->:<[attribute]>
    - adjust <context.entity> "custom_name:<script[rarity_data_table].data_key[<[rarity]>.color].parsed><[prefix_list].space_separated.to_titlecase> <Context.entity.entity_type.to_titlecase> <[sufix_list].insert[The].at[1].space_separated.to_titlecase.if_null[]>"
    - adjust <context.entity> custom_name_visible:true
    - flag <context.entity> rare_mob:<script[rarity_data_table].data_key[<[rarity]>.slaying]>
    - inject custom_mob_modifier_task

custom_mob_modifier_task:
  type: task
  debug: false
  script:
    - if <[prefix_list].contains_any[fortified]>:
      - adjust <context.entity> max_health:<context.entity.health_max.mul[2]>
      - heal <context.entity>

rarity_data_table:
  type: data
##    Rarity: Color
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

Mob_drop_handler:
  type: world
  debug: false
  events:
    on entity_flagged:rare_mob killed by player:
    - if <context.entity.has_flag[resurrecting]>:
      - stop
    - define drop_type drop
    - if <context.entity.has_flag[explosive]>:
      - define drop_type give
    - if <util.random.int[1].to[10]> > 9:
      - define chance <element[1]>
    - choose <context.entity.flag[rare_mob].add[<[chance]||0>]>:
      - case 1:
        - define rarity common
        - define rarity_color <&f>
#        - define glow_color white
      - case 2:
        - define rarity uncommon
        - define rarity_color <&a>
#        - define glow_color green
      - case 3:
        - define rarity rare
        - define rarity_color <&b>
#        - define glow_color blue
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
#    - adjust <entry[dropped_entity].dropped_entity> glowing:true
#    - team name:item_glow_color add:<entry[dropped_entity].dropped_entity.uuid> color:<[glow_color]>

rarity_info_table:
  type: data
##    Rarity: Color
  uncommon: <&a>
  rare: <&b>
  epic: <&d>
  legendary: <&6>

enchanted_book_mob_give_compiler:
  type: task
  debug: false
  definitions: rarity
  script:
    - define enchantment <server.flag[custom_enchant_data.rarity.<[rarity]>].random>
    - define level <util.random.int[1].to[<server.flag[custom_enchant_data.<[enchantment]>.max]>]>
    - give <proc[enchanted_book_procedural_generator].context[<[enchantment].before[_enchantment]>|<[level]>]>
    - playsound <player.location> sound:entity_item_pickup


#TODO:
#custom_mob_prefix_Alchemical_prefix_task:
#  Type: world
#  debug: false
#  events:


process_mob_data_reload:
  type: world
  debug: false
  events:
    on script reload:
      - run process_mob_attributes_task

process_mob_data_start:
  type: world
  debug: false
  events:
    on server start:
      - run process_mob_attributes_task


process_mob_attributes_task:
  type: task
  debug: false
  data:
    MobSpawnChanceMap:
      uncommon: 10
      rare: 5
      epic: 1
  script:
    - flag server custom_mob_data:!
    - foreach <server.scripts.filter[name.advanced_matches[custom_mob_prefix_*]].parse[name.after[custom_mob_prefix_]]> as:prefix:
      - flag server custom_mob_data.valid_prefixes:->:<[prefix]>
    - narrate targets:<server.online_players.filter[has_permission[admin]]> <&e>Mob<&SP>Prefix<&SP>Data<&6><&SP>Compiled.
    - foreach <server.scripts.filter[name.advanced_matches[custom_mob_suffix_*]].parse[name.after[custom_mob_suffix_]]> as:suffix:
      - flag server custom_mob_data.valid_suffixes:->:<[suffix]>
    - narrate targets:<server.online_players.filter[has_permission[admin]]> <&e>Mob<&SP>Suffix<&SP>Data<&6><&SP>Compiled.
    - define map <script.data_key[data.MobSpawnChanceMap].invert>
    - define new_map <map>
    - define total 0
    - foreach <[map].keys.numerical>:
      - define new_map <[new_map].with[<[value].add[<[total]>].div[100]>].as[<[map].get[<[value]>]>]>
      - define total <[total].add[<[value]>]>
    - flag server custom_mob_data.mob_spawn_rates:<[new_map]>
