calipolis_warp_locations_admin:
  type: inventory
  debug: false
  inventory: chest
  title: <&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[2100]><&chr[F703]><&chr[2200]>
  gui: true
  size: 54

calipolis_warp_locations_player:
  type: inventory
  debug: false
  inventory: chest
  title: <&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[2100]><&chr[F703]><&chr[2201]>
  gui: true
  size: 54

calipolis_warp_locations_open:
  type: task
  debug: false
  definitions: type|page
  data:
    player_slots: 7|8|9
    admin_slots: 1|2|3
    warp_slots: 20|21|22|23|24|25|26|30|31|32|33|34|35
    back_button: 46
  script:
    - define type <context.item.flag[type]> if:<[type].exists.not>
    - define page 1 if:<[page].exists.not>
    - define inventory <inventory[calipolis_warp_locations_<[type]>]>
    - if <[type]> == admin:
      - foreach <script.data_key[data.player_slots]>:
        - inventory set slot:<[value]> o:calipolis_warp_open_player d:<[inventory]>
    - else:
      - foreach <script.data_key[data.admin_slots]>:
        - inventory set slot:<[value]> o:calipolis_warp_open_admin d:<[inventory]>

    - define slots <list[<script.data_key[data.warp_slots]>]>
    - define start <[page].sub[1].mul[<[slots].size>].add[1]>
    - define end <[slots].size.mul[<[page]>]>

    - foreach <server.flag[waystones.<[type]>].keys.get[<[start]>].to[<[end]>].if_null[<list>]> as:waystone_id:
      - define map <server.flag[waystones.<[type]>.<[waystone_id]>]>
      - inventory set slot:<[slots].get[<[loop_index]>]> o:waystone_gui_item[flag=location:<[map].get[location]>;display=<[map].get[name]>] d:<[inventory]>

    - inventory set slot:<script.data_key[data.back_button]> o:calipolis_lore_locations_back_button d:<[inventory]>

    - inventory open d:<[inventory]>

calipolis_warp_open_player:
  type: item
  debug: false
  material: feather
  display name: <&6>Unofficial Warps
  lore:
  - <&e>Player provided warps
  mechanisms:
    custom_model_data: 3
  flags:
    run_script: calipolis_warp_locations_open
    type: player

calipolis_warp_open_admin:
  type: item
  debug: false
  material: feather
  display name: <&a>Official Warps
  lore:
  - <&e>Server provided warps
  mechanisms:
    custom_model_data: 3
  flags:
    run_script: calipolis_warp_locations_open
    type: admin

waystone_gui_item:
  type: item
  material: feather
  display name: <&c>PLACEHOLDER
  mechanisms:
    custom_model_data: 20
  flags:
    run_script: waystone_teleport

waystone_teleport:
  type: task
  debug: false
  script:
    - run teleportation_animation_run def:<context.item.flag[location]>
