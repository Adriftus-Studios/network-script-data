jobs_gui_handler:
  type: world
  debug: false
  events:
    on player clicks item in *_info_gui:
    - if <context.item.has_flag[action]>:
      - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
      - choose <context.item.flag[action]>:
        - case back:
          - inventory open d:jobs_info_gui
        - case close:
          - inventory close
        - case player_jobs_info:
          - inventory open d:personal_jobs_info_gui
        - case server_jobs_info:
          - inventory open d:jobs_info_gui
        - case accept:
          - if !<player.flag[jobs.current_list].contains_any[<context.inventory.note_name.before[_]>]>:
            - flag player jobs.current_list:->:<context.inventory.note_name.before[_].to_titlecase>
            - flag player jobs.active:<player.flag[jobs.current_list].size>
            - flag server jobs.count.<context.inventory.note_name.before[_]>:++
            - flag server jobs.count.total:++
            - inject server_jobs_rarity_balancer
            - inventory open d:jobs_info_gui
          - else:
            - inventory close
        - case quit:
          - if <player.has_flag[jobs.quit_cooldown]>:
            - narrate "<&c>You have recently quit a job. please wait <&e><player.flag_expiration[jobs.quit_cooldown].from_now.formatted> before leaving another job."
            - stop
          - if <player.flag[jobs.current_list].contains_any[<context.inventory.note_name.before[_]>]>:
            - flag player jobs.active:<player.flag[jobs.current_list].size||0>
            - flag player jobs.current_list:<-:<context.inventory.note_name.before[_]>
            - flag server jobs.count.<context.inventory.note_name.before[_]>:--
            - flag server jobs.count.total:--
            - inject server_jobs_rarity_balancer
            - wait 1t
            - inventory open d:jobs_info_gui
            - flag <player> jobs.quit_cooldown duration:24h
          - else:
            - inventory close
    - else if <context.item.has_flag[jobs]>:
      - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
      - define inventory <inventory[<context.item.flag[jobs]>_info_gui]>
      - note <[inventory]> as:<context.item.flag[jobs]>_<player.uuid>
      - if <player.flag[jobs.current_list].contains_any[<context.item.flag[jobs]>]>:
        - inventory set destination:<context.item.flag[jobs]>_<player.uuid> o:jobs_quit_button slot:10
      - else if <player.flag[jobs.current_list].size||0> < <player.flag[jobs.allowed]>:
        - inventory set destination:<context.item.flag[jobs]>_<player.uuid> o:jobs_accept_button slot:10
      - else if <player.flag[jobs.current_list].size||0> >= <player.flag[jobs.allowed]>:
        - inventory set destination:<context.item.flag[jobs]>_<player.uuid> o:jobs_full_button slot:10
      - inventory open d:<context.item.flag[jobs]>_<player.uuid>

jobs_structure_grow_handler:
  type: world
  debug: false
  events:
    # #Saplings
    on structure grows:
      - if !<context.location.has_flag[jobs.player_placed]>:
        - stop
      - else:
        - foreach <context.location.flag[jobs.player_placed.crop].flag[jobs.current_list]> as:job:
          - if !<script[Jobs_data_script].list_keys[<[job]>.block_growth].contains_any[<context.location.material.name>]||false>:
            - foreach next
          - else if <list[oak_sapling|dark_oak_sapling|jungle_sapling|acacia_sapling|birch_sapling|spruce_sapling|crimson_fungus|warped_fungus|brown_mushroom|red_mushroom].contains_any[<context.location.material.name>]>:
            - define pre_material <context.location.material.name>
            - wait 5t
            - if <context.location.material.name> == <[pre_material]>:
              - stop
            - run jobs_structure_growth_define_rewards def.job:<[job]> def.pre_material:<[pre_material]> def.location:<context.location>

jobs_structure_growth_define_rewards:
  type: task
  debug: false
  definitions: job|pre_material|location
  script:
    - define money <script[Jobs_data_script].data_key[<[job]>.block_growth.<[pre_material]>.money]>
    - define experience <script[Jobs_data_script].data_key[<[job]>.block_growth.<[pre_material]>.experience]>
    - define player <[location].flag[jobs.player_placed.crop]>
    - flag <[location]> jobs.player_placed:!
    - inject jobs_reward_delay

