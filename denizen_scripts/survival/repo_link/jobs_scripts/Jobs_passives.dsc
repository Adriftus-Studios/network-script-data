jobs_farmer_passive:
  type: world
  debug: false
  events:
    on player breaks WHEAT|BEETROOTS|POTATOES|CARROTS|NETHER_WART with:*_hoe:
      - if <context.material.age> != <context.material.maximum_age> || <player.flag[jobs.farmer.level]> < 10:
        - stop
      - define farmer_level <player.flag[jobs.farmer.level]>
      - define proc_rate <util.random.int[0].to[100].add[<[farmer_level].div[5]>]>
      - if <[proc_rate]> > 90:
        - wait 1t
        - modifyblock <context.location> <context.material.name>[age=1]
        - playeffect effect:VILLAGER_HAPPY at:<context.location.center.above[0.25]> quantity:10 offset:0.25,0.25,0.25
        - playsound sound:ITEM_HOE_TILL <context.location>
        - flag <context.location> jobs.just_broken duration:1s
        - define hoe_item <player.item_in_hand>
        - if <[hoe_item].durability.add[5]> < <[hoe_item].max_durability>:
          - inventory adjust slot:<player.held_item_slot> durability:<[hoe_item].durability.add[5]>
        - if <[hoe_item].durability.add[5]> >= <[hoe_item].max_durability>:
          - take iteminhand
          - playeffect effect:ITEM_CRACK at:<player.eye_location> special_data:<[hoe_item].material> offset:0.25 quantity:15
          - playsound <player> sound:ENTITY_ITEM_BREAK

jobs_lumberjack_passive_wood:
  type: world
  debug: false
  events:
    on player damages *_log|*_stem|*_hyphae|*_wood with:*_axe:
      - define lumberjack_level <player.flag[jobs.lumberjack.level]>
      - define proc_rate <util.random.int[0].to[100].add[<[lumberjack_level].mul[5]>]>
      - if <[proc_rate]> > 90:
        - playsound sound:BLOCK_WOOD_FALL <context.location>
        - playsound soung:block_wood_break <context.location>
        - determine INSTABREAK

jobs_lumberjack_passive_leaves:
  type: world
  debug: false
  events:
    on player damages *_leaves|*_mushroom_block|*_wart_block:
      - define lumberjack_level <player.flag[jobs.lumberjack.level]>
      - define proc_rate <util.random.int[0].to[100].add[<[lumberjack_level].mul[5]>]>
      - if <[proc_rate]> > 90:
        - if <list[nether_wart_block|warped_wart_block].contains_any[<context.location.material.name>]>:
          - define sound BLOCK_WART_BLOCK
        - else:
          - define sound BLOCK_GRASS
        - playsound sound:<[sound]>_FALL <context.location>
        - playsound soung:<[sound]>_break <context.location>
        - determine INSTABREAK

jobs_lumberjack_passive_2:
  type: task
  debug: false
  events:
    on structure grows:
      - announce <context.structure>
      - if !<context.location.has_flag[jobs.player_placed]>:
        - stop
      - define tree_type <context.structure>
      - define stump_override <list[oak_sapling|oak_leaves|spruce_leaves|spruce_sapling|birch_leaves|birch_sapling|jungle_leaves|jungle_sapling|acacia_leaves|acacia_sapling|dark_oak_leaves|dark_oak_sapling|air|grass|tall_grass|fern|dead_bush|dandelion|poppy|blue_orchid|allium|azure_bluet|red_tulip|orange_tulip|white_tulip|pink_tulip|oxeye_daisy|cornflower|lily_of_the_valley|brown_mushroom|red_mushroom|vine|sunflower|lilac|rose_bush|peony|large_fern]>
      - choose <[tree_type]>:
        - case TREE:
          - define tree tree<util.random.int[1].to[7]>
      - announce <[tree]>
      - foreach <script[Jobs_data_script].list_keys[lumberjack.tree_growth_passive.<[tree_type]>.<[tree]>.obstructed_location]||0> as:stump_number:
        - define stump_location <context.location.add[<script[Jobs_data_script].data_key[lumberjack.tree_growth_passive.<[tree_type]>.<[tree]>.obstructed_location.<[stump_number]>.x]||0>,0,<script[Jobs_data_script].data_key[lumberjack.tree_growth_passive.<[tree_type]>.<[tree]>.obstructed_location.<[stump_number]>.z]||0>]>
        - announce stump_location_<[stump_number]>_is_<[stump_location].material.name>
        - if !<[stump_override].contains_any[<[stump_location].material.name>]>:
          - announce air_check_failed_<[stump_number]>
          - stop
        - announce soil_location_is_<[stump_location].below.material.name>
        - if !<list[grass_block|dirt|podzol|coarse_dirt].contains_any[<[stump_location].below.material.name>]>:
          - announce soil_check_failed_<[stump_number]>
          - stop
        - foreach <util.list_numbers_to[<script[Jobs_data_script].data_key[lumberjack.tree_growth_passive.<[tree_type]>.<[tree]>.obstructed_location.<[stump_number]>.y2]||16>].filter_tag[<[filter_value].is[more].than[<script[Jobs_data_script].data_key[lumberjack.tree_growth_passive.<[tree_type]>.<[tree]>.obstructed_location.<[stump_number]>.y1]||0>]>]> as:height_check:
          - if !<[stump_override].contains_any[<[stump_location].add[0,<[height_check]>,0].material.name>]>:
            - announce block_detected_<[height_check]>_above_stump_<[stump_number]>
            - stop
      - determine passively cancelled
      - modifyblock <context.location> air
      - ~schematic load name:<[tree]>
      - ~schematic paste name:<[tree]> <context.location> noair mask:<[stump_override]>
      - ~schematic unload name:<[tree]>

