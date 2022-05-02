actor_weapon_blood_raid_scythe:
  type: item
  material: stick
  display name: <&4>Blood Scythe
  mechanisms:
    custom_model_data: 666
  flags:
    right_click_script: actor_weapon_blood_raid_scythe_task

actor_weapon_blood_raid_scythe_task:
  type: task
  debug: false
  script:
    - define stage <player.location.town.flag[blood_raid.stage].if_null[null]>
    - if <[stage]> == null:
      - narrate "<&c>Use this inside the Town."
      - stop
    - choose <[stage]>:
      - case 4:
        - run blood_raid_sigil_overdrive def:<player.location.town>
      - case 5:
        - define target <player.target.if_null[null]>
        - if <[target]> == null || <[target].entity_type> != PLAYER:
          - stop
        - run actor_weapon_blood_raid_scythe_choke def:<[target]>

actor_weapon_blood_raid_scythe_choke:
  type: task
  debug: false
  definitions: target
  script:
    - define start <player.eye_location.with_yaw[<player.body_yaw>].below[0.4].right[0.18].forward[0.9]>
    - define location <[start]>
    - while <[target].is_online> && <[location].distance[<[target].eye_location>]> > 1.1:
      - playeffect at:<[location]> effect:redstone special_data:1|#990000 offset:0 quantity:20 targets:<server.online_players>
      - define location <[location].add[<[target].eye_location.sub[<[location]>].normalize>]>
      - wait 1t
    - flag <[target]> blood_choke:<player.location.town.flag[center].above[10].random_offset[5,0,5]>
    - if <[target].uuid> == 41ea066b-03e4-4274-8db7-10e0c2bcba82:
      - flag <player.location.town> blood_raid.stage:6
    - flag <player> on_stops_flying:actor_weapon_blood_raid_scythe_cancel_move
    - title title:<&color[#990000]><&font[adriftus:overlay]><&chr[0001]><&chr[F801]><&chr[0001]> fade_in:5s stay:120s fade_out:1s targets:<[target]>
    - adjust <[target]> <map[can_fly=true;fly_speed=0;flying=true;velocity=0,0.5,0;gravity=false]>
    - run actor_weapon_blood_raid_scythe_teleport def:<[target]>
    - while <[target].is_online> && <[target].has_flag[blood_choke]>:
      - playeffect at:<[target].eye_location.below[0.3].forward_flat[0.2]> effect:redstone special_data:1|#990000 offset:0.15,0,0.15 quantity:20 targets:<server.online_players>
      - wait 5t

actor_weapon_blood_raid_scythe_cancel_move:
  type: task
  debug: false
  script:
    - adjust <player> velocity:0,0,0
    - determine passively cancelled
    - wait 1t
    - teleport <player.flag[blood_choke]>

actor_weapon_blood_raid_scythe_teleport:
  type: task
  debug: false
  definitions: target
  script:
    - wait 3s
    - teleport <[target]> <[target].flag[blood_choke]>

actor_weapon_blood_raid_scythe_cancel_effect:
  type: task
  debug: false
  script:
    - adjust <player> <map[can_fly=false;fly_speed=0.2;flying=false;velocity=0,0,0;gravity=true]>
    - flag <player> blood_choke:!
    - flag player no_fall_damage_once