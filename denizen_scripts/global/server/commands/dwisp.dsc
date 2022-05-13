dwisp_command:
  type: command
  debug: false
  name: dwisp
  usage: /dwisp (command) (args)
  description: dWisp
  permission: adriftus.admin
  data:
    tab_complete:
      2:
        spawn: no_arguments
        guard: <server.online_players.parse[name].insert[area].at[1]>
        stay: <list[cursor|here|current].include[<server.online_players.parse[name]>]>
        follow: <server.online_players.parse[name]>
        sleep: no_arguments
        edit: name|color1|color2|target|damage
        assume: on|off
        inventory: <player.flag[dwisp.data.inventories].keys.if_null[<list>].include[off]>
        give: <server.online_players.parse[name]>
  tab completions:
    1: assume|spawn|guard|stay|follow|sleep|edit|inventory|give
    2: <script.parsed_key[data.tab_complete.2.<context.args.get[1]>].if_null[invalid_argument]>
  script:
    - if <context.args.size> < 1:
      - narrate "<&c>You must specify arguments"
      - stop
    - choose <context.args.get[1]>:

      # Spawn
      - case spawn:
        - stop if:<player.has_flag[dwisp.active]>
        - flag player dwisp.active.task:spawn
        - run dwisp_run

      # Follow
      - case follow:
        - if <context.args.get[2].exists>:
          - define target <server.match_player[<context.args.get[2]>].if_null[null]>
          - if <[target]> == null:
            - narrate "<&c>Unknown Player<&co> <context.args.get[2]>"
            - stop
          - flag player dwisp.active.follow_target:<[target]>
        - else:
          - flag player dwisp.active.follow_target:!
        - flag player dwisp.active.queued_actions:->:far_idle
        - flag player dwisp.active.task:!

      # Stay
      - case stay:
        - if <context.args.size> < 2:
          - narrate "<&c>Must Specify a Target!"
        - choose <context.args.get[2]>:
          - case here:
            - flag player dwisp.active.stay_target:<player.location.above[2]>
          - case cursor:
            - flag player dwisp.active.stay_target:<player.cursor_on.center.above[3]>
          - case current:
            - flag player dwisp.active.stay_target:<player.flag[dwisp.active.location]>
          - default:
            - define target <server.match_player[<context.args.get[2]>].if_null[null]>
            - if <[target]> == null:
              - narrate "<&c>Must specify 'cursor', 'current', 'here', or a valid player name"
              - stop
            - define destination <[target].eye_location.forward_flat[6]>
            - if <[destination].material.name> != air:
              - narrate "<&c>Unsafe Destination."
              - stop
            - flag player dwisp.active.stay_target:<[destination]>
        - flag player dwisp.active.queued_actions:->:stay
        - flag player dwisp.active.task:!

      # Guard Player
      - case guard:
        - if <context.args.size> < 2:
          - narrate "<&c>Must Specify Player Name or 'area'!"
          - stop
        - if <context.args.get[2]> == area:
          - if <context.args.get[3].exists>:
            - define target <server.match_player[<context.args.get[3]>].if_null[null]>
            - if <[target]> == null:
              - narrate "<&c>Unknown Player<&co><&e> <context.args.get[3]>"
              - stop
          - else:
            - define target <player>
          - flag player dwisp.active.guard_area:<[target].location>
          - flag player dwisp.active.queued_actions:->:guard_area
          - flag player dwisp.active.task:!
        - else:
          - define target <server.match_player[<context.args.get[2]>].if_null[null]>
          - if <[target]> == null:
            - narrate "<&c>Unknown Player<&co><&e> <context.args.get[2]>"
            - stop
          - flag player dwisp.active.guard_target:<[target]>
          - flag player dwisp.active.queued_actions:->:guard_target
          - flag player dwisp.active.task:!

      # Inventory
      - case inventory:
        - if <context.args.size> < 2:
          - narrate "<&c>Must Specify an Inventory Name!"
          - stop
        - flag player dwisp.data.traits.inventory:<context.args.get[2]>
        - run dwisp_apply_traits

      # Sleep
      - case sleep:
        - flag player dwisp.active.queued_actions:->:sleep
        - flag player dwisp.active.task:!

      # Edit
      - case edit:
        - if <context.args.size> < 3:
          - narrate "<&c>Must Specify a Field and a Value!"
          - stop
        - choose <context.args.get[2]>:
          - case name:
            - flag <player> dwisp.data.name:<context.args.get[3].parsed>
            - if <player.has_flag[dwisp.active.entity]> && <player.flag[dwisp.active.entity].is_spawned>:
              - adjust <player.flag[dwisp.active.entity]> custom_name:<context.args.get[3].parsed>
          - case color1:
            - flag <player> dwisp.data.color1:<context.args.get[3]>
          - case color2:
            - flag <player> dwisp.data.color2:<context.args.get[3]>
          - case target:
            - flag <player> dwisp.data.target:<context.args.get[3]>
          - case damage:
            - flag <player> dwisp.data.damage:<context.args.get[3]>
          - default:
            - narrate "<&c>Unknown field<&co> <context.args.get[2]>"

      # Edit
      - case clear:
        - if <player.has_flag[dwisp.active.entity]> && <player.flag[dwisp.active.entity].is_spawned>:
          - remove <player.flag[dwisp.active.entity]>
        - flag player dwisp.active:!
        - narrate "<&a>Wisp has been cleared"

      # Assume Wisp
      - case assume:
        - if <context.args.size> < 2:
          - narrate "<&c>Not Enough Arguments"
          - stop
        - if <context.args.get[2]> == on:
          - flag player dwisp.active.queued_actions:->:assumed
          - flag player dwisp.active.task:!
        - else if <context.args.get[2]> == off:
          - flag player dwisp.active.task:!
        - else if <context.args.get[2]> == stay:
          - flag player dwisp.active.queued_actions:->:stay
          - flag player dwisp.active.stay_target:<player.location>
          - flag player dwisp.active.task:!
        - else:
          - narrate "<&c>Must Specify 'on' or 'off'"

      # Give
      - case give:
        - if <context.args.size> < 3:
          - narrate "<&c>Not Enough Arguments"
          - stop
        - define target <server.match_player[<context.args.get[2]>].if_null[null]>
        - if <[target]> == null:
          - narrate "<&c>Unknown Player<&co> <context.args.get[2]>"
          - stop
        - define item <item[<context.args.get[3]>].if_null[null]>
        - if <[item]> == null:
          - narrate "<&c>Unknown Item<&co> <context.args.get[3]>"
          - stop
        - flag player dwisp.active.give_target:<[target]>
        - flag player dwisp.active.give_item:<[item]>
        - flag player dwisp.active.queued_actions:->:give
        - flag player dwisp.active.task:!


      #Fallback
      - default:
        - narrate "<&c>Unknown Argument<&co> <context.args.get[1]>"

