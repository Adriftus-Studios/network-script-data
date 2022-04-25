test_spawn_blood_crystal:
  type: item
  debug: false
  material: snowball
  mechanisms:
    custom_model_data: 2
  flags:
    on_projectile_launched: test_spawn_blood_raiders_flag_projectile

test_spawn_blood_raiders_flag_projectile:
  type: task
  debug: false
  script:
    - flag <context.entity> on_hit_block:test_spawn_blood_raiders

test_spawn_blood_raiders_split:
  type: task
  debug: false
  script:
    - define locations <context.location.find_spawnable_blocks_within[20].random[3]>
    - foreach <[locations]>:
      - define curve<[loop_index]> <proc[define_curve1].context[<context.location.with_pose[<context.shooter>]>|<[value].with_pose[<context.shooter>]>|5|90|0.5]>
    - repeat <[curve1].size>:
      - playeffect effect:redstone quantity:5 special_data:10|#660000 offset:0.2 at:<[curve1].get[<[value]>]>|<[curve2].get[<[value]>]>|<[curve3].get[<[value]>]> targets:<server.online_players>
      - wait 2t
    - foreach <[locations]>:
      - run test_spawn_blood_raiders def:<[value]>|<[value].above[20]>

test_spawn_blood_raiders:
  type: task
  debug: false
  definitions: start|location
  script:
    - define start <context.location> if:<[start].exists.not>
    - define location <context.location.above[20]> if:<[location].exists.not>
    - define players <[start].find_players_within[100]>
    - foreach <[start].points_between[<[location]>].distance[0.5]>:
      - playeffect effect:redstone quantity:5 special_data:10|#660000 offset:0.2 at:<[value]> targets:<server.online_players>
      - wait 1t
    - repeat 100:
      - playeffect effect:redstone quantity:40 special_data:10|#660000 offset:0.7 at:<[location]> targets:<server.online_players>
      - wait 2t
    - define players <[location].find_players_within[60].filter[gamemode.equals[SURVIVAL]]>
    - run test_spawn_blood_raider_particles
    - if <[players].size> <= 3:
      - define count 5
    - else:
      - define count 3
    - foreach <[players]> as:target:
      - repeat <[count]>:
        - repeat 5:
          - playeffect effect:redstone quantity:40 special_data:10|#660000 offset:0.7 at:<[location]> targets:<server.online_players>
          - wait 2t
        - run test_spawn_blood_raiders_task def:<[location]>|<[target]>
    - repeat 40:
        - playeffect effect:redstone quantity:40 special_data:10|#660000 offset:0.7 at:<[location]> targets:<server.online_players>
        - wait 2t
    - while <server.has_flag[test_spawn_blood_raiders]>:
      - playeffect effect:redstone quantity:40 special_data:10|#660000 offset:0.7 at:<[location]> targets:<server.online_players>
      - wait 4t
    - repeat 40:
        - playeffect effect:redstone quantity:40 special_data:10|#660000 offset:0.7 at:<[location]> targets:<server.online_players>
        - wait 2t
    - define players <[location].find_players_within[60].filter[gamemode.equals[SURVIVAL]]>
    - foreach <[players]> as:target:
      - repeat <[count]>:
        - repeat 5:
          - playeffect effect:redstone quantity:40 special_data:10|#660000 offset:0.7 at:<[location]> targets:<server.online_players>
          - wait 2t
        - run test_spawn_blood_raiders_task2 def:<[location]>|<[target]>
    - repeat 40:
        - playeffect effect:redstone quantity:40 special_data:10|#660000 offset:0.7 at:<[location]> targets:<server.online_players>
        - wait 2t
    - while <server.has_flag[test_spawn_blood_raiders]>:
      - playeffect effect:redstone quantity:40 special_data:10|#660000 offset:0.7 at:<[location]> targets:<server.online_players>
      - wait 4t
    - repeat 40:
        - playeffect effect:redstone quantity:40 special_data:10|#660000 offset:0.7 at:<[location]> targets:<server.online_players>
        - wait 2t
    - define players <[location].find_players_within[60].filter[gamemode.equals[SURVIVAL]]>
    - run test_spawn_blood_raiders_task3 def:<[location]>|<[players].random>


test_spawn_blood_raiders_task:
  type: task
  debug: false
  definitions: location|target_player
  script:
    - define spawn_at <[target_player].location.find_spawnable_blocks_within[8].random>
    - define locations <proc[define_curve1].context[<[location]>|<[spawn_at]>|<util.random.int[5].to[15]>|<util.random.int[45].to[180]>|1]>
    - foreach <[locations]>:
      - playeffect effect:redstone quantity:10 special_data:5|#660000 offset:0.2 at:<[value]> targets:<server.online_players>
      - wait 2t
    - repeat 5:
      - playeffect effect:redstone quantity:10 special_data:5|#660000 offset:0.7 at:<[spawn_at].above> targets:<server.online_players>
      - wait 2t
    - spawn test_spawn_blood_radier <[spawn_at]> target:<[target_player]> save:ent
    - flag server test_spawn_blood_raiders:->:<entry[ent].spawned_entity>
    - adjust <entry[ent].spawned_entity> "custom_name:<entry[ent].spawned_entity.script.parsed_key[mechanisms.custom_name]>"

