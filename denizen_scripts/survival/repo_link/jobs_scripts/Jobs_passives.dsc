jobs_farmer_passive:
  type: world
  debug: false
  events:
    on player breaks WHEAT|BEETROOTS|POTATOES|CARROTS|NETHER_WART with:*_hoe:

      ##Checks the player level is over the minimum, and that they arent just breaking un-grown crops
      - if <context.material.age> != <context.material.maximum_age> || <player.flag[jobs.farmer.level]> < 10:
        - stop
      - if <context.location.add[0,1,0].has_flag[custom_planted]>:
        - define custom_crop <context.location.add[0,1,0].flag[custom_planted]>
      - define farmer_level <player.flag[jobs.farmer.level]>

      ##boosts the chances for the passive, in this case each level adds 0.2% per player level, up to 20% at max level
      - define proc_rate <util.random.int[0].to[100].add[<[farmer_level].div[5]>]>
      - if <[proc_rate]> > 90:
        - wait 1t
        ##resets the crop and plays an effect to let them know they triggered the passive
        - modifyblock <context.location> <context.material.name>[age=1]
        - playeffect effect:VILLAGER_HAPPY at:<context.location.center.above[0.25]> quantity:10 offset:0.25,0.25,0.25
        - playsound sound:ITEM_HOE_TILL <context.location>
        ##prevents accidentally breaking the crop they just placed.
        - flag <context.location> jobs.just_broken duration:1s
        ##flags the crop for the player to earn their cash
        - flag <context.location> jobs.player_placed.crop:<player>
        - if <[custom_crop]||null> != null:
          - flag <context.location.add[0,1,0]> <[custom_crop]>


        ##Checks and removes a bit more hoe durability, or breaks the item
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
      ##Checks the player level is over the minimum
      - if <player.flag[jobs.lumberjack.level]> < 10:
        - stop
      - define lumberjack_level <player.flag[jobs.lumberjack.level]>

      ##boosts the chances for the passive, in this case each level adds 0.25% per player level, up to 25% at max level
      - define proc_rate <util.random.int[0].to[100].add[<[lumberjack_level].div[4]>]>
      - if <[proc_rate]> > 90:
        - playsound sound:BLOCK_WOOD_FALL <context.location>
        - playsound soung:block_wood_break <context.location>
        - determine INSTABREAK

jobs_lumberjack_passive_leaves:
  type: world
  debug: false
  events:
    on player damages *_leaves|*_mushroom_block|*_wart_block:
      ##Checks the player level is over the minimum
      - if <player.flag[jobs.lumberjack.level]> < 10:
        - stop
      - define lumberjack_level <player.flag[jobs.lumberjack.level]>

      ##boosts the chances for the passive, in this case each level adds 0.5% per player level, up to 50% at max level
      - define proc_rate <util.random.int[0].to[100].add[<[lumberjack_level].div[2]>]>
      - if <[proc_rate]> > 90:
        - if <list[nether_wart_block|warped_wart_block].contains_any[<context.location.material.name>]>:
          - define sound BLOCK_WART_BLOCK
        - else:
          - define sound BLOCK_GRASS
        - playsound sound:<[sound]>_FALL <context.location>
        - playsound soung:<[sound]>_break <context.location>
        - determine INSTABREAK

jobs_miner_passive:
  type: world
  debug: false
  events:
    on iron_ore|gold_ore|nether_gold_ore|ancient_debris drops item from breaking:
      ##Checks the player level is over the minimum, and that the player has not recently placed the block.
      - if <context.location.has_flag[jobs.player_placed]> || <player.flag[jobs.miner.level]> < 10:
        - stop
      - define miner_level
      ##boosts the chances for the passive, in this case each level adds 0.2% per player level, up to 20% at max level
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

          ##Runs the jobs reward script if the player could recieve rewards for smelting the item.
          - foreach <player.flag[jobs.current_list]> as:job:
            - if !<script[Jobs_data_script].list_keys[<[job]>.smelt_item].contains_any[<[smelt_type]>]||false>:
              - foreach next
            - else:
              - run jobs_smelted_item_define_rewards def.job:<[job]> def.player:<player> def.item:<[smelt_type]>

          ##Changes the drop to the smelted item type, and plays an effect to let them know they triggered the passive
          - adjust <[drop_entity]> item:<[smelt_type]>
          - playeffect effect:FLAME at:<context.location.center> quantity:25 offset:0.25,0.25,0.25
          - playsound <context.location> ITEM_FIRECHARGE_USE