jobs_crop_grow_handler:
  type: world
  debug: false
  events:
    # #farm crops
    on block grows:
      - if !<context.location.has_flag[jobs.player_placed.crop]> || <context.material.age> != <context.material.maximum_age>:
        - flag <context.location> jobs.player_placed:!
        - stop
      - else:
        - foreach <context.location.flag[jobs.player_placed.crop].flag[jobs.current_list]> as:job:
          - if !<script[Jobs_data_script].list_keys[<[job]>.block_growth].contains_any[<context.material.name>]||false>:
            - foreach next
          - else if <list[wheat|beetroots|potato|carrot|nether_wart].contains_any[<context.material.name>]>:
            - run jobs_crop_growth_define_rewards def.job:<[job]> def.material:<context.location.material.name> def.player:<player> def.location:<context.location>

jobs_crop_growth_define_rewards:
  type: task
  debug: false
  definitions: job|player|material|location
  script:
    - define money <script[Jobs_data_script].data_key[<[job]>.block_growth.<[material]>.money]>
    - define experience <script[Jobs_data_script].data_key[<[job]>.block_growth.<[material]>.experience]>
    - define player <[location].flag[jobs.player_placed.crop]>
    - flag <[location]> jobs.player_placed:!
    - inject jobs_reward_delay

jobs_fishing_handler:
  type: world
  debug: false
  events:
    on player fishes:
    - if !<player.flag[jobs.current_list].contains_any[Fisher]>:
      - stop
    - else if !<list[CAUGHT_FISH|CAUGHT_ENTITY].contains_any[<context.state>]>:
      - stop
    - else if <context.state> == CAUGHT_FISH:
      - if <script[Jobs_data_script].list_keys[Fisher.caught_item].contains_any[<context.item.material.name>]>:
        - run jobs_fishing_define_rewards def.player:<player> def.job:Fisher def.item:<context.item.material.name>
      - else:
        - actionbar "<&a>Ah man, this item is junk!"
        - stop

jobs_fishing_define_rewards:
  type: task
  debug: false
  definitions: player|fisher|item|job
  script:
    - define money <script[Jobs_data_script].data_key[Fisher.caught_item.<[item]>.money]>
    - define experience <script[Jobs_data_script].data_key[Fisher.caught_item.<[item]>.experience]>
    - inject jobs_reward_delay

jobs_enchanting_handler:
  type: world
  debug: false
  events:
    on item enchanted:
    - if !<player.flag[jobs.current_list].contains_any[Enchanter]>:
      - stop
    - else:
      - run jobs_enchanting_define_rewards def.cost:<context.cost> def.enchants:<context.enchants> def.player:<player> def.job:Enchanter

jobs_enchanting_define_rewards:
  type: task
  debug: false
  definitions: job|player|enchants|cost
  script:
  - define money <[cost].div[3].round_down>
  - define experience <[cost].div[3].round_down>
  - foreach <[enchants]> as:enchant_level key:enchant_applied:
    - define money <script[Jobs_data_script].data_key[Enchanter.enchant_item.<[enchant_applied]>.money_per_level].mul[<[enchant_level]>].add[<[money]>]||1>
    - define experience <script[Jobs_data_script].data_key[Enchanter.enchant_item.<[enchant_applied]>.experience_per_level].mul[<[enchant_level]>].add[<[experience]>]||1>
  - inject jobs_reward_delay

