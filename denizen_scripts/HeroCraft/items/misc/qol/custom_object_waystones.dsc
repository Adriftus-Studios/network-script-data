custom_object_waystone_town:
  type: data
  item: waystone_town
  entity: waystone_entity
  interaction: waystone_use
  place_checks_task: waystone_place_town_checks
  after_place_task: waystone_after_place_town
  remove_task: waystone_remove
  barrier_locations:
    - <[location]>
    - <[location].above>

custom_object_waystone_server:
  type: data
  item: waystone_server
  entity: waystone_entity
  interaction: waystone_use
  place_checks_task: waystone_place_server_checks
  after_place_task: waystone_after_place_server
  remove_task: waystone_remove
  barrier_locations:
    - <[location]>
    - <[location].above>

custom_object_waystone_wild:
  type: data
  item: waystone_wild
  entity: waystone_entity
  interaction: waystone_use
  place_checks_task: waystone_place_wild_checks
  after_place_task: waystone_after_place_wild
  remove_task: waystone_remove
  barrier_locations:
    - <[location]>
    - <[location].above>

waystone_town:
  type: item
  debug: false
  material: feather
  display name: <&e>Town Waystone
  data:
    recipe_book_category: travel.waystone
  mechanisms:
    custom_model_data: 20
  flags:
    right_click_script: custom_object_place
    custom_object: waystone_town
    type: town
    unique: <server.current_time_millis>
  recipes:
    1:
      type: shaped
      input:
      - waystone_pillar|nether_star|waystone_pillar
      - waystone_pillar|ender_eye|waystone_pillar
      - quadruple_compressed_stone|quadruple_compressed_stone|quadruple_compressed_stone

waystone_pillar:
  type: item
  debug: false
  material: stone
  display name: <&6>Waystone Pillar
  data:
    recipe_book_category: misc
  lore:
    - <&6>Crafting Ingredient
    - <&a>Used for Waystones
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - magical_pylon|glow_ink_sac|magical_pylon
      - magical_pylon|ender_pearl|magical_pylon
      - magical_pylon|glow_ink_sac|magical_pylon

waystone_wild:
  type: item
  debug: false
  material: feather
  display name: <&a>Wild Waystone
  mechanisms:
    custom_model_data: 20
  flags:
    right_click_script: custom_object_place
    custom_object: waystone_wild
    type: wild
    unique: <server.current_time_millis>

waystone_server:
  type: item
  debug: false
  material: feather
  display name: <&6>Server Waystone
  mechanisms:
    custom_model_data: 20
  flags:
    right_click_script: custom_object_place
    custom_object: waystone_server
    type: server
    unique: <server.current_time_millis>

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

waystone_place_wild_checks:
  type: task
  debug: false
  script:
    - ratelimit <player> 1t
    - if !<player.has_permission[adriftus.waystone.wild.place]>:
      - narrate "<&c>You lack the permission to place a wild waystone."
      - stop

waystone_after_place_wild:
  type: task
  debug: false
  definitions: entity
  script:
    - flag server waystones.wild.<[entity].uuid>.location:<player.location.with_pose[0,<player.location.yaw.sub[180]>]>
    - flag server waystones.wild.<[entity].uuid>.name:<[entity].uuid>
    - flag <[entity]> type:wild

waystone_place_server_checks:
  type: task
  debug: false
  script:
    - ratelimit <player> 1t
    - if !<player.has_permission[adriftus.waystone.server.place]>:
      - narrate "<&c>You lack the permission to place a server waystone."
      - stop

waystone_after_place_server:
  type: task
  debug: false
  definitions: entity
  script:
    - flag server waystones.server.<[entity].uuid>.location:<player.location.with_pose[0,<player.location.yaw.sub[180]>]>
    - flag server waystones.server.<[entity].uuid>.name:<[entity].uuid>
    - flag <[entity]> type:server

