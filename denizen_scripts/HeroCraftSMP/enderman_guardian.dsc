enderman_guardian:
  type: entity
  debug: false
  entity_type: enderman
  mechanisms:
    custom_name: <&d>Ender Guardian
    custom_name_visible: true
    health_data: 2000/2000
    has_ai: false
  flags:
    on_damaged: enderman_guardian_damaged
    on_teleport: enderman_guardian_teleport_cancel
    on_death: enderman_guardian_death

enderman_guardian_minion:
  type: entity
  debug: false
  entity_type: enderman
  mechanisms:
    custom_name: <&d>Enderman
    custom_name_visible: true
    health_data: 50/50
  flags:
    on_teleport: enderman_guardian_teleport_cancel
    on_death: enderman_guardian_drop_cancel

enderman_guardian_start:
  type: task
  debug: false
  definitions: location
  script:
    # Initial Calculations
    - repeat 9:
      - define loc_<[value]> <[location].with_pose[0,<[value].mul[40]>]>
      - define safety_dance_zone_<[value]> <proc[define_cone1].context[<[loc_<[value]>]>|<[loc_<[value]>].forward[15]>|20|1].parse[with_y[<[loc_<[value]>].y>]]>
      - wait 1s
    - define loc_10 <[location].with_pose[45,0]>
    - define safety_dance_zone_10 <proc[define_cone1].context[<[loc_10]>|<[loc_10].above[15]>|20|1].parse[with_y[<[loc_10].y>]]>
    - wait 1s
    - define all_players <[location].find_players_within[100]>
    # Opening Animation
    - repeat 60:
      - playeffect effect:DRAGON_BREATH at:<[location].above[1.5]> offset:0.2 data:0.2 quantity:20 targets:<[all_players]>
      - wait 1t

    # Start the Fight
    - bossbar ender_guardian color:purple create progress:1 "title:<&d>Ender Guardian" players:<[all_players]>
    - define location <player.location> if:<[location].exists.not>
    - spawn enderman_guardian <[location]> save:boss
    - flag server enderman_boss:<entry[boss].spawned_entity>
    - if <entry[boss].spawned_entity.exists>:
      - repeat 10:
        - flag <entry[boss].spawned_entity> safety_dance.<[value]>.location:<[loc_<[value]>]>
        - flag <entry[boss].spawned_entity> safety_dance.<[value]>.zone:<[safety_dance_zone_<[value]>]>
      #- while <entry[boss].spawned_entity.is_spawned> && <entry[boss].spawned_entity.health_percentage> > 33:
      - flag <entry[boss].spawned_entity> phase:1
      - run enderman_guardian_phase_1 def:<entry[boss].spawned_entity>


enderman_guardian_phase_1:
  type: task
  debug: false
  definitions: boss
  script:
    # Initialize Definitions
    - define spawnable_blocks <[boss].filter[y.equals[52]]>
    - define all_players <[boss].location.find_players_within[100]>
    - define targets <[boss].location.find_players_within[6]>
    # Knockback Explosion
    - repeat 120:
      - playeffect effect:DRAGON_BREATH at:<[boss].location.above[1.5]> offset:<[value].div[100]> data:0.2 quantity:<[value].div[10]> targets:<[all_players]>
      - wait 1t if:<[value].mod[10].equals[0]>
    - foreach <[targets]> as:target:
      - adjust <[target]> velocity:<[target].location.sub[<[boss].location>].normalize.mul[5].with_y[1]>
      - flag <[target]> "custom_damage.cause:<&d>Ender Guardian Explosion"
      - hurt 5 <[target]> cause:custom
    - wait 1s
    - if <[all_players].filter[gamemode.equals[adventure]].size> < 4:
      - define spawns_per_wave 8
    - else:
      - define spawns_per_wave <[all_players].filter[gamemode.equals[adventure]].size.mul[2]>
    # Spawn Adds
    ## Waves of Minions
    - repeat 5:
      ## Minions Per Wave
      - repeat <[spawns_per_wave]>:
        - stop if:<[boss].is_spawned.not>
        - run enderman_guardian_spawn_enderman def:<[boss]>|<[spawnable_blocks].random>
        - wait 2s
      - wait 10s
    - if <[boss].is_spawned> && <[boss].flag[phase]> != 3:
      - flag <[boss]> phase:2
      - run enderman_guardian_phase_2 def:<[boss]>
    - if !<[boss].is_spawned>:
      - bossbar remove ender_guardian