jobs_break_block_handler:
  type: world
  debug: false
  events:
    # #Block Breaking
    on player breaks block:
    - if <context.location.has_flag[jobs.block_owned_by_player]>:
      - flag <context.location.flag[jobs.block_owned_by_player]> jobs.blocks_owned:<-:<context.material.name>~<context.location.xyz>~<context.location.world.name>
    - if <context.location.has_flag[jobs.just_broken]>:
      - determine cancelled
    - if !<player.flag[jobs.current_list].contains_any[Lumberjack|Miner|Farmer|Excavator]>:
      - flag <context.location> jobs.player_placed:!
      - if <context.location.has_flag[jobs.block_owned_by_player]>:
        - flag <context.location.flag[jobs.block_owned_by_player]> jobs.blocks_owned:<-:<context.material.name>~<context.location.xyz>~<context.location.world.name>
        - flag <context.location> jobs.block_owned_by_player:!
        - stop
      - stop
    - else:
      - define location_above_1 <context.location.add[0,1,0].material.name>
      - define location_above_2 <context.location.add[0,2,0].material.name>
      - define money 0
      - define experience 0
      - foreach <player.flag[jobs.current_list]> as:job:
        - if !<script[Jobs_data_script].list_keys[<[job]>.block_break].contains_any[<context.material.name>]||false>:
          - foreach next
        - else:
          - if <[job]> == farmer && <list[wheat|beetroots|potatoes|carrots|nether_wart].contains_any[<context.material.name>]>:
            - if <context.material.age> != <context.material.maximum_age>:
                - actionbar "<&c>This crop was not fully grown."
                - flag <context.location> jobs.player_placed:!
                - stop
            - if <context.location.material.name> == sugar_cane:
              - if <[location_above_1]> == sugar_cane:
                - define money <[money].add[<script[Jobs_data_script].data_key[farmer.block_break.sugar_cane.money]>]>
                - define experience <[experience].add[<script[Jobs_data_script].data_key[farmer.block_break.sugar_cane.experience]>]>
                - flag <[location_above_1]> jobs.player_placed:!
              - if <[location_above_2]> == sugar_cane:
                - define money <[money].add[<script[Jobs_data_script].data_key[farmer.block_break.sugar_cane.money]>]>
                - define experience <[experience].add[<script[Jobs_data_script].data_key[farmer.block_break.sugar_cane.experience]>]>
                - flag <[location_above_1]> jobs.player_placed:!
          - if <context.location.has_flag[jobs.player_placed.block]>:
            - actionbar "<&c>This block was placed by a player too recently to be harvested for work."
            - flag <context.location> jobs.player_placed:!
            - if <context.location.has_flag[jobs.block_owned_by_player]>:
              - flag <context.location.flag[jobs.block_owned_by_player]> jobs.blocks_owned:<-:<context.material.name>~<context.location.xyz>~<context.location.world.name>
            - stop
          - run jobs_block_break_define_rewards def.job:<[job]> def.material:<context.material.name> def.player:<player> def.money:<[money]> def.location:<context.location>

jobs_block_break_define_rewards:
  type: task
  debug: false
  definitions: job|material|player|money|location
  script:
    - define money <[money].add[<script[Jobs_data_script].data_key[<[job]>.block_break.<[material]>.money]>]>
    - define experience <script[Jobs_data_script].data_key[<[job]>.block_break.<[material]>.experience]>
    - flag <[location]> jobs.player_placed:!
    - inject jobs_reward_delay


jobs_breed_flag_handler:
  type: world
  debug: false
  events:
    # #breeding flagging
    on player right clicks horse|donkey|cow|mushroom_cow|sheep|pig|chicken|rabbit|llama|cat|wolf|ocelot|turtle|panda|fox|bee|strider|hoglin:
      - ratelimit <player> 2t
      - if <context.entity.breeding> || !<context.entity.can_breed>:
        - stop
      - else:
        - foreach <player.flag[jobs.current_list]> as:job:
          - if !<script[Jobs_data_script].list_keys[<[job]>.breed_entity].contains_any[<context.entity.entity_type>]||false>:
            - foreach next
          - else:
            - flag <context.entity> jobs.breeding:<player> duration:30s