waystone_place_town_checks:
  type: task
  debug: false
  script:
    - ratelimit <player> 1t
    - if !<[location].town.exists>:
      - narrate "<&c>Waystones must be placed in a town."
      - stop
    - if <player> != <[location].town.mayor>:
      - narrate "<&c>Waystones must be placed by the Mayor."
      - stop
    - if <[location].town.has_flag[waystone]>:
      - narrate "<&c>You can only have one waystone in your Town"
      - stop

waystone_after_place_town:
  type: task
  debug: false
  definitions: entity
  script:
    - define town <[location].town>
    - flag <[town]> waystone.entity:<[entity]>
    - flag <[town]> waystone.location:<[entity].location.simple>
    - flag <[town]> waystone.tp_location:<player.location.with_pose[0,<player.location.yaw.sub[180]>]>
    - flag <[entity]> town:<context.location.town>
    - flag <[entity]> type:town
    - adjust <[entity]> "custom_name:<[location].town.name> Waystone"

waystone_use:
  type: task
  debug: false
  definitions: entity
  script:
    - determine passively cancelled
    - define entity <context.location.flag[custom_object]> if:<[entity].exists.not>
    - choose <[entity].flag[type]>:
      - case town:
        - if <player.has_flag[waystones.town.<[entity].flag[town]>]>:
          - inject waystone_open_teleport_main_menu
        - else:
          - run totem_test def:2
          - title "title:<&a>Waystone Unlocked!" fade_in:1s stay:1s fade_out:1s
          - flag <player> waystones.town.<[entity].flag[town]>
      - case server:
        - inject waystone_open_teleport_main_menu
      - case wild:
        - if <player.has_flag[waystones.wild.<[entity].uuid>]>:
          - inject waystone_open_teleport_main_menu
        - else:
          - run totem_test def:2
          - title "title:<&a>Waystone Unlocked!" fade_in:1s stay:1s fade_out:1s
          - flag <player> waystones.wild.<[entity].uuid>
          - flag <[entity]> unlocked_players:->:<player>

waystone_remove:
  type: task
  debug: false
  script:
    - define entity <context.item.flag[entity]>
    - choose <context.item.flag[type]>:
      - case town:
        - define town <context.item.flag[town]>
        - flag <[town]> waystone:!
      - case server:
        - flag server waystones.server.<[entity].uuid>:!
      - case wild:
        - foreach <[entity].flag[unlocked_players]>:
          - flag <[value]> waystones.wild.<[entity].uuid>:!
        - flag server waystones.wild.<[entity].uuid>:!
    - run custom_object_remove def:<[entity]>
    - inventory close

waystone_gui_item:
  type: item
  material: feather
  display name: <&c>PLACEHOLDER
  mechanisms:
    custom_model_data: 20
  flags:
    run_script: waystone_teleport

waystone_submenu_item:
  type: item
  material: feather
  display name: <&c>PLACEHOLDER
  mechanisms:
    custom_model_data: 3
  flags:
    run_script: waystone_open_teleport_submenu

waystone_teleport:
  type: task
  debug: false
  script:
    - run teleportation_animation_run def:<context.item.flag[location]>

waystone_open_teleport_submenu:
  type: task
  debug: false
  script:
    - inject waystone_open_teleport_<context.item.flag[type]>_menu

waystone_teleport_menu:
  type: inventory
  inventory: chest
  size: 45
  title: <&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[1005]>
  gui: true
  data:
    slots:
      server: 13|14|15
      town: 22|23|24
      wild: 31|32|33
    rename: 38
    remove: 39

waystone_server_teleport_menu:
  type: inventory
  inventory: chest
  size: 45
  title: <&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[1006]>
  gui: true
  data:
    slots: 11|12|13|14|15|16|17|20|21|22|23|24|25|26|29|30|31|32|33|34|35
    back: 37

waystone_wild_teleport_menu:
  type: inventory
  inventory: chest
  size: 45
  title: <&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[1008]>
  gui: true
  data:
    slots: 11|12|13|14|15|16|17|20|21|22|23|24|25|26|29|30|31|32|33|34|35
    back: 37