dwisp_apply_traits:
  type: task
  debug: false
  script:
    - if <player.has_flag[dwisp.active]>:
      - define wisp <player.flag[dwisp.active.entity]>
    - if !<[wisp].is_spawned>:
      - stop
    - foreach <player.flag[dwisp.data.traits]> key:trait as:value:
      - choose <[trait]>:
        - case inventory:
          - flag <[wisp]> inventory:<[value]>
          - if <player.flag[dwisp.data.traits.inventory]> == off && <[wisp].flag[right_click_script].contains[dwisp_open_inventory].if_null[false]>:
            - flag <[wisp]> right_click_script:<-:dwisp_open_inventory
          - else if !<[wisp].flag[right_click_script].contains[dwisp_open_inventory].if_null[false]>:
            - flag <[wisp]> right_click_script:->:dwisp_open_inventory

dwisp_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: <&a>Wisp Inventory
  size: 18
  gui: true
  data:
    clickable_slots:
      1: true
      2: true
      3: true
      4: true
      6: true
      7: true
      8: true
      9: true
      10: true
      11: true
      12: true
      13: true
      14: true
      15: true
      16: true
      17: true
      18: true
    on_close: dwisp_save_inventory

dwisp_save_inventory:
  type: task
  debug: false
  script:
    - define owner <context.inventory.slot[5].flag[owner]>
    - flag <[owner]> dwisp.data.inventories.<context.inventory.slot[5].flag[inventory]>:<context.inventory.map_slots>