jobs_breed_event_handler:
  type: world
  debug: true
  events:
    # #animal breeding
    on entity breeds:
      - if !<context.mother.has_flag[jobs.breeding]> || !<context.father.has_flag[jobs.breeding]>:
        - stop
      - else if <context.mother.flag[jobs.breeding]> != <context.father.flag[jobs.breeding]>:
        - foreach <context.father.flag[jobs.breeding].flag[jobs.current_list]> as:job:
          - if !<script[Jobs_data_script].list_keys[<[job]>.breed_entity].contains_any[<context.child.entity_type>]||false>:
            - foreach next
          - run animal_breed_define_rewards def.player:<context.father.flag[jobs.breeding]> def.entity_type:<context.child.entity_type> def.job:<[job]>
        - foreach <context.mother.flag[jobs.breeding].flag[jobs.current_list]> as:job:
          - if !<script[Jobs_data_script].list_keys[<[job]>.breed_entity].contains_any[<context.child.entity_type>]||false>:
            - foreach next
          - run run animal_breed_define_rewards def.player:<context.mother.flag[jobs.breeding]> def.entity_type:<context.child.entity_type> def.job:<[job]>
      - else if <context.mother.flag[jobs.breeding]> == <context.father.flag[jobs.breeding]>:
        - foreach <context.mother.flag[jobs.breeding].flag[jobs.current_list]> as:job:
          - if !<script[Jobs_data_script].list_keys[<[job]>.breed_entity].contains_any[<context.child.entity_type>]||false>:
            - foreach next
          - run animal_breed_define_rewards_same_parents def.player:<context.mother.flag[jobs.breeding]> def.entity_type:<context.child.entity_type> def.job:<[job]>

jobs_turtle_breeding_handler:
  type: world
  debug: false
  events:
    on turtle changes block:
    - if !<context.entity.has_flag[jobs.breeding]>:
      - stop
    - flag <context.location> jobs.breeding:<context.entity.flag[jobs.breeding]>

jobs_turtle_spawn_handler:
  type: world
  debug: false
  events:
    on turtle spawns:
      - if !<context.location.has_flag[jobs.breeding]>:
        - stop
      - run animal_breed_define_rewards def.player:<context.location.flag[jobs.breeding]> def.entity_type:turtle def.job:fisher
      - wait 5t
      - if <context.location.material.name> == air:
        - flag <context.location> jobs.breeding:!
      - else:
        - stop


animal_breed_define_rewards:
  type: task
  debug: true
  definitions: player|entity_type|job
  script:
    - define money <script[Jobs_data_script].data_key[<[job]>.breed_entity.<[entity_type]>.money]>
    - define experience <script[Jobs_data_script].data_key[<[job]>.breed_entity.<[entity_type]>.experience]>
    - inject jobs_reward_delay

animal_breed_define_rewards_same_parents:
  type: task
  debug: true
  definitions: player|entity_type|job
  script:
    - define money <script[Jobs_data_script].data_key[<[job]>.breed_entity.<[entity_type]>.money].mul[2]>
    - define experience <script[Jobs_data_script].data_key[<[job]>.breed_entity.<[entity_type]>.experience].mul[2]>
    - inject jobs_reward_delay

jobs_regular_kill_event_handler:
  type: world
  debug: false
  events:
    # #killing regular non-mythicmobs
    on player kills entity:
      - else if <context.entity.is_mythicmob>:
        - stop
      - else if <context.entity.from_spawner>:
        - actionbar "<&a>Entities from a mob spawner are not eligible for pay."
        - stop
      - else:
        - foreach <player.flag[jobs.current_list]> as:job:
          - if !<script[Jobs_data_script].list_keys[<[job]>.kill_entity].contains_any[<context.entity.entity_type>]||false>:
            - foreach next
          - else:
            - run jobs_basic_entity_kill_define_rewards def.job:<[job]> def.player:<player> def.entity_type:<context.entity.entity_type>

jobs_basic_entity_kill_define_rewards:
  type: task
  debug: false
  definitions: job|player|entity_type
  script:
    - define money <script[Jobs_data_script].data_key[<[job]>.kill_entity.<[entity_type]>.money]>
    - define experience <script[Jobs_data_script].data_key[<[job]>.kill_entity.<[entity_type]>.experience]>
    - inject jobs_reward_delay

jobs_mythic_kill_event_handler:
  type: world
  debug: false
  events:
    # #killing mythicmobs
    on mythicmob mob killed:
      - if !<context.entity.is_mythicmob>:
        - stop
      - else if <context.entity.from_spawner>:
        - actionbar "<&a>Entities from a mob spawner are not eligible for pay."
        - stop
      - if <context.level> < 1:
        - stop
      - foreach <player.flag[jobs.current_list]> as:job:
        - if !<script[Jobs_data_script].list_keys[<[job]>.kill_entity].contains_any[<context.entity.entity_type>]||false>:
          - foreach next
        - else:
          - run jobs_mythicmob_kill_define_rewards def.job:<[job]> def.player:<player> def.entity_type:<context.entity.entity_type> def.level:<context.level>

