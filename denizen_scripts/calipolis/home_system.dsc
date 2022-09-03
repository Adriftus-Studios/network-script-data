home_system_open:
  type: task
  debug: false
  data:
    home_slots:
    - 12
    - 13
    - 14
    - 15
    - 16
    back_button: 19
  script:
    - define inventory <inventory[home_system_inventory]>
    - define slots <script.data_key[data.home_slots]>
    - foreach <player.flag[homes].if_null[<list>].pad_right[<player.flag[homes_unlocked]>].with[new].pad_right[5].with[locked]> as:name:
      - if <[name]> == new:
        - inventory set slot:<[slots].get[<[loop_index]>]> o:feather[custom_model_data=801;display=<&a>New<&sp>Home;flag=run_script:calipolis_set_home] d:<[inventory]>
      - else if <[name]> == locked:
        - inventory set slot:<[slots].get[<[loop_index]>]> o:feather[custom_model_data=802;display=<&c>Locked<&sp>Home;flag=run_script:cancel] d:<[inventory]>
      - else:
        - inventory set slot:<[slots].get[<[loop_index]>]> o:feather[custom_model_data=800;display=<&a>Home<&co><&sp><&r><[name]>;lore=<&e><player.flag[homes_data.<[name]>.location].simple>;flag=run_script:calipolis_teleport_to_home;flag=home_id:<[name]>] d:<[inventory]>

    - inventory set slot:<script.data_key[data.back_button]> o:calipolis_lore_locations_back_button d:<[inventory]>

    - inventory open d:<[inventory]>

calipolis_teleport_to_home:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - run teleportation_animation_run def:<player.flag[homes_data.<context.item.flag[home_id]>.location]>

calipolis_set_home:
  type: task
  debug: false
  script:
    - run anvil_gui_text_input "def:<&e>Name Your Home!|calipolis_set_home_callback"

calipolis_set_home_callback:
  type: task
  debug: false
  definitions: input
  script:
    - flag player homes:->:<[input]>
    - flag player homes_data.<[input]>.display:<[input]>
    - flag player homes_data.<[input]>.lore:<player.location.simple>
    - flag player homes_data.<[input]>.location:<player.location>
    - narrate "<&e>You have saved this location as home<&co> <&a><[input]>"

home_system_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: <&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[2202]>
  size: 27