dwisp_open_inventory:
  type: task
  debug: false
  script:
    - define inventory <inventory[dwisp_inventory]>
    - define owner <context.entity.flag[owner]>
    - define inventory_name <context.entity.flag[inventory]>
    - if <[owner].has_flag[dwisp.data.inventories.<[inventory_name]>]>:
      - if <[owner].flag[dwisp.data.inventories.<[inventory_name]>.18].exists>:
        - inventory set d:<[inventory]> o:<[owner].flag[dwisp.data.inventories.<[inventory_name]>]>
      - else:
        - inventory set d:<[inventory]> o:<[owner].flag[dwisp.data.inventories.<[inventory_name]>].with[18].as[air]>
    - inventory set slot:5 "o:ender_eye[display=<context.entity.custom_name>;flag=owner:<[owner]>;flag=inventory:<[inventory_name]>;lore=<&e>Messenger of a God]" d:<[inventory]>
    - inventory open d:<[inventory]>

dwisp_armor_stand:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    custom_name_visible: true
    visible: false
    is_small: true
    invincible: true
    gravity: false

dwisp_dropped_item:
  type: entity
  debug: false
  entity_type: dropped_item
  mechanisms:
    custom_name_visible: true
    pickup_delay: 4s
    velocity: 0,-.05,0

dwisp_heal_target:
  type: task
  debug: false
  definitions: target
  script:
    - define distance <player.flag[dwisp.active.location].distance[<[target].location>].mul[0.1]>
    - define points <player.flag[dwisp.active.location].points_between[<[target].eye_location.below>].distance[<[distance]>]>
    - define targets <player.flag[dwisp.active.location].find_players_within[100]>
    - define start <player.flag[dwisp.active.location]>
    - repeat 10:
      - define point <[start].add[<[target].eye_location.sub[<player.flag[dwisp.active.location]>].mul[<[value].mul[0.1]>]>]>
      - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1|<player.flag[dwisp.data.color1]> targets:<[targets]>
      - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.5|<player.flag[dwisp.data.color2]> targets:<[targets]>
      - wait 1t
    - heal <[target]>
    - feed <[target]>
    - repeat 5:
      - playeffect effect:redstone at:<[target].location.above> offset:0.25,0.5,0.25 quantity:10 special_data:2|<player.flag[dwisp.data.color1]> targets:<[targets]>
      - playeffect effect:redstone at:<[target].location.above> offset:0.25,0.5,0.25 quantity:10 special_data:1|<player.flag[dwisp.data.color2]> targets:<[targets]>
      - wait 1t
    - ratelimit <[target]> 5s
    - narrate "<&a>You Feel Invigorated" targets:<[target]>

dwisp_kill_target:
  type: task
  debug: false
  definitions: target
  script:
    - stop if:<[target].is_spawned.not>
    - define distance <player.flag[dwisp.active.location].distance[<[target].location>].mul[0.1]>
    - define points <player.flag[dwisp.active.location].points_between[<[target].eye_location.below>].distance[<[distance]>]>
    - define targets <player.flag[dwisp.active.location].find_players_within[100]>
    - define start <player.flag[dwisp.active.location]>
    - repeat 10:
      - define point <[start].add[<[target].eye_location.sub[<player.flag[dwisp.active.location]>].mul[<[value].mul[0.1]>]>]>
      - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1|<player.flag[dwisp.data.color1]> targets:<[targets]>
      - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.5|<player.flag[dwisp.data.color2]> targets:<[targets]>
      - wait 1t
    - repeat 5:
      - playeffect effect:redstone at:<[target].location.above> offset:0.25,0.5,0.25 quantity:10 special_data:2|<player.flag[dwisp.data.color1]> targets:<[targets]>
      - playeffect effect:redstone at:<[target].location.above> offset:0.25,0.5,0.25 quantity:10 special_data:1|<player.flag[dwisp.data.color2]> targets:<[targets]>
      - wait 1t
    - if <player.has_flag[dwisp.data.damage]> && <player.flag[dwisp.data.damage]> != kill:
      - hurt <player.flag[dwisp.data.damage]> <[target]>
    - else:
      - kill <[target]>