jobs_mythicmob_kill_define_rewards:
  type: task
  debug: false
  definitions: job|player|entity_type|level
  script:
    - define money <script[Jobs_data_script].data_key[<[job]>.kill_entity.<[entity_type]>.money].add[<[level].mul[2]>]>
    - define experience <script[Jobs_data_script].data_key[<[job]>.kill_entity.<[entity_type]>.experience].add[<[level].mul[2.5]>]>
    - inject jobs_reward_delay

jobs_block_place_flag_handler:
  type: world
  debug: false
  events:
    # #Player block rewards. Mainly used to prevent players from placing and breaking a block in a loop to game the system.
    on player places block:
      - flag <context.location> jobs.player_placed.block:<player> duration:24h
      # #This is to flag crops for farming so that they generate funds when grown.
      - if <list[wheat|beetroots|potatoes|carrots|nether_wart|birch_sapling|oak_sapling|dark_oak_sapling|jungle_sapling|acacia_sapling|spruce_sapling|brown_mushroom|red_mushroom|crimson_fungus|warped_fungus].contains_any[<context.material.name>]>:
        - flag <context.location> jobs.player_placed.crop:<player>
        - flag <context.location> jobs.player_placed.block:!
      - if <list[furnace|smoker|blast_furnace|brewing_stand].contains_any[<context.material.name>]>:
        - if <player.flag[jobs.blocks_owned].size||0> < <player.flag[jobs.blocks_allowed]||0>:
          - flag <context.location> jobs.block_owned_by_player:<player>
          - flag <player> jobs.blocks_owned:->:<context.material.name>~<context.location.xyz>~<context.location.world.name>
          - actionbar "<&a>You have claimed this workstation."
          - narrate "<&a>You have claimed this workstation. You have <&e><player.flag[jobs.blocks_allowed]> <&a>more work stations available."
        - else:
          - actionbar "<&c>You have reached your maximum workstation count"
          - narrate "<&c>You have reached your maximum workstation count, (<&e><player.flag[jobs.blocks_allowed]><&c>) and will not recieve any rewards from this block's actions. "

jobs_piston_push_handler:
  type: world
  debug: false
  events:
    # #Piston block flagging. Prevents players from using a piston to push blocks over to get money from placed blocks
    on piston extends:
      - flag <context.location.block_facing.mul[<context.length.add[1]>].add[<context.location>]> jobs.player_placed.block:piston duration:24h
      - foreach <context.blocks> as:block_pushed:
        - flag <[block_pushed]> jobs.player_placed.block:piston_push duration:24h

jobs_block_formation_handler:
  type: world
  debug: false
  events:
    on block forms:
      - flag <context.location> jobs.player_placed.block:block_transformed

jobs_piston_pull_handler:
  type: world
  debug: false
  events:
    # #Piston block flagging. Prevents players from using a piston to push blocks over to get money from placed blocks
    on piston retracts:
    - if <context.sticky>:
      - flag <context.retract_location> jobs.player_placed.block:piston_pull duration:24h

jobs_falling_block_handler:
  type: world
  debug: false
  events:
    # #falling block flagging. Prevents players from dropping sand to earn money
    on block falls:
    - wait 1t
    - if <context.location.material.name> != air:
      - flag <context.location> jobs.player_placed.block:falling_sand duration:24h
    - if <context.location.material.name> == air:
      - flag <context.location> jobs:!

jobs_craft_event_handler:
  type: world
  debug: false
  events:
    # #Player crafting stuff, for tons of professions.
    on player crafts item:
      - if !<context.item.has_script>:
        - foreach <player.flag[jobs.current_list]> as:job:
          - if !<script[Jobs_data_script].list_keys[<[job]>.craft_item].contains_any[<context.item.material.name>]||false>:
            - foreach next
          - else:
            - run jobs_crafted_item_define_rewards def.player:<player> def.item:<context.item.material.name> def.job:<[job]>

