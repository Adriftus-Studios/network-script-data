custom_object_waystone_calipolis_admin:
  type: data
  item: waystone_admin
  entity: waystone_entity
  interaction: waystone_use
  place_checks_task: waystone_place_checks_admin
  after_place_task: waystone_after_place_admin
  remove_task: waystone_remove
  barrier_locations:
    - <[location]>
    - <[location].above>

custom_object_waystone_calipolis_player:
  type: data
  item: waystone_player
  entity: waystone_entity
  interaction: waystone_use
  place_checks_task: waystone_place_checks_player
  after_place_task: waystone_after_place_player
  remove_task: waystone_remove
  barrier_locations:
    - <[location]>
    - <[location].above>

waystone_entity:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    custom_name_visible: true
    visible: false
    gravity: false
    equipment:
      helmet: feather[custom_model_data=20]
  flags:
    on_entity_added: custom_object_update

waystone_admin:
  type: item
  debug: false
  material: feather
  display name: <&6>Server Waystone
  mechanisms:
    custom_model_data: 20
  flags:
    right_click_script: custom_object_place
    custom_object: waystone_calipolis_admin
    type: admin
    unique: <server.current_time_millis>

waystone_player:
  type: item
  debug: false
  material: feather
  display name: <&a>Player Waystone
  mechanisms:
    custom_model_data: 20
  flags:
    right_click_script: custom_object_place
    custom_object: waystone_calipolis_player
    type: player
    unique: <server.current_time_millis>

waystone_place_checks_admin:
  type: task
  debug: false
  script:
    - ratelimit <player> 1t
    - if !<player.has_permission[adriftus.waystone.admin]>:
      - narrate "<&c>You lack the permission to place an admin waystone."
      - stop

waystone_after_place_admin:
  type: task
  debug: false
  definitions: entity
  script:
    - flag server waystones.admin.<[entity].uuid>.location:<player.location.with_pose[0,<player.location.yaw.sub[180]>]>
    - flag server waystones.admin.<[entity].uuid>.name:<[entity].uuid>
    - flag <[entity]> type:admin

waystone_place_checks_player:
  type: task
  debug: false
  script:
    - ratelimit <player> 1t
    - if <player.flag[waystones].size> < 5:
      - narrate "<&c>You have too many Waystones."
      - stop

waystone_after_place_player:
  type: task
  debug: false
  definitions: entity
  script:
    - flag server waystones.player.<[entity].uuid>.location:<player.location.with_pose[0,<player.location.yaw.sub[180]>]>
    - flag server waystones.player.<[entity].uuid>.name:<[entity].uuid>
    - flag <[entity]> type:player

waystone_remove:
  type: task
  debug: false
  definitions: entity
  script:
    - define entity <context.item.flag[entity]> if:<[entity].exists.not>
    - choose <[entity].flag[type]>:
      - case admin:
        - flag server waystones.player.<[entity].uuid>:!
      - case player:
        - flag server waystones.admin.<[entity].uuid>:!
    - run custom_object_remove def:<[entity]>
    - inventory close

waystone_rename:
  type: task
  debug: false
  definitions: entity
  script:
    - flag player rename_waystone:<[entity]>
    - run anvil_gui_text_input def:Blep|waystone_rename_callback

waystone_rename_callback:
  type: task
  debug: false
  definitions: input
  script:
    - flag server waystones.<player.flag[rename_waystone].flag[type]>.<player.flag[rename_waystone].uuid>.name:<[input].parse_color>
    - adjust <player.flag[rename_waystone]> custom_name:<[input].parse_color>
    - flag player rename_waystone:!
    - narrate "<&a>Waystone Renamed!"

waystone_use:
  type: task
  debug: false
  script:
    - define type <context.location.flag[custom_object].flag[type]>
    # Left Click
    - if <context.click_type> == LEFT_CLICK_BLOCK:
      - if <[type]> == admin:
        - if <player.has_permission[adriftus.waystone.admin]>:
          - run waystone_rename def:<context.location.flag[custom_object]>
        - else:
          - run calipolis_warp_locations_open def:<[type]>
      - else:
        - if <context.entity.flag[owner]> == <player.uuid>:
          - run waystone_rename def:<context.location.flag[custom_object]>
        - else:
          - run calipolis_warp_locations_open def:<[type]>
    - else:
      - if <[type]> == admin:
        - if <player.is_sneaking> && <player.has_permission[adriftus.waystone.admin]>:
          - run waystone_remove def:<context.location.flag[custom_object]>
        - else:
          - run calipolis_warp_locations_open def:<[type]>
      - else:
        - if <player.is_sneaking> && <context.entity.flag[owner]> == <player.uuid>:
          - run waystone_remove def:<context.location.flag[custom_object]>
        - else:
          - run calipolis_warp_locations_open def:<[type]>