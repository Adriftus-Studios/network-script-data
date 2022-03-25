bowtrails_gui_command:
  type: command
  name: bowtrails
  debug: false
  usage: /bowtrails
  description: Used to access and change any unlocked cosmetic bow trails.
  aliases:
    - bowtrail
    - bt
  script:
    - run cosmetic_selection_inventory_open def:bowtrails

bowtrails_equip:
  type: task
  debug: false
  definitions: bowtrail_id
  script:
    - determine passively cancelled
    - define bowtrail_id <context.item.flag[cosmetic].if_null[default]> if:<[bowtrail_id].exists.not>
    - run global_player_data_modify def:<player.uuid>|bowtrails.current|<context.item.flag[cosmetic]>
    - flag player bowtrail:<[bowtrail_id]>
    - if <context.inventory.exists>:
      - define info_item <context.inventory.slot[<script[cosmetic_selection_inventory_open].data_key[data.slot_data.remove_slot]>]>
      - run cosmetic_selection_inventory_open def:<[info_item].flag[type]>|<[info_item].flag[page]>

bowtrails_unlock:
  type: task
  debug: false
  definitions: bowtrail_id
  script:
    - if <yaml[bowtrails].contains[bowtrails.<[bowtrail_id]>]> && !<yaml[global.player.<player.uuid>].contains[bowtrails.unlocked.<[bowtrail_id]>]>:
      - run global_player_data_modify def:<player.uuid>|bowtrails.unlocked.<[bowtrail_id]>|true

bowtrails_remove:
  type: task
  debug: false
  definitions: bowtrail_id
  script:
    - determine passively cancelled
    - define bowtrail_id <context.item.flag[cosmetic].if_null[default]> if:<[bowtrail_id].exists.not>
    - run global_player_data_modify def:<player.uuid>|bowtrails.current|!
    - if <context.inventory.exists>:
      - define info_item <context.inventory.slot[<script[cosmetic_selection_inventory_open].data_key[data.slot_data.remove_slot]>]>
      - run cosmetic_selection_inventory_open def:<[info_item].flag[type]>|<[info_item].flag[page]>

bowtrails_initialize:
  type: world
  debug: false
  load_yaml:
    - if <yaml.list.contains[bowtrails]>:
      - yaml id:bowtrails unload
    - if <server.has_file[data/global/network/bowtrails.yml]>:
      - ~yaml id:bowtrails load:data/global/network/bowtrails.yml
  events:
    on server start:
      - inject locally path:load_yaml
    on reload scripts:
      - yaml id:bowtrails unload
      - inject locally path:load_yaml

bowtrails_handler:
  type: world
  debug: false
  events:
    on player joins:
      - waituntil rate:20t <yaml.list.contains[global.player.<player.uuid>]>
      - if <yaml[global.player.<player.uuid>].read[bowtrails.current]||null> != null:
        - flag player bowtrail:<yaml[global.player.<player.uuid>].read[bowtrails.current]>
    on player quits:
      - if <player.has_flag[bowtrail]>:
        - flag player bowtrail:!
    on player shoots bow flagged:bowtrail:
      - ratelimit <player> 1s
      - if <yaml[bowtrails].contains[bowtrails.<player.flag[bowtrail]>.trail_type]> && <script[bow_trail_<yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.trail_type]>]||invalid> != invalid:
        - inject bow_trail_<yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.trail_type]>
    after player shoots block with:arrow flagged:bowtrail:
      - if <context.projectile.has_flag[no_trail]>:
        - stop
      - if <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.trail_type].starts_with[block]>:
        - spawn armor_stand[marker=true;fire_time=5s;gravity=false;visible=false;equipment=air|air|air|<yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.block]>] <context.projectile.location.add[0,-1.6,0]> save:as
        - wait 3s
        - remove <entry[as].spawned_entity>

####################
## BOWTRAIL TYPES ##
####################
bow_trail_data:
  type: task
  debug: false
  script:
    - choose <player.flag[bowtrail]>:
      - case Rainbow:
        - define colors <list[red|orange|yellow|green|blue|purple]>
        - wait 1t
        - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
          - if !<context.projectile.is_spawned>:
            - stop
          - playeffect redstone at:<context.projectile.location> quantity:5 offset:0.25 special_data:2|<[colors].get[<[value].mod[6].add[1]>]> targets:<player.world.players>
          - wait <yaml[bowtrails].read[settings.ticksBetween]>t
      - case The_Drew:
        - wait 1t
        - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
          - if !<context.projectile.is_spawned>:
            - stop
          - playeffect redstone at:<context.projectile.location> quantity:3 offset:0.25 special_data:2|red targets:<player.world.players>
          - playeffect redstone at:<context.projectile.location> quantity:3 offset:0.25 special_data:2|black targets:<player.world.players>
          - wait <yaml[bowtrails].read[settings.ticksBetween]>t
      - case Ice:
        - wait 1t
        - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
          - if !<context.projectile.is_spawned>:
            - stop
          - playeffect block_crack at:<context.projectile.location> quantity:3 offset:0.25 special_data:ice targets:<player.world.players>
          - playeffect falling_dust at:<context.projectile.location> quantity:3 offset:0.25 special_data:ice targets:<player.world.players>
          - wait <yaml[bowtrails].read[settings.ticksBetween]>t