jobs_crafted_item_define_rewards:
  type: task
  debug: false
  definitions: player|job|item
  script:
    - define money <script[Jobs_data_script].data_key[<[job]>.craft_item.<[item]>.money]>
    - define experience <script[Jobs_data_script].data_key[<[job]>.craft_item.<[item]>.experience]>
    - inject jobs_reward_delay

jobs_furnace_event_handler:
  type: world
  debug: false
  events:
    on furnace smelts item:
      - if !<context.location.has_flag[jobs.block_owned_by_player]>:
        - stop
      - else:
        - foreach <context.location.flag[jobs.block_owned_by_player].flag[jobs.current_list]> as:job:
          - if !<script[Jobs_data_script].list_keys[<[job]>.smelt_item].contains_any[<context.result_item.material.name>]||false>:
            - foreach next
          - else:
            - run jobs_smelted_item_define_rewards def.job:<[job]> def.player:<context.location.flag[jobs.block_owned_by_player]> def.item:<context.result_item.material.name>

jobs_smelted_item_define_rewards:
  type: task
  debug: false
  definitions: job|player|item
  script:
  - define money <script[Jobs_data_script].data_key[<[job]>.smelt_item.<[item]>.money]>
  - define experience <script[Jobs_data_script].data_key[<[job]>.smelt_item.<[item]>.experience]>
  - inject jobs_reward_delay

jobs_brew_event_handler:
  type: world
  debug: false
  events:
    on brewing stand brews bukkit_priority:HIGHEST priority:-1:
      - define pre_event_inventory_contents <context.inventory.list_contents>
      - if !<context.location.has_flag[jobs.block_owned_by_player]>:
        - stop
      - else:
        - if !<context.location.flag[jobs.block_owned_by_player].flag[jobs.current_list].contains_any[brewer]>:
          - stop
        - wait 1t
        - define post_event_inventory <context.inventory>
        - define item_consumed <[pre_event_inventory_contents].get[4].material.name>
        - if <script[Jobs_data_script].list_keys[brewer.brew_item].contains_any[<[item_consumed]>]>:
          - define reward_counter 0
          - foreach <list[1|2|3]> as:slot_number:
            - if <[pre_event_inventory_contents].get[<[slot_number]>]> != <[post_event_inventory].slot[<[slot_number]>]> && <[post_event_inventory].slot[<[slot_number]>].material.name> != air && !<list[mundane|thick].contains_any[<[post_event_inventory].slot[<[slot_number]>].potion_base_type>]>:
              - define reward_counter <[reward_counter].add[1]>
          - if <[reward_counter]> > 0:
            - foreach <context.location.flag[jobs.block_owned_by_player].flag[jobs.current_list]> as:job:
              - if !<script[Jobs_data_script].list_keys[<[job]>.brew_item].contains_any[<[item_consumed]>]||false>:
                - foreach next
              - else:
                - run jobs_brewed_item_define_rewards def.job:<[job]> def.player:<context.location.flag[jobs.block_owned_by_player]> def.item_consumed:<[item_consumed]> def.reward_counter:<[reward_counter]>

jobs_brewed_item_define_rewards:
  type: task
  debug: false
  definitions: player|job|item_consumed|reward_counter
  script:
  - define money <script[Jobs_data_script].data_key[<[job]>.brew_item.<[item_consumed]>.money].mul[<[reward_counter]>]>
  - define experience <script[Jobs_data_script].data_key[<[job]>.brew_item.<[item_consumed]>.experience].mul[<[reward_counter]>]>
  - inject jobs_reward_delay

