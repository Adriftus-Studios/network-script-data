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
    - foreach <player.flag[homes].if_null[<list>].pad_right[<player.flag[homes_unlocked].if_null[1]>].with[new].pad_right[5].with[locked]> as:id:
      - if <[id]> == new:
        - inventory set slot:<[slots].get[<[loop_index]>]> o:calipolis_home_new d:<[inventory]>
      - else if <[id]> == locked:
        - inventory set slot:<[slots].get[<[loop_index]>]> o:calipolis_home_locked d:<[inventory]>
      - else:
        - define lore "<&e><player.flag[homes_data.<[id]>.lore].include[<&6>Left<&co> <&e>Teleport|<&6>Right<&e> <&e>Delete]>"
        - inventory set slot:<[slots].get[<[loop_index]>]> o:feather[custom_model_data=800;display=<&a>Home<&co><&sp><&r><player.flag[homes_data.<[id]>.display]>;lore=<[lore]>;flag=run_script:calipolis_handle_home_button;flag=home_id:<[id]>] d:<[inventory]>

    - inventory set slot:<script.data_key[data.back_button]> o:calipolis_lore_locations_back_button d:<[inventory]>

    - inventory open d:<[inventory]>

calipolis_home_new:
  type: item
  debug: false
  material: feather
  display name: <&a>New Home
  lore:
    - <&6>Left<&co> <&e>Set new home
  mechanisms:
    custom_model_data: 801
  flags:
    run_script: calipolis_set_home

calipolis_home_locked:
  type: item
  debug: false
  material: feather
  display name: <&c>Locked<&sp>Home
  lore:
    - <&c>No Actions
  mechanisms:
    custom_model_data: 802

calipolis_handle_home_button:
  type: task
  debug: false
  script:
    - choose <context.click>:
      - case LEFT:
        - run teleportation_animation_run def:<player.flag[homes_data.<context.item.flag[home_id]>.location]>
      - case RIGHT:
        - run home_delete def:<context.item>

home_delete:
  type: task
  debug: false
  definitions: display_item
  script:
    - if <player.has_flag[delete_home]> && <player.flag[delete_home]> == <[display_item].flag[home_id]>:
      - narrate "<&c>Deleted Home<&co> <&e><[display_item].flag[display]>"
      - flag player homes_data.<[display_item].flag[home_id]>:!
      - run home_system_open
    - else:
      - ratelimit <player> 5s
      - narrate "<&c>Deleting Home<&co> <&e><[display_item].flag[display]>"
      - narrate "<&e>Wait 5 seconds and right click again to delete"
      - wait 99t
      - flag player delete_home:<[display_item].flag[home_id]> expire:10s
      

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
    - define uuid <util.random.uuid>
    - flag player homes_data.<[uuid]>.display:<[input]>
    - flag player homes_data.<[uuid]>.lore:<player.location.simple>
    - flag player homes_data.<[uuid]>.location:<player.location>
    - narrate "<&e>You have saved this location as home<&co> <&a><[input]>"

home_system_inventory:
  type: inventory
  debug: false
  inventory: chest
  gui: true
  title: <&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[2202]>
  size: 27