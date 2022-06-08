# -- /report - Player Reporter
mod_report_command:
  type: command
  debug: false
  name: report
  description: Adriftus Player Report
  usage: /report (username)
  tab complete:
    # -- One Argument Tab Complete
    - define blacklist <player||null>
    - inject online_player_tabcomplete
  script:
    # -- Hopefully this logic will work & make sense in a few weeks.
    - if <context.args.is_empty>:
      - inject mod_report_online_inv_open
    - else if <server.match_offline_player[<context.args.first>]||null> != null:
      - if <server.match_offline_player[<context.args.first>]> == <player>:
        - narrate "<&c>You cannot perform actions on yourself."
        - stop
      - else:
        - narrate <server.match_offline_player[<context.args.first>]>
        # - run mod_report_inv_open def:<server.match_offline_player[<context.args.first>]>
    - else:
      - narrate "<&c>Invalid player name entered!"

# -- ONLINE PLAYERS PANEL --
mod_report_online_inv:
  type: inventory
  debug: false
  title: <&6>Adriftus <&f>- <&a>Report a Player
  inventory: CHEST
  gui: true
  size: 54
  definitions:
    x: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    previous: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    next: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    close: <item[red_stained_glass_pane].with[display_name=<&c><&l>χ<&sp>Close].with_flag[to:close]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [close] [x] [x] [x] [x] [x] [x] [previous] [next]

mod_report_online_inv_events:
  type: world
  debug: false
  events:
    on player clicks player_head in mod_report_online_inv:
      - if <server.match_player[<context.item.display.strip_color>]> == <player>:
        - narrate "<&c>You cannot report yourself."
        - stop
      - define target <server.match_player[<context.item.display.strip_color>]>
      - narrate <[target]>

mod_report_online_inv_open:
  type: task
  debug: false
  definitions: page
  data:
    slot_data:
      slots_used: <util.list_numbers_to[45]>
      close: 46
      page: 50
      previous_page: 53
      next_page: 54
  script:
    # Pagination
    - define page 1 if:<[page].exists.not>
    - define slots <list[<script.parsed_key[data.slot_data.slots_used]>]>
    - define start <[page].sub[1].mul[<[slots].size>].add[1]>
    - define end <[slots].size.mul[<[page]>]>
    - define players <server.online_players>

    # Define inventory
    - define inventory <inventory[mod_report_online_inv]>
    # Add items according to page number.
    - if <[players].size> > 0:
      - foreach <[players].get[<[start]>].to[<[end]>]> as:player:
        # Match item display name and lore to information about the online player.
        # Build the final item.
        - define item <item[player_head].with[display_name=<&a><[player].name>;skull_skin=<[player].name>]>
        # Set the defined item an inventory slot.
        - inventory set o:<[item]> slot:<[slots].get[<[loop_index]>]> d:<[inventory]>
    # Pagination Item
    - inventory set slot:<script.data_key[data.slot_data.page]> o:<item[feather].with[display_name=<&sp>;custom_model_data=3;flag=page:<[page]>]> d:<[inventory]>
    # Previous Page Button
    - if <[page]> != 1:
      - inventory set slot:<script.data_key[data.slot_data.previous_page]> o:<item[leather_horse_armor].with[hides=all;display_name=<&a>Previous<&sp>Page;flag=run_script:mod_report_online_inv_previous_page;color=green;custom_model_data=6]> d:<[inventory]>
    # Next Page Button
    - if <[players].size> > <[end]>:
      - inventory set slot:<script.data_key[data.slot_data.next_page]> o:<item[leather_horse_armor].with[hides=all;display_name=<&a>Next<&sp>Page;flag=run_script:mod_report_online_inv_next_page;color=green;custom_model_data=7]> d:<[inventory]>
    # Open inventory
    - inventory open d:<[inventory]>

mod_report_online_inv_previous_page:
  type: task
  debug: false
  script:
    - define page_item <context.inventory.slot[<script[mod_report_online_inv_open].data_key[data.slot_data.page]>]>
    - run mod_report_online_inv_open def:<[page_item].flag[page].sub[1]>

mod_report_online_inv_next_page:
  type: task
  debug: false
  script:
    - define page_item <context.inventory.slot[<script[mod_report_online_inv_open].data_key[data.slot_data.page]>]>
    - run mod_report_online_inv_open def:<[page_item].flag[page].add[1]>


# -- ONLINE PLAYERS PANEL --
mod_report_inv:
  type: inventory
  debug: false
  title: <&6>Adriftus <&f>- <&a>Report a Player
  inventory: CHEST
  gui: true
  size: 54
  definitions:
    x: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    close: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Player<&sp>list].with_flag[to:report]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [back] [x] [x] [x] [x] [x] [x] [x] [x]
  