enderman_guardian_spawn_enderman:
  type: task
  debug: false
  definitions: boss|destination
  script:
    # Definitions
    - define all_players <[boss].location.find_players_within[100]>
    - define start <[boss].eye_location.below.forward[0.5]>
    - define points <proc[define_curve1].context[<[start]>|<[destination]>|5|90|0.5]>

    # Play Arc Animation
    - foreach <[points]> as:point:
      - playeffect effect:DRAGON_BREATH at:<[point]> quantity:10 offset:0.1 targets:<[all_players]>
      - wait 1t if:<[loop_index].mod[2].equals[0]>

    # Spawn Animation
    - repeat 5:
      - playeffect effect:DRAGON_BREATH at:<[destination].above[1]> quantity:50 offset:0.2,1,0.2 targets:<[all_players]>

    # Spawn the Mob
    - spawn enderman_guardian_minion <[destination]> target:<[all_players].sort_by_number[distance[<[destination]>]].first> save:minion
    - wait 10s
    - if <entry[minion].spawned_entity.is_spawned>:
      - run enderman_guardian_minion_expire def:<entry[minion].spawned_entity>|<[boss]>

enderman_guardian_phase_2:
  type: task
  debug: false
  definitions: boss
  script:
    # Definitions
    - define all_players <[boss].location.find_players_within[100]>

    # Safety Dance
    - repeat 15:
      - stop if:<[boss].is_spawned.not>
      - define players_nearby <[boss].location.find_players_within[6]>
      - if <[players_nearby].size> > 1 && <util.random_chance[25]>:
        - define number 10
      - else:
        - define number <util.random.int[1].to[9]>
      - teleport <[boss]> <[boss].flag[safety_dance.<[number]>.location]>
      - wait 2s
      - if <[number]> == 10:
        - repeat 10:
          - define targets <[boss].location.find_players_within[5]>
          - playeffect effect:DRAGON_BREATH at:<[boss].flag[safety_dance.<[number]>.zone]> quantity:1 velocity:0,0.2,0 targets:<[all_players]>
          - flag <[targets]> "custom_damage.cause:<&d>The Safety Dance"
          - hurt 8 <[targets]> cause:custom
          - wait 2t
      - else:
        - repeat 10:
          - define targets <[all_players].filter_tag[<[boss].location.facing[<[filter_value].location>].degrees[25]>]>
          - playeffect effect:DRAGON_BREATH at:<[boss].flag[safety_dance.<[number]>.zone]> quantity:1 velocity:0,0.2,0 targets:<[all_players]>
          - flag <[targets]> "custom_damage.cause:<&d>The Safety Dance"
          - hurt 8 <[targets]> cause:custom
          - wait 2t
    - wait 1s
    - if <[boss].is_spawned> && <[boss].flag[phase]> != 3:
      - flag <[boss]> phase:1
      - run enderman_guardian_phase_1 def:<[boss]>
    - if !<[boss].is_spawned>:
      - bossbar remove ender_guardian


enderman_guardian_phase_3:
  type: task
  debug: false
  definitions: boss
  script:
    - while <[boss].is_spawned> && <[boss].flag[phase]> == 3:
      - run enderman_guardian_phase_1 def:<[boss]>
      - ~run enderman_guardian_phase_2 def:<[boss]>

# Entity Task Scripts
enderman_guardian_damaged:
  type: task
  debug: false
  script:
    - bossbar update ender_guardian progress:<context.entity.health_percentage.div[100]>
    - if <context.entity.health_percentage> <= 33 && <context.entity.flag[phase]> != 3:
      - run enderman_guardian_phase_3

enderman_guardian_death:
  type: task
  debug: false
  script:
    - bossbar remove ender_guardian
    - flag server enderman_guardian_defeated

enderman_guardian_teleport_cancel:
  type: task
  debug: false
  script:
    - determine cancelled

enderman_guardian_minion_expire:
  type: task
  debug: false
  definitions: entity|boss
  script:
    # Definitions
    - define all_players <[boss].location.find_players_within[100]>
    - define points <[entity].location.above.points_between[<[boss].eye_location>].distance[0.5]>

    # Remove and Heal Boss
    - adjust <[entity]> has_ai:false
    - repeat 5:
      - playeffect effect:DRAGON_BREATH at:<[entity].location.above> quantity:20 ofset:0.2,0.5,0.2 targets:<[all_players]>
      - wait 2t
    - stop if:<[entity].is_spawned.not>
    - define health <[entity].health.mul[<[all_players].filter[gamemode.equals[adventure]].size>]>
    - remove <[entity]>
    - narrate "<&e>An Enderman gives his life to the Guardian." targets:<[all_players]>
    - stop if:<[boss].is_spawned.not>
    - foreach <[points]> as:point:
      - playeffect effect:DRAGON_BREATH at:<[point]> quantity:4 offset:0.1 targets:<[all_players]>
      - wait 1t
    - heal <[health]> <[boss]>
    - bossbar update ender_guardian progress:<[boss].health_percentage.div[100]>

enderman_guardian_marker_1:
  type: entity
  entity_type: armor_stand
  mechanisms:
    gravity: false
    visible: false
    marker: true
  flags:
    on_entity_added: enderman_guardian_task_1

