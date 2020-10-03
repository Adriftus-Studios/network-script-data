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
      - inject bow_trail_<yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.trail_type]>
    after player shoots block with arrow flagged:bowtrail:
      - if <context.projectile.has_flag[no_trail]>:
        - stop
      - if <yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.trail_type].starts_with[block]>:
        - spawn armor_stand[marker=true;fire_time=5s;gravity=false;visible=false;equipment=air|air|air|<yaml[bowtrails].read[bowtrails.<player.flag[bowtrail]>.block]>] <context.projectile.location.add[0,-1.6,0]> save:as
        - wait 3s
        - remove <entry[as].spawned_entity>

####################
## BOWTRAIL TYPES ##
####################
bow_trail_custom:
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
          - playeffect redstone at:<context.projectile.location> quantity:5 offset:0.25 special_data:2|<[colors].get[<[value].mod[6].+[1]>]> targets:<player.world.players>
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

###################
## ACCESSOR TASK ##
###################
bowtrail_unlock:
  type: task
  definitions: bowtrail
  debug: false
  script:
    - if <yaml[bowtrails].read[bowtrails.<[bowtrail]>]||null> != null && !<yaml[global.player.<player.uuid>].read[bowtrails.unlocked].contains[<[bowtrail]>]||false>:
      - yaml id:global.player.<player.uuid> set bowtrails.unlocked:|:<[bowtrail]>
    - else:
      - define checks:->:`<&lt>yaml[bowtrails].read[bowtrails.<&lt>[bowtrail]<&gt>]||null<&gt>`
      - define checks:->:`!<&lt>yaml[global.player.<&lt>player.uuid<&gt>].read[bowtrails.unlocked].contains[<&lt>[bowtrail]<&gt>]||false<&gt>`
      - debug error "The The if statement above errored with the check(s): <[checks].separated_by[ | ]>"

bowtrail_remove:
  type: task
  definitions: bowtrail
  debug: false
  script:
    - if <yaml[global.player.<player.uuid>].read[bowtrails.unlocked].contains[<[bowtrail]>]||false>:
      - yaml id:global.player.<player.uuid> set bowtrails.unlocked:<-:<[bowtrail]>
    - else:
      - debug error "The The if statement in `bowtrail_remove` errored with the check: `<&lt>yaml[global.player.<&lt>player.uuid<&gt>].read[bowtrails.unlocked].contains[<&lt>[bowtrail]<&gt>]||false<&gt>`"

##################
## Open Command ##
##################

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
    - inject bowtrails_inventory_open

###################
## Internal Shit ##
###################

bowtrails_inventory:
  type: inventory
  inventory: chest
  debug: false
  size: 54
  title: <yaml[bowtrails].read[gui.title].parse_color>
  custom:
    mapping:
      next_page: 54
      previous_page: 46
      current_bowtrail: 50
      page_marker: 1
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&a>]>
    next_page: <item[arrow].with[display_name=<&a>Next<&sp>Page;nbt=action/next_page]>
    previous_page: <item[arrow].with[display_name=<&c>Previous<&sp>Page;nbt=action/previous_page]>
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

bowtrails_inventory_events:
  type: world
  debug: false
  events:
    on player clicks item in bowtrails_inventory:
      - determine passively cancelled
      - wait 1t
      - if <context.item.has_nbt[action]>:
        - choose <context.item.nbt[action]>:
          - case set_bowtrail:
            - yaml id:global.player.<player.uuid> set bowtrails.current:<context.item.nbt[bowtrail]>
            - flag player bowtrail:<context.item.nbt[bowtrail]>
            - inject bowtrails_inventory_open
            - narrate "<&b>You have changed your active bow trail to<&co> <yaml[bowtrails].read[bowtrails.<context.item.nbt[bowtrail]>.name].parse_color.parsed>"
          - case remove_bowtrail:
            - yaml id:global.player.<player.uuid> set bowtrails.current:!
            - flag player bowtrail:!
            - narrate "<&r>You have removed your Bow Trail."
            - inject bowtrails_inventory_open
          - case next_page:
            - define page <context.inventory.slot[<script[bowtrails_inventory].data_key[custom.mapping.page_marker]>].nbt[page].+[1]>
            - inject bowtrails_inventory_open
          - case previous_page:
            - define page <context.inventory.slot[<script[bowtrails_inventory].data_key[custom.mapping.page_marker]>].nbt[page].-[1]>
            - inject bowtrails_inventory_open