test_spawn_blood_raiders_task2:
  type: task
  debug: false
  definitions: location|target_player
  script:
    - define spawn_at <[location].sub[<[location].sub[<[target_player].location>].mul[0.8]>].highest.above>
    - define locations <proc[define_curve1].context[<[location]>|<[spawn_at]>|<util.random.int[5].to[15]>|<util.random.int[45].to[180]>|1]>
    - foreach <[locations]>:
      - playeffect effect:redstone quantity:10 special_data:5|#660000 offset:0.2 at:<[value]> targets:<server.online_players>
      - wait 2t
    - repeat 5:
      - playeffect effect:redstone quantity:10 special_data:5|#660000 offset:0.7 at:<[spawn_at].above> targets:<server.online_players>
      - wait 2t
    - mount test_spawn_blood_radier2|test_spawn_blood_raider2_horse <[spawn_at]> save:ent
    - attack <entry[ent].mounted_entities> target:<[target_player]>
    - flag server test_spawn_blood_raiders:|:<entry[ent].mounted_entities>
    - run test_spawn_blood_raider_particles
    - adjust <entry[ent].spawned_entity> "custom_name:<entry[ent].spawned_entity.script.parsed_key[mechanisms.custom_name]>"

test_spawn_blood_raiders_task3:
  type: task
  debug: false
  definitions: location|target_player
  script:
    - define spawn_at <[location].sub[<[location].sub[<[target_player].location>].mul[0.75]>].highest.above>
    - define locations <proc[define_curve1].context[<[location]>|<[spawn_at]>|5|90|1]>
    - foreach <[locations]>:
      - playeffect effect:redstone quantity:10 special_data:5|#660000 offset:0.7 at:<[value]> targets:<server.online_players>
      - wait 2t
    - repeat 5:
      - playeffect effect:redstone quantity:10 special_data:5|#660000 offset:0.7 at:<[spawn_at].above> targets:<server.online_players>
      - wait 2t
    - spawn test_spawn_blood_radier3 <[spawn_at]> target:<[target_player]> save:ent
    - flag server test_spawn_blood_raiders:->:<entry[ent].spawned_entity>
    - run test_spawn_blood_raider_particles
    - adjust <entry[ent].spawned_entity> "custom_name:<entry[ent].spawned_entity.script.parsed_key[mechanisms.custom_name]> <entry[ent].spawned_entity.health_data>"

test_spawn_blood_raider_particles:
  type: task
  debug: false
  script:
    - waituntil <server.has_flag[test_spawn_blood_raiders]> rate:1s
    - while <server.has_flag[test_spawn_blood_raiders]>:
      - foreach <server.flag[test_spawn_blood_raiders]>:
        - foreach next if:<[value].is_spawned.not>
        - playeffect at:<[value].location.above> effect:redstone quantity:10 special_data:1|#660000 offset:0.7 targets:<server.online_players>
        - wait 1t

test_spawn_blood_radier:
  type: entity
  debug: false
  entity_type: creeper
  mechanisms:
    health_data: 100/100
    custom_name: <&c>Blood Creeper
    custom_name_visible: true
  flags:
    on_death: test_spawn_blood_raider_remove
    on_explode: test_spawn_blood_raider_remove

test_spawn_blood_radier2:
  type: entity
  debug: false
  entity_type: skeleton
  mechanisms:
    health_data: 250/250
    custom_name: <&c>Blood Skeleton
    custom_name_visible: true
  flags:
    on_death: test_spawn_blood_raider_remove

test_spawn_blood_radier2_horse:
  type: entity
  debug: false
  entity_type: skeleton_horse
  mechanisms:
    health_data: 100/100
  flags:
    on_death: test_spawn_blood_raider_remove

test_spawn_blood_radier3:
  type: entity
  debug: false
  entity_type: evoker
  mechanisms:
    health_data: 400/400
    custom_name: <&c>Evoker
    custom_name_visible: true
  flags:
    on_death: test_spawn_blood_raider_boss_death
    on_damaged: test_spawn_blood_raider_update_name

test_spawn_blood_raider_remove:
  type: task
  debug: false
  script:
    - flag server test_spawn_blood_raiders:<-:<context.entity>
    - if <context.entity.entity_type> == CREEPER:
      - determine passively <list[]>
    - if <server.flag[test_spawn_blood_raiders].is_empty>:
      - flag server test_spawn_blood_raiders:!

test_spawn_blood_raider_update_name:
  type: task
  debug: false
  script:
    - wait 1t
    - adjust <context.entity> "custom_name:<context.entity.script.parsed_key[mechanisms.custom_name]> <&7>(<&e><context.entity.health.round>/<context.entity.health_max><&7>)"

test_spawn_blood_raider_boss_death:
  type: task
  debug: false
  script:
    - announce "<&c>BOSS DEAD - SPAWN ENCHANTS (PLACEHOLDER)"