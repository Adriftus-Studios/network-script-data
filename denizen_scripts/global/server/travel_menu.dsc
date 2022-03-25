travel_menu_open:
  type: task
  debug: false
  data:
    server_slots_by_count:
      1: 32
      2: 30|32
      3: 29|32|35
      4: 31|33|39|43
      5: 30|32|34|40|42
      6: 29|31|33|35|39|43
      7: 29|39|31|41|33|43|35
      8: 20|22|24|26|38|40|42|44
    network_slots_by_count:
      1: 5
      2: 4|6
      3: 3|5|7
      4: 2|4|6|8
      5: 1|3|5|7|9
    # NETWORK ITEMS
    #- [1] [2] [3] [4] [5] [6] [7] [8] [9]
    #- [10] [11] [12] [13] [14] [15] [16] [17] [18]

    # SERVER SLOTS
    #- [19] [20] [21] [22] [23] [24] [25] [26] [27]
    #- [28] [29] [30] [31] [32] [33] [34] [35] [36]
    #- [37] [38] [39] [40] [41] [42] [43] [44] [45]
    #- [46] [47] [48] [49] [50] [51] [52] [53] [54]
  # Theses are accessible anywhere in the network
  network:
    - foreach <yaml[bungee_config].list_keys[servers]> as:server:
      - if !<yaml[bungee_config].contains[servers.<[server]>.show_in_play_menu]> || !<yaml[bungee_config].read[servers.<[server]>.show_in_play_menu]>:
        - foreach next
      - if <yaml[bungee_config].read[servers.<[server]>.restricted]||true> && !<player.has_permission[bungee.server.<[server]>]>:
        - foreach next
      - define display <yaml[bungee_config].read[servers.<[server]>.display_name].parsed>
      - define lore <yaml[bungee_config].read[servers.<[server]>.description].parsed>
      - define item <item[<yaml[bungee_config].read[servers.<[server]>.material]>]>
      - define network_list:|:<[item].with[hides=all;display=<[display]>;lore=<[lore]>;flag=run_script:travel_menu_to_server;flag=server:<[server]>]>
  # These are specific to the test server
  test:
    - foreach <server.worlds> as:world:
      - define display "<&e>Teleport To <&b><[world].name.replace[_].with[<&sp>].to_titlecase>"
      - define server_list:|:<item[grass_block].with[hides=all;display=<[display]>;flag=run_script:travel_menu_to_world;flag=world:<[world]>]>
  # This task handles the final building of the inventory
  build_inventory:
    - define network_size <[network_list].size>
    - define server_size <[server_list].size>
    - define slots <list[<script.data_key[data.network_slots_by_count.<[network_size]>]>].include[<script.data_key[data.server_slots_by_count.<[server_size]>]>]>
    - define items <[network_list].include[<[server_list]>]>
    - define inventory <inventory[travel_menu_inventory]>
    - foreach <[slots]>:
      - inventory set slot:<[value]> o:<[items].get[<[loop_index]>]> d:<[inventory]>
  script:
    - define server_list <list>
    - inject locally path:network
    - if <script.data_key[<bungee.server>].exists>:
      - inject locally path:<bungee.server>
    - inject locally path:build_inventory
    - inventory open d:<[inventory]>

travel_menu_to_world:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - teleport <player> <context.item.flag[world].spawn_location>

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
  size: 54