waystone_town_teleport_menu:
  type: inventory
  inventory: chest
  size: 45
  title: <&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[1007]>
  gui: true
  data:
    slots: 11|12|13|14|15|16|17|20|21|22|23|24|25|26|29|30|31|32|33|34|35
    back: 37

waystone_back_to_main:
  type: item
  material: feather
  display name: <&c>Back
  flags:
    run_script: waystone_open_teleport_main_menu
  mechanisms:
    custom_model_data: 3

waystone_remove_item:
  type: item
  material: paper
  display name: <&c>Remove Waystone
  flags:
    run_script: waystone_remove
  mechanisms:
    custom_model_data: 206

waystone_rename_item:
  type: item
  material: paper
  display name: <&b>Rename Waystone
  flags:
    run_script: waystone_rename
  mechanisms:
    custom_model_data: 205

waystone_open_teleport_town_menu:
  type: task
  debug: false
  script:
    - define inventory <inventory[waystone_town_teleport_menu]>
    - define slots <list[<[inventory].script.data_key[data.slots]>]>
    - foreach <player.flag[waystones.town].if_null[<list>]> key:town as:value:
      - define town <town[<[town]>].if_null[null]>
      - if <[loop_index].mod[45]> == 0:
        - foreach stop
      - if <[town]> == null:
        - flag <player> waystones.town.<[town]>:!
        - foreach next
      - if <[town].outlaws.contains[<player>]>:
        - foreach next
      - if !<[town].has_flag[waystone.location]>:
        - foreach next
      - inventory set slot:<[slots].get[<[loop_index]>]> o:waystone_gui_item[flag=location:<[town].flag[waystone.tp_location]>;display=<[town].name>] d:<[inventory]>
    - inventory set slot:<[inventory].script.data_key[data.back]> o:waystone_back_to_main[flag=entity:<context.item.flag[entity]>] d:<[inventory]>
    - inventory open d:<[inventory]>

waystone_open_teleport_server_menu:
  type: task
  debug: false
  script:
    - define inventory <inventory[waystone_server_teleport_menu]>
    - define slots <list[<[inventory].script.data_key[data.slots]>]>
    - foreach <server.flag[waystones.server].if_null[<list>]> as:data_map:
      - inventory set slot:<[slots].get[<[loop_index]>]> o:waystone_gui_item[flag=location:<[data_map].get[location]>;display=<[data_map].get[name]>] d:<[inventory]>
    - inventory set slot:<[inventory].script.data_key[data.back]> o:waystone_back_to_main[flag=entity:<context.item.flag[entity]>] d:<[inventory]>
    - inventory open d:<[inventory]>

waystone_open_teleport_wild_menu:
  type: task
  debug: false
  script:
    - define inventory <inventory[waystone_wild_teleport_menu]>
    - define slots <list[<[inventory].script.data_key[data.slots]>]>
    - foreach <player.flag[waystones.wild].if_null[<list>].keys.if_null[<list>]> as:waystone_uuid:
      - define data_map <server.flag[waystones.wild.<[waystone_uuid]>]>
      - inventory set slot:<[slots].get[<[loop_index]>]> o:waystone_gui_item[flag=location:<[data_map].get[location]>;display=<[data_map].get[name]>] d:<[inventory]>
    - inventory set slot:<[inventory].script.data_key[data.back]> o:waystone_back_to_main[flag=entity:<context.item.flag[entity]>] d:<[inventory]>
    - inventory open d:<[inventory]>

