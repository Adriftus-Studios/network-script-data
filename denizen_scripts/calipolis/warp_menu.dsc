calipolis_warp_locations_admin:
  type: inventory
  debug: false
  inventory: chest
  title: <&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[2200]>
  size: 54

calipolis_warp_locations_player:
  type: inventory
  debug: false
  inventory: chest
  title: <&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[2201]>
  size: 54

calipolis_warp_locations_open:
  type: task
  debug: false
  definitions: type|page
  data:
    player_slots: 7|8
    admin_slots: 2|3
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
    
    - inventory set slot:<script.data_key[data.back_button]> o:calipolis_lore_locations_back_button d:<[inventory]>

    - inventory open d:<[inventory]>

calipolis_warp_open_player:
  type: item
  debug: false
  material: feather
  display name: <&e>Player Warps
  mechanisms:
    custom_model_data: 3
  flags:
    run_script: calipolis_warp_locations_open
    type: player

calipolis_warp_open_player:
  type: item
  debug: false
  material: feather
  display name: <&6>Server Warps
  mechanisms:
    custom_model_data: 3
  flags:
    run_script: calipolis_warp_locations_open
    type: admin