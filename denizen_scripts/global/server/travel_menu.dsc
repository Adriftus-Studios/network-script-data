travel_menu_open:
  type: task
  debug: false
  data:
    hub_slots:
      spawn: 20|21|22
      crates: 24|25|26
      towny: 29|30|31
      shops: 33|34|35
      mail_run: 48
      fishing: 50
    inactive_slots:
      - 31
      - 32
      - 33
    title_data:
      hub:
       active: <&chr[1002]>
       inactive: <&chr[1001]>
      herocraft:
       active: <&chr[1003]>
       inactive: <&chr[1004]>
      calipolis:
       active: <&chr[1998]>
       inactive: <&chr[1999]>
      build:
       active: <&chr[1001]>
       inactive: <&chr[1001]>
      test:
       active: <&chr[1001]>
       inactive: <&chr[1001]>
  definitions: tab
  script:
    - define tab <bungee.server> if:<[tab].exists.not>
    - define inventory <inventory[travel_menu_inventory]>
    - foreach <yaml[bungee_config].list_keys[servers]> as:server:
      - if !<yaml[bungee_config].contains[servers.<[server]>.show_in_play_menu]> || !<yaml[bungee_config].read[servers.<[server]>.show_in_play_menu]>:
        - foreach next
      - if <yaml[bungee_config].read[servers.<[server]>.restricted]||true> && !<player.has_permission[bungeecord.server.<[server]>]>:
        - foreach next
      - define display <yaml[bungee_config].parsed_key[servers.<[server]>.display_name]>
      - define lore <yaml[bungee_config].parsed_key[servers.<[server]>.description]>
      - define item <item[<yaml[bungee_config].read[servers.<[server]>.material]>]>
      - define slot <yaml[bungee_config].read[servers.<[server]>.travel_menu_slot]>
      - inventory set slot:<[slot]> o:<[item].with[hides=all;display=<[display]>;lore=<[lore]>;flag=run_script:travel_menu_open_tab;flag=server:<[server]>;flag=slot:<[slot]>]> d:<[inventory]>
    # Active Server Tab, or not
    - if <[tab]> == <bungee.server>:
      - define type active
    - else:
      - define type inactive
    # Inventory title Overlays
    - adjust <[inventory]> title:<&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[1001]><&chr[F703]><script.parsed_key[data.title_data.<[tab]>.<[type]>]>
    # If inactive, build "travel to server" buttons
    - if <[type]> == inactive:
      - foreach <script.data_key[data.inactive_slots]>:
        - inventory set slot:<[value]> "o:feather[custom_model_data=3;display=<&a>Travel To Server;flag=run_script:travel_menu_to_server;flag=server:<[tab]>]" d:<[inventory]>
    - else:
      - choose <[tab]>:
        # HeroCraft tab
        - case herocraft:
          - narrate test
        # Calipolis tab
        - case calipolis:
          - narrate test
        # Hub tab
        - case hub:
          - narrate test
        # test tab
        - case test:
          - narrate test
        # build tab
        - case build:
          - narrate test
    - inventory open d:<[inventory]>

travel_menu_to_world:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - teleport <player> <context.item.flag[world].spawn_location>

travel_menu_open_tab:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - ratelimit <player> 10t
    - run travel_menu_open def:<context.item.flag[server]>

travel_menu_to_server:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - adjust <player> send_to:<context.item.flag[server]>

travel_menu_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: <&a>Travel!
  gui: true
  size: 54

hub_warp:
  type: task
  debug: false
  script:
    - define warpName <context.item.flag[warp_id]>
    - teleport <player> hub_warp_<[warpName]>
    - playsound <player> sound:ENTITY_ENDERMAN_TELEPORT
    - playeffect effect:PORTAL at:<player.location> visibility:500 quantity:500 offset:1.0
    - actionbar "<proc[reverse_color_gradient].context[Teleporting to <[warpName].replace[_].with[ ].to_titlecase>|#6DD5FA|#FFFFFF]>"