jobs_miner_passive:
  type: world
  debug: false
  events:
    on iron_ore|gold_ore|nether_gold_ore|ancient_debris drops item from breaking:
      - if <context.location.has_flag[jobs.player_placed]> || <player.flag[jobs.miner.level]> < 10:
        - stop
      - define miner_level
      - define proc_rate <util.random.int[0].to[100].add[<[miner_level].div[5]>]>
      - foreach <context.drop_entities> as:drop_entity:
        - if <[proc_rate]> > 90:
          - choose <[drop_entity].item.material.name>:
            - case iron_ore:
              - define smelt_type iron_ingot
            - case gold_ore:
              - define smelt_type gold_ingot
            - case ancient_debris:
              - define smelt_type netherite_scrap
          - adjust <[drop_entity]> item:<[smelt_type]>
          - playeffect effect:FLAME at:<context.location.center> quantity:25 offset:0.25,0.25,0.25
          - playsound <context.location> ITEM_FIRECHARGE_USE

jobs_chef_passive:
  type: world
  debug: false
  events:
    on player consumes apple|mushroom_stew|chorus_fruit|beetroot|bread|golden_apple|golden_carrot|enchanted_golden_apple|cake|cookie|melon_slice|dried_kelp|cooked_*|*_soup|sweet_berries|honey_bottle|pumpkin_pie|potato|*_potato|pufferfish:
      - if <player.flag[jobs.chef.level]> < 10:
        - stop
      - define boost_ratio <player.flag[jobs.chef.level].div[100]>
      - if <context.item.has_script>:
        - define amount <script[Jobs_data_script].data_key[chef.food_passive.scripted.<context.item.script_name>.amount]||1>
        - define saturation <script[Jobs_data_script].data_key[chef.food_passive.scripted.<context.item.script_name>.saturation]||1>
      - else:
        - define amount <script[Jobs_data_script].data_key[chef.food_passive.vanilla.<context.item.material.name>.amount]||1>
        - define saturation <script[Jobs_data_script].data_key[chef.food_passive.vanilla.<context.item.material.name>.saturation]||1>
      - feed amount:<[amount].mul[<[boost_ratio]>]> saturation:<[saturation].mul[<[boost_ratio]>]>

jobs_brewer_passive:
  type: world
  debug: false
  events:
    on brewing stand brews:
      - wait 5t
      - if !<context.location.has_flag[jobs.block_owned_by_player]> || <context.location.flag[jobs.block_owned_by_player].flag[jobs.brewer.level]||1> < 10:
        - stop
      - define brewer_level <context.location.flag[jobs.block_owned_by_player].flag[jobs.brewer.level]>
      - foreach <list[1|2|3]> as:slot_number:
        - if <list[air|thick|mundane].contains_any[<context.inventory.slot[<[slot_number]>].potion_base_type||air>]> || <context.inventory.slot[<[slot_number]>].has_flag[jobs.brewer_passive.duplicated]>:
          - inventory flag destination:<context.inventory> slot:<context.inventory.slot[<[slot_number]>]> jobs.brewer_passive.duplicated
          - foreach next
        - inventory flag destination:<context.inventory> slot:<[slot_number]> jobs.brewer_passive.duplicated
        - define proc_rate <util.random.int[0].to[100].add[<[brewer_level].div[10]>]>
        - if <[proc_rate]> > 90:
          - inventory adjust destination:<context.inventory> slot:<[slot_number]> quantity:2