dwisp_goto:
  type: task
  debug: false
  definitions: destination
  script:
    - if <player.flag[dwisp.active.location].world> != <[destination].world>:
      - flag player dwisp.active.location:<[destination].above[30]>
      - define points <proc[define_spiral].context[<[destination].above[30]>|<[destination]>|1|1|1]>
      - define targets <[destination].find_players_within[100]>
      - foreach <[points]> as:point:
        - if <[loop_index].mod[2]> == 0:
          - wait 1t
        - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
        - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
        - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
        - flag player dwisp.active.location:<[point]>
    - else if <player.flag[dwisp.active.location].distance[<[destination]>]> > 80:
      - define points <proc[define_spiral].context[<player.flag[dwisp.active.location]>|<player.flag[dwisp.active.location].above[30]>|1|1|1]>
      - define targets <player.flag[dwisp.active.location].find_players_within[100]>
      - foreach <[points]> as:point:
        - if <[loop_index].mod[2]> == 0:
          - wait 1t
        - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
        - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
        - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
        - flag player dwisp.active.location:<[point]>
      - flag player dwisp.active.location:<[destination].above[30]>
      - define points <proc[define_spiral].context[<[destination].above[30]>|<[destination]>|1|1|1]>
      - define targets <[destination].find_players_within[100]>
      - foreach <[points]> as:point:
        - if <[loop_index].mod[2]> == 0:
          - wait 1t
        - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
        - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
        - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
        - flag player dwisp.active.location:<[point]>