jobs_chef_passive:
  type: world
  debug: false
  events:
    on player consumes apple|mushroom_stew|chorus_fruit|beetroot|bread|golden_apple|golden_carrot|enchanted_golden_apple|cake|cookie|melon_slice|dried_kelp|cooked_*|*_soup|sweet_berries|honey_bottle|pumpkin_pie|potato|*_potato|pufferfish:
      ##Checks the player's level is below the minimum
      - if <player.flag[jobs.chef.level]> < 10:
        - stop
      ##Sets the boost ratio at 0.5% per players level, up to 50% at level 100
      - define boost_ratio <player.flag[jobs.chef.level].div[2]>
      ##Checks for custom scripted foods
      - if <context.item.has_script>:
        - define amount <script[Jobs_data_script].data_key[chef.food_passive.scripted.<context.item.script_name>.amount]||1>
        - define saturation <script[Jobs_data_script].data_key[chef.food_passive.scripted.<context.item.script_name>.saturation]||1>
      - else:
      ##Assumes that its a vanilla food if the other check fails.
        - define amount <script[Jobs_data_script].data_key[chef.food_passive.vanilla.<context.item.material.name>.amount]||1>
        - define saturation <script[Jobs_data_script].data_key[chef.food_passive.vanilla.<context.item.material.name>.saturation]||1>
      - feed amount:<[amount].mul[<[boost_ratio]>]> saturation:<[saturation].mul[<[boost_ratio]>]>

jobs_brewer_passive:
  type: world
  debug: false
  events:
    on brewing stand brews:
      - wait 5t
      ##If its not a player owned block, or the owner is under the minimum level, it will not fire.
      - if !<context.location.has_flag[jobs.block_owned_by_player]> || <context.location.flag[jobs.block_owned_by_player].flag[jobs.brewer.level]||1> < 10:
        - stop
      - define brewer_level <context.location.flag[jobs.block_owned_by_player].flag[jobs.brewer.level]>
      ##Checks through each slot to check for valid potions
      ##also checks that the item has not been left in from a previous brew
      ##this should help prevent people duping potions this way.
      - foreach <list[1|2|3]> as:slot_number:
        - if <list[air|thick|mundane].contains_any[<context.inventory.slot[<[slot_number]>].potion_base_type||air>]> || <context.inventory.slot[<[slot_number]>].has_flag[jobs.brewer_passive.duplicated]>:
          - inventory flag destination:<context.inventory> slot:<context.inventory.slot[<[slot_number]>]> jobs.brewer_passive.duplicated
          - foreach next
        - inventory flag destination:<context.inventory> slot:<[slot_number]> jobs.brewer_passive.duplicated
        ##boosts the proc rate per item at .1% per brewer level, up to 10% at max level
        ##This seems low, because its PER ITEM, meaning there is a 30% chance at max level that the effect triggers
        - define proc_rate <util.random.int[0].to[100].add[<[brewer_level].div[10]>]>
        - if <[proc_rate]> > 90:
          - inventory adjust destination:<context.inventory> slot:<[slot_number]> quantity:2

jobs_Excavator_passive:
  type: world
  debug: false
  events:
    on player breaks dirt|grass_block|sand|red_sand|soul_sand|soul_soil|gravel with:*_shovel:
      ##Checks the player level is over the minimum, and that the player has not recently placed the block.
      - if <context.location.has_flag[jobs.player_placed]> || <player.flag[jobs.Excavator.level]> < 10:
        - stop
      - define exc_level <player.flag[jobs.Excavator.level]>
      ##boosts the proc rate per item at .2% per Excavator level, up to 20% at max level
      - define proc_rate <util.random.int[0].to[100].add[<[exc_level].div[5]>]>
      - if <[proc_rate]> > 90:
        - define drop_slot <script[Jobs_data_script].list_keys[Excavator.passive_drop].random>
        - define drop <script[Jobs_data_script].data_key[Excavator.passive_drop.<[drop_slot]>].parsed>
        - determine passively <list[<[drop]>|<context.material.name>]>

jobs_Blacksmith_passive:
  type: world
  debug: false
  events:
    on player crafts *_helmet|*_chestplate|*_sword|*_axe|*_boots:
      - if <player.flag[jobs.blacksmith.level]> < 10:
        - stop
      ##boosts the proc rate per item at .1% per blacksmith level, up to 10% at max level
      - define blacksmith_level <player.flag[jobs.blacksmith.level]>
      - define proc_rate <util.random.int[0].to[100].add[<[blacksmith_level].div[10]>]>
      - if <[proc_rate]> > 90:
        - determine <context.item.with[quantity=<context.item.quantity.mul[2]>]>