jobs_reward_delay:
  type: task
  debug: false
  script:
    - define job_to_flag <[job]>
    - if <[player].has_flag[jobs.reward_cd.<[job_to_flag]>]>:
      - flag <[player]> jobs.reward_cd.<[job_to_flag]>.experience:+:<[experience]>
      - flag <[player]> jobs.reward_cd.<[job_to_flag]>.money:+:<[money]>
      - flag <[player]> jobs.reward_cd.<[job_to_flag]>.cd duration:2s
      - stop
    - flag <[player]> jobs.reward_cd.<[job_to_flag]>.experience:+:<[experience]>
    - flag <[player]> jobs.reward_cd.<[job_to_flag]>.money:+:<[money]>
    - flag <[player]> jobs.reward_cd.<[job_to_flag]>.cd duration:2s
    - waituntil rate:2s !<[player].has_flag[jobs.reward_cd.<[job_to_flag]>.cd]>
    - define money_to_give <[player].flag[jobs.reward_cd.<[job_to_flag]>.money]>
    - define experience_to_give <[player].flag[jobs.reward_cd.<[job_to_flag]>.experience]>
    - flag <[player]> jobs.reward_cd.<[job_to_flag]>:!
    - inject jobs_calculate_rewards

jobs_calculate_rewards:
  type: task
  debug: false
  script:
    - define server_boost <server.flag[jobs.server_rewards_boost.<[job]>]>
    - define player_money_boost <[player].flag[jobs.<[job]>.level].mul[0.1].sub[0.1].add[1]>
    - define player_experience_boost <[player].flag[jobs.<[job]>.level].mul[0.1].sub[0.1].add[1]>
    - define total_money <[money_to_give].mul[<[server_boost]>].mul[<[player_money_boost]>]>
    - define total_experience <[experience_to_give].mul[<[server_boost]>].mul[<[player_experience_boost]>]>
    - if <[player].is_online>:
      - give player:<[player]> money quantity:<[total_money]>
      - actionbar "<&6>Your recent <&lb><&e><[job]><&6><&rb> activity earned you <&lb><&a>$<[total_money].round_to[2]><&6>/<&b><[total_experience].round_to[2]>XP<&6><&rb>" targets:<[player]>
      - inject jobs_exp_adding
    - else:
      - flag <[player]> jobs.money_due:+:<[total_money]>
      - inject jobs_exp_adding

server_jobs_rarity_balancer:
  type: task
  debug: false
  script:
  - define jobs_list <script[Jobs_data_script].list_keys[jobs_list]>
  - define total_jobs <server.flag[jobs.count.total]>
  - foreach <[jobs_list]> as:jobs:
    - define current_jobs_count <server.flag[jobs.count.<[jobs]>]||0>
    - define ratio <[current_jobs_count].div[<[total_jobs].add[2]>].round_to[2]>
    - flag server jobs.rarity.balancer.<[jobs]>:<element[1.25].sub[<[ratio]>]>
  - inject server_jobs_reward_multiplier

server_jobs_reward_multiplier:
  type: task
  debug: false
  script:
# # Sets the server jobs boost value as a function of the rarity of a job, and the overall boosts of the server.
  - define jobs_list <script[Jobs_data_script].list_keys[jobs_list]>
  - define jobs_weekend_booster <server.flag[jobs.weekend_boost]||1>
  - define jobs_special_booster <server.flag[jobs.special_boost]||1>
  - foreach <[jobs_list]> as:jobs:
    - flag server jobs.server_rewards_boost.<[jobs]>:<[jobs_weekend_booster].mul[<server.flag[jobs.rarity.balancer.<[jobs]>]>].mul[<[jobs_special_booster]>].mul[<script[Jobs_data_script].data_key[<[jobs]>.difficulty_level]>]>

jobs_work_station_finder_command:
  type: command
  debug: false
  usage: /workstations
  description: Narrates a players work station location
  name: workstations
  script:
  - inject jobs_work_station_finder

jobs_work_station_finder:
  type: task
  debug: false
  script:
  - if !<player.flag[jobs.blocks_owned].is_empty>:
    - narrate "<&6>You own these work stations<&co>"
    - foreach <player.flag[jobs.blocks_owned]> as:workstation:
      - narrate "<&6>A <&e><[workstation].before[~].replace[_].with[ ].to_titlecase> <&6>located at<&co> <&e><[workstation].before_last[~].after[~].replace_text[,].with[ ]> <&6>in world<&co> <&e><[workstation].after_last[~]>"
  - else:
    - narrate "<&a>You do not own any work stations."