bowtrails_inventory_open:
  type: task
  definitions: page
  debug: false
  script:
    - define page <[page]||1>
    - define inventory <inventory[bowtrails_inventory]>
    - define unlocked_trails <yaml[global.player.<player.uuid>].read[bowtrails.unlocked].as_list||<list[Default]>>
    - foreach <[unlocked_trails]> as:trailID:
      - inject build_trail_select_item
      - define list:->:<[item]>
    - give <[list].get[<[page].-[1].*[21].+[1]>].to[<[page].-[1].*[21].+[21]>]> to:<[inventory]>
    - foreach <script[bowtrails_inventory].list_keys[custom.mapping]>:
      - choose <[value]>:
        - case next_page:
          - if <[unlocked_trails].size> > <[page].-[1].*[21].+[21]>:
            - inventory set d:<[inventory]> slot:<script[bowtrails_inventory].data_key[custom.mapping.next_page]> o:<script[bowtrails_inventory].parsed_key[definitions.next_page]>
        - case previous_page:
          - if <[page]> > 1:
            - inventory set d:<[inventory]> slot:<script[bowtrails_inventory].data_key[custom.mapping.previous_page]> o:<script[bowtrails_inventory].parsed_key[definitions.previous_page]>
        - case current_bowtrail:
          - inject build_current_trail
          - inventory set d:<[inventory]> slot:<script[bowtrails_inventory].data_key[custom.mapping.current_bowtrail]> o:<[item]>
        - case page_marker:
          - inventory set d:<[inventory]> slot:<script[bowtrails_inventory].data_key[custom.mapping.page_marker]> o:<script[bowtrails_inventory].parsed_key[definitions.filler].with[nbt=page/<[page]>]>
    - inventory open d:<[inventory]>

build_trail_select_item:
  type: task
  definitions: trailID
  debug: false
  script:
    - define description <yaml[bowtrails].parsed_key[bowtrails.<[trailID]>.description].parse_color>
    - define material <yaml[bowtrails].read[bowtrails.<[trailID]>.icon]>
    - define display_name <yaml[bowtrails].parsed_key[bowtrails.<[trailID]>.name].parse_color>
    - define lore <yaml[bowtrails].parsed_key[gui.trail_select_item.lore].parse[parse_color]>
    - define name <yaml[bowtrails].parsed_key[gui.trail_select_item.displayname].parse_color>
    - define item <item[<[material]>].with[display_name=<[name]>;lore=<[lore]>;nbt=action/set_bowtrail|bowtrail/<[trailID]>]>

build_current_trail:
  type: task
  debug: false
  script:
    - define trailID <yaml[global.player.<player.uuid>].read[bowtrails.current]||Default>
    - define description <yaml[bowtrails].parsed_key[bowtrails.<[trailID]>.description].parse_color>
    - if <[trailID]> == Default:
      - define name <yaml[bowtrails].parsed_key[gui.no_current_trail.displayname].parse_color>
      - define material <yaml[bowtrails].read[gui.no_current_trail.material]>
      - define lore <yaml[bowtrails].parsed_key[gui.no_current_trail.lore].parse[parse_color]>
      - define item <item[<[material]>].with[display_name=<[name]>;lore=<[lore]>]>
    - else:
      - define display_name <yaml[bowtrails].parsed_key[bowtrails.<[trailID]>.name].parse_color>
      - define name <yaml[bowtrails].parsed_key[gui.current_trail.displayname].parse_color>
      - define material <yaml[bowtrails].read[bowtrails.<[trailID]>.icon]>
      - define lore <yaml[bowtrails].parsed_key[gui.current_trail.lore].parse[parse_color]>
      - define item <item[<[material]>].with[display_name=<[name]>;lore=<[lore]>;nbt=action/remove_bowtrail]>

bowtrail_config_manager:
  type: world
  debug: false
  load_yaml:
    - if <server.has_file[data/global/network/bowtrails.yml]>:
      - yaml id:bowtrails load:data/global/network/bowtrails.yml
  events:
    on server start:
      - inject locally load_yaml
    on reload scripts:
      - inject locally load_yaml