jobs_Archaeologist_passive:
  type: world
  debug: false
  events:
    on player breaks dirt|grass_block|sand|red_sand|soul_sand|soul_soil|gravel with:*_shovel:
      - if <context.location.has_flag[jobs.player_placed]> || <player.flag[jobs.archaeologist.level]> < 10:
        - stop
      - define arch_level <player.flag[jobs.archaeologist].level>
      - define proc_rate <util.random.int[0].to[1000].add[<[arch_level].mul[2]>]>
      - narrate <[proc_rate]>
      - if <[proc_rate]> > 900 && <[proc_rate]> < 996:
        - determine passively <list[glowstone_dust|<context.material.name>]>
      - if <[proc_rate]> > 996 && <[proc_rate]> < 998:
        - determine passively <list[diamond|<context.material.name>]>
      - if <[proc_rate]> > 998:
        - determine passively <list[emerald|<context.material.name>]>

jobs_Blacksmith_passive:
  type: world
  debug: false
  events:
    on player crafts *_helmet|*_chestplate|*_sword|*_axe|*_boots:
      - if <player.flag[jobs.blacksmith.level]> < 10:
        - stop
      - define blacksmith_level <player.flag[jobs.blacksmith.level]>
      - define proc_rate <util.random.int[0].to[100].add[<[blacksmith_level].div[10]>]>
      - if <[proc_rate]> > 90:
        - determine <context.item.with[quantity=<context.item.quantity.mul[2]>]>

jobs_Fisher_passive:
  type: world
  debug: false
  events:
    on player fishes:
      - if <context.state> != CAUGHT_ENTITY || <player.flag[jobs.fisher.level]> < 10:
        - stop
      - if !<player.has_flag[ripped_recently]> && !<context.entity.from_spawner>:
        - hurt <context.entity> <player.flag[jobs.fisher].mul[0.1].sub[0.1].add[1]>
        - wait 1t
        - flag player ripped_recently duration:30s
        - if <script[Jobs_data_script].list_keys[Fisher.caught_entity].contains_any[<context.entity.entity_type>]>:
          - define fisher_level <player.flag[jobs.fisher.level]>
          - define proc_rate <util.random.int[0].to[1000].add[<[fisher_level].mul[5]>]>
          - if <[proc_rate]> > 900:
            - define item_tier common
            - define tier_color <&f>
          - if <[proc_rate]> > 996:
            - define item_tier rare
            - define tier_color <&b>
          - if <[proc_rate]> > 998:
            - define item_tier legendary
            - define tier_color <&6>
          - if <[item_tier]||null> != null:
            - define item_dropped <script[Jobs_data_script].data_key[Fisher.caught_entity.<context.entity.entity_type>.<[item_tier]>].parsed>
            - drop location:<context.entity.location> <[item_dropped]> quantity:<script[Jobs_data_script].data_key[Fisher.caught_entity.<context.entity.entity_type>.<[item_tier]>_quantity]>
            - actionbar "<&a>You have ripped a <[tier_color]><item[<[item_dropped]>].display||<item[<[item_dropped]>].material.name>><&a> free from the <context.entity.name.replace[_].with[ ].to_titlecase>!"

jobs_Hunter_passive:
  type: world
  debug: false
  events:
    on player damaged by entity:
      - if <player.flag[jobs.hunter.level]> < 10 || <player.has_flag[jobs.dodged_recently]>:
        - stop
      - flag player jobs.dodged_recently duration:15s
      - define hunt_level <player.flag[jobs.hunter.level]>
      - define proc_rate <util.random.int[0].to[100].add[<[hunt_level].div[10]>]>
      - if <[proc_rate]> > 90:
        - determine passively 0
        - playsound <player.location> sound:ITEM_ARMOR_EQUIP_LEATHER pitch:0.5
        - actionbar "<&a>You dodged an attack"

jobs_Enchanter_passive:
  type: world
  debug: false
  events:
    on item enchanted:
      - if <player.flag[jobs.enchanter.level]> < 10:
        - stop
      - define enchantment_map <map>
      - define enchanter_level <player.flag[jobs.enchanter.level]>
      - foreach <context.enchants> as:enchant_level key:enchant_applied:
        - narrate applied_<[enchant_applied]>_LV:<[enchant_level]>
        - define proc_rate <util.random.int[0].to[100].add[<[enchanter_level].div[10]>]>
        - if <[proc_rate]> > 90:
          - narrate level_<[enchant_level]>
          - define enchant_level <[enchant_level].add[1]>
          - narrate new_level<[enchant_level]>
          - define enchantment_map <[enchantment_map].with[<[enchant_applied]>].as[<[enchant_level]>]>
          - playeffect <context.location.add[1,1,1].to_cuboid[<context.location.sub[1,1,1]>].blocks> effect:dragon_breath quantity:5
          - playeffect <context.location.add[1,1,1].to_cuboid[<context.location.sub[1,1,1]>].blocks> effect:redstone quantity:5 special_data:3|250,0,250
          - playsound BLOCK_BELL_RESONATE <context.location>
          - narrate <[enchantment_map]>
        - else:
          - define enchantment_map <[enchantment_map].with[<[enchant_applied]>].as[<[enchant_level]>]>
      - determine enchants:<[enchantment_map]>