jobs_Fisher_passive:
  type: world
  debug: true
  events:
    on player fishes:
      ##clears invalid catch states
      - if <context.state> != CAUGHT_ENTITY || <player.flag[jobs.fisher.level]> < 10:
        - stop
      ##sets a cooldown for the passive, and checks if the mob is from a spawner
      - if !<player.has_flag[ripped_recently]> && !<context.entity.from_spawner>:
        - define entity_type <context.entity.entity_type>
        - hurt <context.entity> <player.flag[jobs.fisher.level].mul[0.1].sub[0.1].add[1]>
        - wait 1t
        - flag player ripped_recently duration:30s
        ##Checks to see if the entity is eligible for a drop
        - if <script[Jobs_data_script].list_keys[Fisher.caught_entity].contains_any[<[entity_type]>]>:
          - define fisher_level <player.flag[jobs.fisher.level]>
          ##boosts the proc rate per item at .3% per fisher level, up to 30% at max level
          - define proc_rate <util.random.int[0].to[100].add[<[fisher_level].div[3]>]>
          - if <[proc_rate]> > 90:
            ##Checks the item's tier independently of level, to keep legendaries somewhat rare still.
            - define tier <util.random.int[1].to[100]>
            - if <[tier]> < 80:
              - define item_tier common
              - define tier_color <&f>
            - if <[tier]> >= 80:
              - define item_tier rare
              - define tier_color <&b>
            - if <[tier]> > 99:
              - define item_tier legendary
              - define tier_color <&6>
          ##Drops the item and sends a message to the player that they triggered it.
          - if <[item_tier]||null> != null:
            ##pulls the item from the data key
            - define item_dropped <script[Jobs_data_script].data_key[Fisher.caught_entity.<[entity_type]>.<[item_tier]>].parsed>
            - drop location:<context.entity.location> <[item_dropped]> quantity:<script[Jobs_data_script].data_key[Fisher.caught_entity.<[entity_type]>.<[item_tier]>_quantity].parsed>
            - actionbar "<&a>You have ripped a <[tier_color]><item[<[item_dropped]>].display||<item[<[item_dropped]>].material.name.replace[_].with[ ].to_titlecase>><&a> free from the <[entity_type].replace[_].with[ ].to_titlecase>!"
        - else:
          - narrate "<&c>This entity type does not have any drops, please suggest it to be added on our github. (/github)"

jobs_Hunter_passive:
  type: world
  debug: false
  events:
    on player damaged by entity:
      ##Checks that the player is over the minimum level to triger the effect, and hasnt dodged recently
      - if <player.flag[jobs.hunter.level]> < 10 || <player.has_flag[jobs.dodged_recently]>:
        - stop
      - define hunt_level <player.flag[jobs.hunter.level]>
      ##Boosts the proc rate by 0.1% a level, up to 10% at max level. it may seem low but this is a strong effect.
      - define proc_rate <util.random.int[0].to[100].add[<[hunt_level].div[10]>]>
      - if <[proc_rate]> > 90:
        ##determines 0 damage, and notifies the player it was triggered.
        - determine passively 0
        - playsound <player.location> sound:ITEM_ARMOR_EQUIP_LEATHER pitch:0.5
        - actionbar "<&a>You dodged an attack"
        - flag player jobs.dodged_recently duration:15s

jobs_Enchanter_passive:
  type: world
  debug: false
  events:
    on item enchanted:
      ##checks that the player is over the minimum level for the effect.
      - if <player.flag[jobs.enchanter.level]> < 10:
        - stop
      ##Defines the enchantment map, without this then the definition later on will error out.
      - define enchantment_map <map>
      - define enchanter_level <player.flag[jobs.enchanter.level]>
      - foreach <context.enchants> as:enchant_level key:enchant_applied:
        ##Boosts the proc rate by 0.1% a level, up to 10% at max level, seems low, but its PER enchantment on the item.
        - define proc_rate <util.random.int[0].to[100].add[<[enchanter_level].div[10]>]>
        - if <[proc_rate]> > 90:
          ##retrieves the enchantment level and adds one to it
          - define enchant_level <[enchant_level].add[1]>
          ##defines the enchantment map while adding the current enchantment to it.
          - define enchantment_map <[enchantment_map].with[<[enchant_applied]>].as[<[enchant_level]>]>
          ##plays an visual and audio effect so the player knows it triggered.
          ##this is per effect, so if it triggers 4 times, it will be a particle explosion.
          - playeffect <context.location.add[1,1,1].to_cuboid[<context.location.sub[1,1,1]>].blocks> effect:dragon_breath quantity:5
          - playeffect <context.location.add[1,1,1].to_cuboid[<context.location.sub[1,1,1]>].blocks> effect:redstone quantity:5 special_data:3|250,0,250
          - playsound BLOCK_BELL_RESONATE <context.location>
        - else:
          ##if the proc didnt trigger, then it just adds the natural level of the enchantment
          - define enchantment_map <[enchantment_map].with[<[enchant_applied]>].as[<[enchant_level]>]>
      ##applies the enchantment map
      - determine enchants:<[enchantment_map]>