enderman_guardian_marker_2:
  type: entity
  entity_type: armor_stand
  mechanisms:
    gravity: false
    visible: false
    marker: true
  flags:
    on_entity_added: enderman_guardian_task_2

enderman_guardian_marker_3:
  type: entity
  entity_type: armor_stand
  mechanisms:
    gravity: false
    visible: false
    marker: true
  flags:
    on_entity_added: enderman_guardian_task_3

enderman_guardian_marker_4:
  type: entity
  entity_type: armor_stand
  mechanisms:
    gravity: false
    visible: false
    marker: true

enderman_guardian_task_1:
  type: task
  debug: false
  script:
    - wait 3s
    - stop if:<context.entity.is_spawned.not>
    - define blocks <context.entity.location.find_blocks[air|glass].within[7].filter[y.equals[114]]>
    - while <context.entity.is_spawned> && !<server.has_flag[enderman_guardian_active]>:
      - define targets <context.entity.location.find_players_within[120]>
      - foreach <[targets]>:
        - if <[value].fake_block[<[blocks].first>].exists>:
          - foreach next
        - showfake <[blocks]> stone_bricks duration:5h players:<[value]>
        - wait 1t
      - wait 5s
    - while <context.entity.is_spawned> && <server.has_flag[enderman_guardian_active]>:
      - define targets <context.entity.location.find_players_within[120]>
      - foreach <[targets]>:
        - if !<[value].fake_block[<[blocks].first>].exists>:
          - foreach next
        - showfake <[blocks]> cancel players:<[value]>
        - wait 1t
      - wait 5s

enderman_guardian_task_2:
  type: task
  debug: false
  script:
    - wait 3s
    - stop if:<context.entity.is_spawned.not>
    - define blocks <context.entity.location.find_blocks[air|stone_brick_stairs].within[7].filter[y.equals[51]]>
    - while <context.entity.is_spawned> && !<server.has_flag[enderman_guardian_defeated]>:
      - define targets <context.entity.location.find_players_within[120]>
      - foreach <[targets]>:
        - if <[value].fake_block[<[blocks].first>].exists>:
          - foreach next
        - showfake <[blocks]> stone_bricks duration:5h players:<[value]>
        - wait 1t
      - wait 5s
    - while <context.entity.is_spawned> && <server.has_flag[enderman_guardian_defeated]>:
      - define targets <context.entity.location.find_players_within[120]>
      - foreach <[targets]>:
        - if !<[value].fake_block[<[blocks].first>].exists>:
          - foreach next
        - showfake <[blocks]> cancel players:<[value]>
        - wait 1t
      - wait 5s

enderman_guardian_task_3:
  type: task
  debug: false
  script:
    - wait 3s
    - stop if:<context.entity.is_spawned.not>
    - while <context.entity.is_spawned>:
      - define targets <context.entity.location.find_players_within[140]>
      - foreach <[targets]>:
        - if <list[adventure|spectator].contains[<[value].gamemode>]>:
          - foreach next
        - adjust <[value]> gamemode:adventure
        - flag <[value]> on_death:keep_inventory
        - flag server gamemode_changer.<context.entity.uuid>:->:<[value]>
        - wait 1t
      - foreach <server.flag[gamemode_changer.<context.entity.uuid>].exclude[<[targets]>].if_null[<list>]>:
        - adjust <[value]> gamemode:survival
        - flag <[value]> on_death:!
        - flag server gamemode_changer.<context.entity.uuid>:<-:<[value]>
        - wait 1t
      - wait 5s
    - foreach <server.flag[gamemode_changer.<context.entity.uuid>].exclude[<[targets]>].if_null[<list>]>:
      - adjust <[value]> gamemode:survival
      - wait 1t
    - flag server gamemode_changer.<context.entity.uuid>:!

jungle_temple_lever:
  type: task
  debug: false
  script:
    - wait 1t
    - stop if:<server.has_flag[enderman_guardian_active]>
    - if <context.location.material.name> == lever:
      - if <context.location.switched>:
        - flag server enderman_boss_levers:+:1
      - else:
        - flag server enderman_boss_levers:-:1
      - if <server.flag[enderman_boss_levers]> == 8:
        - flag server enderman_guardian_active

jungle_temple_lever_2:
  type: task
  debug: false
  script:
    - ratelimit <context.location> 15s
    - if <server.flag[enderman_boss].is_spawned.if_null[false]>:
      - stop
    - define blocks <context.location.find_blocks_flagged[lever_disappear].within[7]>
    - if <[blocks].first.material.name> != air:
      - modifyblock <[blocks]> air
    - run enderman_guardian_start def:<context.location.find_entities[enderman_guardian_marker_4].within[50].first.location>

enderman_guardian_drop_cancel:
  type: task
  debug: false
  script:
    - determine NO_DROPS