bow_trail_dust:
  type: task
  debug: false
  script:
    - define block <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.material_dust]>
    - wait 1t
    - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
      - if !<context.projectile.is_spawned>:
        - stop
      - playeffect falling_dust at:<context.projectile.location> quantity:5 offset:0.25 special_data:<[block]> targets:<player.world.players>
      - wait <yaml[bowtrails].read[settings.ticksBetween]>t

bow_trail_particle:
  type: task
  debug: false
  script:
    - define particle <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.particle]>
    - wait 1t
    - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
      - if !<context.projectile.is_spawned>:
        - stop
      - playeffect <[particle]> at:<context.projectile.location> quantity:5 offset:0.25 targets:<player.world.players>
      - wait <yaml[bowtrails].read[settings.ticksBetween]>t

bow_trail_moving_particle:
  type: task
  debug: false
  script:
    - define particle <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.particle]>
    - define movement <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.speed]>
    - wait 1t
    - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
      - if !<context.projectile.is_spawned>:
        - stop
      - playeffect <[particle]> at:<context.projectile.location> quantity:5 offset:0.25 data:<[movement]> targets:<player.world.players>
      - wait <yaml[bowtrails].read[settings.ticksBetween]>t

bow_trail_item_crack:
  type: task
  debug: false
  script:
    - define block <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.item_trail_type]>
    - wait 1t
    - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
      - if !<context.projectile.is_spawned>:
        - stop
      - playeffect item_crack at:<context.projectile.location> quantity:5 offset:0.25 special_data:<[block]> targets:<player.world.players>
      - wait <yaml[bowtrails].read[settings.ticksBetween]>t

bow_trail_block_break:
  type: task
  debug: false
  script:
    - define block <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.material]>
    - wait 1t
    - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
      - if !<context.projectile.is_spawned>:
        - stop
      - playeffect block_crack at:<context.projectile.location> quantity:5 offset:0.25 special_data:<[block]> targets:<player.world.players>
      - wait <yaml[bowtrails].read[settings.ticksBetween]>t

bow_trail_2_color:
  type: task
  debug: false
  script:
    - wait 1t
    - define color1 <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.color1]>
    - define color2 <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.color2]>
    - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
      - if !<context.projectile.is_spawned>:
        - stop
      - playeffect redstone at:<context.projectile.location> quantity:3 offset:0.25 special_data:2|<[color1]> targets:<player.world.players>
      - playeffect redstone at:<context.projectile.location> quantity:3 offset:0.25 special_data:2|<[color2]> targets:<player.world.players>
      - wait <yaml[bowtrails].read[settings.ticksBetween]>t

bow_trail_block_with_particle:
  type: task
  debug: false
  script:
    - wait 1t
    - define particle <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.particle]>
    - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
      - if !<context.projectile.is_spawned>:
        - stop
      - playeffect <[particle]> at:<context.projectile.location> quantity:5 offset:0.25 targets:<player.world.players>
      - wait <yaml[bowtrails].read[settings.ticksBetween]>t

bow_trail_block_with_dust:
  type: task
  debug: false
  script:
    - wait 1t
    - define block <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.material_dust]>
    - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
      - if !<context.projectile.is_spawned>:
        - stop
      - playeffect FALLING_DUST at:<context.projectile.location> quantity:5 offset:0.25 special_data:<[block]> targets:<player.world.players>
      - wait <yaml[bowtrails].read[settings.ticksBetween]>t

bow_trail_block_2_color:
  type: task
  debug: false
  script:
    - wait 1t
    - define color1 <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.color1]>
    - define color2 <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.color2]>
    - repeat <yaml[bowtrails].read[settings.IterationsPerArrow]>:
      - if !<context.projectile.is_spawned>:
        - stop
      - playeffect redstone at:<context.projectile.location> quantity:3 offset:0.25 special_data:2|<[color1]> targets:<player.world.players>
      - playeffect redstone at:<context.projectile.location> quantity:3 offset:0.25 special_data:2|<[color2]> targets:<player.world.players>
      - wait <yaml[bowtrails].read[settings.ticksBetween]>t