waystone_open_teleport_main_menu:
  type: task
  debug: false
  definitions: entity
  script:
    - define entity <context.location.flag[entity].if_null[null]> if:<[entity].exists.not>
    - define entity <context.item.flag[entity]> if:<[entity].equals[null]>
    - if <[entity].flag[type]> == town && <[entity].flag[town].outlaws.contains[<player>]>:
      - narrate "<&c>You are outlawed in this Town."
      - stop
    - define inventory <inventory[waystone_teleport_menu]>
    - adjust <[inventory]> title:<&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[1005]>
    - foreach <[inventory].script.data_key[data.slots]> key:type as:slots:
      - define color_code <list[<&b>|<&e>|<&a>].get[<[loop_index]>]>
      - foreach <[slots]> as:slot:
        - inventory set slot:<[slot]> o:waystone_submenu_item[display=<[color_code]><[type].to_titlecase>;flag=type:<[type]>;flag=entity:<[entity]>] d:<[inventory]>
    #- give waystone_submenu_item[display=Towns;flag=type:town] to:<[inventory]>
    #- give waystone_submenu_item[display=Server;flag=type:server] to:<[inventory]>
    #- give waystone_submenu_item[display=Wild;flag=type:wild] to:<[inventory]>
    # Remove Waystone Button
    - if <[entity].flag[type]> == town && <player> == <[entity].flag[town].mayor>:
      - inventory set slot:<[inventory].script.data_key[data.remove]> o:waystone_remove_item[flag=type:<[entity].flag[type]>;flag=town:<[entity].flag[town]>;flag=entity:<[entity]>] d:<[inventory]>
    - else if <player.has_permission[adriftus.waystone.<[entity].flag[type]>.remove]>:
      - inventory set slot:<[inventory].script.data_key[data.remove]> o:waystone_remove_item[flag=type:<[entity].flag[type]>;flag=entity:<[entity]>] d:<[inventory]>
    # Rename Waystone Button
    - if <[entity].flag[type]> != town && <player.has_permission[adriftus.waystone.<[entity].flag[type]>.rename]>:
      - inventory set slot:<[inventory].script.data_key[data.rename]> o:waystone_rename_item[flag=type:<[entity].flag[type]>;flag=entity:<[entity]>] d:<[inventory]>

    - inventory open d:<[inventory]>

waystone_rename:
  type: task
  debug: false
  script:
    - flag player waystone_rename:<context.item.flag[entity]>
    - run anvil_gui_text_input "def:<&a>Rename Waystone|waystone_rename_callback"

waystone_rename_callback:
  type: task
  debug: false
  definitions: text_input
  script:
    - adjust <player.flag[waystone_rename]> custom_name:<[text_input].parse_color>
    - flag server waystones.<player.flag[waystone_rename].flag[type]>.<player.flag[waystone_rename].uuid>.name:<[text_input].parse_color>
    - flag player waystone_rename:!

# waystone_command:
#   type: command
#   debug: false
#   name: waystone
#   description: Opens a waystone menu.
#   usage: /waystone
#   permission: adriftus.command.waystone
#   permission message: Sorry, <player.name>, you can't use this command.
#   tab completions:
#     1: <tern[<player.has_permission[adriftus.command.waystone.other]>].pass[<server.online_players.parse[name]>].fail[<list>]>
#   script:
#   - run waystone_open_main_menu def:<server.match_player[<context.args.get[1]>].if_null[<player>]>

waystone_open_main_menu:
  type: task
  debug: false
  definitions: player
  script:
    - adjust <queue> linked_player:<[player].if_null[<player>]>
    - define inventory <inventory[waystone_teleport_menu]>
    - adjust <[inventory]> title:<&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[1005]>
    - foreach <[inventory].script.data_key[data.slots]> key:type as:slots:
      - define color_code <list[<&b>|<&e>|<&a>].get[<[loop_index]>]>
      - foreach <[slots]> as:slot:
        - inventory set slot:<[slot]> o:waystone_submenu_item[display=<[color_code]><[type].to_titlecase>;flag=type:<[type]>;flag=entity:<[entity]>] d:<[inventory]>
    - inventory open d:<[inventory]>

waystone_portable_item:
  type: item
  material: slime_ball
  display name: Porta-Waystone
  flags:
    left_click_script:
    - waystone_open_main_menu