dwisp_run:
  type: task
  debug: false
  script:
    - if !<player.has_flag[dwisp.data.color1]> || !<player.has_flag[dwisp.data.color2]>:
      - narrate "<&c>You must configure your dWisp colors first"
    - if !<player.has_flag[dwisp.data.name]>:
      - narrate "<&c>You must configure your dWisp name first"
      - stop
    - while <player.has_flag[dwisp.active]> && <player.is_online>:
      - choose <player.flag[dwisp.active.task].if_null[default]>:
        # Basic Idle Animation
        - case idle:
          - while <player.flag[dwisp.active.task].if_null[default]> == idle && <player.is_online>:
            - if <player.location.world> != <player.flag[dwisp.active.location].world>:
              - flag player dwisp.active.location:<player.eye_location.above.backward_flat>
            - define points <proc[define_curve1].context[<player.flag[dwisp.active.location]>|<player.location.above[2].random_offset[1,0.5,1]>|2|<util.random.int[-20].to[20]>|<player.flag[dwisp.active.location].distance[<player.eye_location>].mul[0.1]>]>
            - define targets <player.location.find_players_within[100]>
            - foreach <[points]> as:point:
              - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
              - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
              - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
              - flag player dwisp.active.location:<[point]>
              - wait 2t

        # Far Idle (5 opposed to 2 blocks)
        - case far_idle:
          - if <player.has_flag[dwisp.active.follow_target]> && <player.flag[dwisp.active.follow_target].is_online>:
            - define target <player.flag[dwisp.active.follow_target]>
          - else:
            - define target <player>
          - while <player.flag[dwisp.active.task].if_null[default]> == far_idle && <[target].is_online>:
            - ~run dwisp_goto def:<[target].eye_location.above[5]>
            - define destination <[target].location.add[<[target].location.sub[<player.flag[dwisp.active.location]>].normalize.mul[5]>].with_y[<[target].eye_location.above.y>]>
            - define points <proc[define_curve1].context[<player.flag[dwisp.active.location]>|<[destination].random_offset[3,1,3]>|3|<util.random.int[-20].to[20]>|<player.flag[dwisp.active.location].distance[<[destination]>].mul[0.05]>]>
            - define targets <[target].location.find_players_within[100]>
            - foreach <[points]> as:point:
              - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
              - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
              - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
              - flag player dwisp.active.location:<[point]>
              - wait 2t

        # Spawning Wisp
        - case spawn:
          - flag player dwisp.active.location:<player.eye_location.above[30]>
          - flag player dwisp.data.target:monster if:<player.has_flag[dwisp.data.target].not>
          - define targets <player.location.find_players_within[100]>
          - spawn dwisp_armor_stand[custom_name=<player.flag[dwisp.data.name]>] <player.eye_location.above[30]> save:wisp
          - flag player dwisp.active.entity:<entry[wisp].spawned_entity>
          - flag <entry[wisp].spawned_entity> on_entity_added:remove_this_entity
          - flag <entry[wisp].spawned_entity> owner:<player>
          - run dwisp_apply_traits
          - define points <proc[define_spiral].context[<player.location.above[30]>|<player.location.above[5]>|1|1|1]>
          - define targets <player.location.find_players_within[100]>
          - foreach <[points]> as:point:
            - if <[loop_index].mod[2]> == 0:
              - wait 1t
            - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
            - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
            - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
            - flag player dwisp.active.location:<[point]>
          - flag player dwisp.active.task:!

        # Despawning Wisp
        - case sleep:
          - define points <proc[define_spiral].context[<player.flag[dwisp.active.location]>|<player.flag[dwisp.active.location].above[30]>|1|1|1]>
          - define targets <player.flag[dwisp.active.location].find_players_within[100]>
          - foreach <[points]> as:point:
            - if <[loop_index].mod[2]> == 0:
              - wait 1t
            - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
            - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
            - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
            - flag player dwisp.active.location:<[point]>
          - remove <player.flag[dwisp.active.entity]>
          - flag player dwisp.active:!

        # Guard Player
        - case guard_target:
          - define target <player.flag[dwisp.active.guard_target]>
          - while <player.flag[dwisp.active.task].if_null[default]> == guard_target && <player.is_online> && <[target].is_online>:
            - ~run dwisp_goto def:<[target].eye_location.above[5]>
            - if <[target].health> != <[target].health_max>:
              - run dwisp_heal_target def:<[target]>
            - define mob <[target].location.find_entities[<player.flag[dwisp.data.target]>].within[30].exclude[<player>|<[target]>].random.if_null[none]>
            - if <[mob]> != none && <[mob].is_spawned>:
              - define points <proc[define_curve1].context[<player.flag[dwisp.active.location]>|<[mob].eye_location>|2|<util.random.int[-20].to[20]>|<player.flag[dwisp.active.location].distance[<[mob].eye_location>].mul[0.1]>]>
            - else:
              - define points <proc[define_curve1].context[<player.flag[dwisp.active.location]>|<[target].location.above[2].random_offset[1,0.5,1]>|2|<util.random.int[-20].to[20]>|<player.flag[dwisp.active.location].distance[<[target].eye_location>].mul[0.1]>]>
            - define targets <[target].location.find_players_within[100]>
            - foreach <[points]> as:point:
              - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
              - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
              - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
              - flag player dwisp.active.location:<[point]>
              - wait 2t
            - if <[mob]> != none && <[mob].is_spawned>:
              - repeat 10:
                - playeffect effect:redstone at:<[mob].location.above> offset:0.25,0.75,0.25 quantity:20 special_data:5|<player.flag[dwisp.data.color1]> targets:<[targets]>
                - playeffect effect:redstone at:<[mob].location.above> offset:0.25,0.75,0.25 quantity:20 special_data:2|<player.flag[dwisp.data.color2]> targets:<[targets]>
                - wait 1t
              - if <player.has_flag[dwisp.data.damage]> && <player.flag[dwisp.data.damage]> != kill:
                - hurt <player.flag[dwisp.data.damage]> <[mob]>
              - else:
                - kill <[mob]>
              - wait 2t
          - flag player dwisp.active.task:!

        # Guard Area
        - case guard_area:
          - ~run dwisp_goto def:<player.eye_location.above[5]>
          - define target <player.flag[dwisp.active.guard_area].if_null[<player.location>]>
          - define points <proc[define_curve1].context[<player.flag[dwisp.active.location]>|<[target].above[20]>|2|90|0.75]>
          - define targets <[target].find_players_within[100]>
          - foreach <[points]> as:point:
            - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
            - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
            - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
            - flag player dwisp.active.location:<[point]>
            - wait 2t
          - while <player.flag[dwisp.active.task].if_null[default]> == guard_area:
            - define targets <player.flag[dwisp.active.location].find_players_within[100]>
            - repeat 10:
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
              - wait 2t
            - define mobs <player.flag[dwisp.active.location].find_entities[<player.flag[dwisp.data.target]>].within[36].exclude[<player>]>
            - foreach <[mobs]> as:target:
              - run dwisp_kill_target def:<[target]>
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
              - wait 2t
          - flag player dwisp.active.task:!

        # Stay Put
        - case stay:
            - define target <player.flag[dwisp.active.stay_target].if_null[null]>
            - define target <player.cursor_on.center.above[2].if_null[<player.location.above[3]>]> if:<[target].equals[null]>
            - ~run dwisp_goto def:<[target].above[5]>
            - define points <proc[define_curve1].context[<player.flag[dwisp.active.location]>|<[target]>|2|<util.random.int[-20].to[20]>|<player.flag[dwisp.active.location].distance[<[target]>].mul[0.1]>]>
            - define targets <[target].find_players_within[100]>
            - foreach <[points]> as:point:
              - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
              - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
              - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
              - flag player dwisp.active.location:<[point]>
              - wait 2t
            - while <player.flag[dwisp.active.task].if_null[default]> == stay:
              - if <[loop_index].mod[50]> == 0:
                - define targets <[target].find_players_within[100]>
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
              - wait 2t
            - flag player dwisp.active.task:!

        # Give Player Item
        - case give:
            # Get Definition Flags
            - define target <player.flag[dwisp.active.give_target]>
            - define item <player.flag[dwisp.active.give_item]>

            # Spawn Item Infront of Self
            - if <[target]> == <player>:
              - ~run dwisp_goto def:<player.eye_location.above[5]>
              - define points <proc[define_curve1].context[<player.flag[dwisp.active.location]>|<player.eye_location.forward_flat[4]>|2|90|<player.flag[dwisp.active.location].distance[<player.eye_location>].mul[0.1]>]>
              - foreach <[points]> as:point:
                - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
                - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
                - flag player dwisp.active.location:<[point]>
                - wait 2t
              - flag player dwisp.active.task:far_idle

            - else:
              - ~run dwisp_goto def:<[target].eye_location.above[5]>
              - define points <proc[define_curve1].context[<player.flag[dwisp.active.location]>|<[target].eye_location.forward_flat[4]>|1|90|<player.flag[dwisp.active.location].distance[<player.eye_location>].mul[0.1]>]>
              - define targets <[target].location.find_players_within[100]>
              - foreach <[points]> as:point:
                - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
                - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
                - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
                - flag player dwisp.active.location:<[point]>
                - wait 2t
            - repeat 10:
              - teleport <player.flag[dwisp.active.entity]> <player.flag[dwisp.active.location].below[0.5]>
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
              - wait 2t
            - repeat 3:
              - teleport <player.flag[dwisp.active.entity]> <player.flag[dwisp.active.location].below[0.5]>
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.05 quantity:10 special_data:2|<player.flag[dwisp.data.color1]> targets:<[targets]>
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.1 quantity:10 special_data:1|<player.flag[dwisp.data.color2]> targets:<[targets]>
              - wait 2t
            - drop dwisp_dropped_item[item=<[item]>;custom_name=<&a><[item].display.if_null[<[item].formatted>]>] <player.flag[dwisp.active.location]> save:dropped
            - repeat 20:
              - teleport <player.flag[dwisp.active.entity]> <player.flag[dwisp.active.location].below[0.5]>
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
              - playeffect effect:redstone at:<player.flag[dwisp.active.location]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
              - playeffect effect:redstone at:<entry[dropped].dropped_entity.location> offset:0.25 quantity:5 special_data:1|<player.flag[dwisp.data.color1]> targets:<[targets]>
              - playeffect effect:redstone at:<entry[dropped].dropped_entity.location> offset:0.125 quantity:5 special_data:0.5|<player.flag[dwisp.data.color2]> targets:<[targets]>
              - wait 2t

            - flag player dwisp.active.task:!

        # Player Assumes Wisp Form
        - case assumed:
          - define start_loc <player.location>
          - define gamemode <player.gamemode>
          - adjust <player> gamemode:spectator
          - teleport <player> <player.flag[dwisp.active.location]>
          - while <player.flag[dwisp.active.task].if_null[default]> == assumed && <player.is_online>:
            - teleport <player.flag[dwisp.active.entity]> <player.location.below[0.5]>
            - playeffect effect:redstone at:<player.location> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
            - playeffect effect:redstone at:<player.location> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
            - flag player dwisp.active.location:<player.location>
            - wait 2t
          - flag player dwisp.active.task:stay
          - flag player dwisp.active.stay_target:<player.location>
          - adjust <player> location:<[start_loc]>
          - adjust <player> gamemode:<[gamemode]>
          - flag player dwisp.active.task:!

        # Get Next Task
        - default:
          - if !<player.has_flag[dwisp.active.queued_actions]> || <player.flag[dwisp.active.queued_actions].is_empty>:
            - if <player.is_online>:
              - flag player dwisp.active.task:far_idle
              - flag player dwisp.active.follow_target:!
            - else:
              - flag player dwisp.active.task:sleep
              - flag player dwisp.active.task:!
          - else:
            - flag player dwisp.active.task:<player.flag[dwisp.active.queued_actions].first>
            - flag player dwisp.active.queued_actions:!|:<player.flag[dwisp.active.queued_actions].remove[first]>