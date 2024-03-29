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
        - narrate "<&c>You cannot report yourself."
        - stop
      - else if <player.has_flag[report]>:
        - narrate "<&c>You have recently reported a player within the last five minutes."
        - stop
      - else if <player.has_flag[reported.<server.match_offline_player[<context.args.first>].uuid>]>:
        - narrate "<&c>You have already reported <server.match_offline_player[<context.args.first>].name>. Our team will address your issue as soon as possible."
        - stop
      - else:
        - run mod_report_inv_open def:<server.match_offline_player[<context.args.first>]>
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
    close: <item[red_stained_glass_pane].with[display_name=<&c><&l>χ<&sp>Close].with_flag[to:close]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [close] [] [] [] [] [] [] [] []

mod_report_online_inv_events:
  type: world
  debug: false
  events:
    on player clicks player_head in mod_report_online_inv:
      - if <server.match_player[<context.item.display.strip_color>]> == <player>:
        - narrate "<&c>You cannot report yourself."
        - stop
      # Player has recently reported a player
      - else if <player.has_flag[report]>:
        - narrate "<&c>You have recently reported a player within the last five minutes."
        - stop
      - else if <player.has_flag[reported.<server.match_player[<context.item.display.strip_color>].uuid>]>:
        - narrate "<&c>You have already reported <server.match_player[<context.item.display.strip_color>].name>. Our team will address your issue as soon as possible."
        - stop
      - run mod_report_inv_open def:<server.match_player[<context.item.display.strip_color>]>

mod_report_online_inv_open:
  type: task
  debug: false
  definitions: page
  data:
    slot_data:
      slots_used: <util.list_numbers_to[45]>
      close: 46
      page: 46
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
    - inventory set slot:<script.data_key[data.slot_data.page]> o:<item[red_stained_glass_pane].with[display_name=<&c><&l>χ<&sp>Close;flag=to:close;flag=page:<[page]>]> d:<[inventory]>
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
    x: <item[white_stained_glass].with[display_name=<&sp>]>
    head: <item[player_head].with[display_name=<&sp>;custom_model_data=3]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Player<&sp>list].with_flag[to:report]>
    confirm: <item[air]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [x] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [back] [] [] [] [head] [] [] [] [confirm]

mod_report_inv_open:
  type: task
  debug: false
  definitions: target|selected|message
  data:
    slot_data:
      info: 50
  script:
    # Inventory
    - define inventory <inventory[mod_report_inv]>
    - adjust def:inventory "title:<&6>Adriftus <&f>- <&a>Report <&e><[target].name><&a>."
    # Selected
    - define selected <list> if:<[selected].exists.not>
    - define infractions <list>
    - define map <map>
    - foreach <list[1|2|3]> as:level:
      - foreach <script[mod_kick_infractions].list_keys[default.<[level]>]> as:infraction:
        - define map <[map].with[<[infraction]>.category].as[<script[mod_kick_infractions].data_key[default.<[level]>.<[infraction]>.category]>]>
        - define map <[map].with[<[infraction]>.level].as[<[level]>]>
        # Build item
        - define item <item[red_terracotta]>
        - define name <&e><[infraction]>
        - define lore <list[<&b>Category<&co><&sp><script[mod_kick_infractions].data_key[default.<[level]>.<[infraction]>.category]>]>
        - define lore:->:<&e>Left<&sp>Click<&sp>to<&sp>add<&sp>to<&sp>selection
        - flag <[item]> INFRACTION:<[infraction]>
        - flag <[item]> LEVEL:<[level]>
        - flag <[item]> CATEGORY:<script[mod_kick_infractions].data_key[default.<[level]>.<[infraction]>.category]>
        # Selected vs Not Selected
        - if <[selected].contains[<[infraction]>]>:
          - define item <[item].with[display_name=<[name]>;lore=<[lore]>;enchantments=arrow_infinite=1;hides=ALL]>
        - else:
          - define item <[item].with[display_name=<[name]>;lore=<[lore]>;hides=ALL]>
        - inventory set slot:<script[mod_kick_infractions].data_key[default.<[level]>.<[infraction]>.report_slot]> o:<[item]> d:<[inventory]>
    # Place confirmation button if player has selected at least one infraction
    - if <[selected].unescaped.as_list.size> > 0:
      - inventory set slot:54 o:<item[lime_stained_glass_pane].with[display_name=<&a><&l>✓<&sp>Report]> d:<[inventory]>
    # Save data on an item in the inventory
    - if <[message].exists>:
      - inventory set slot:<script.data_key[data.slot_data.info]> o:<item[player_head].with[display_name=<&e><[target].name>;lore=<list[<&6>Message<&co><&sp><&f><[message].unescaped.parse_color>]>;skull_skin=<[target].name>;custom_model_data=3;flag=target:<[target]>;flag=selected:<[selected].unescaped>;flag=message:<[message].unescaped>]> d:<[inventory]>
    - else:
      - inventory set slot:<script.data_key[data.slot_data.info]> o:<item[player_head].with[display_name=<&e><[target].name>;skull_skin=<[target].name>;custom_model_data=3;flag=target:<[target]>;flag=selected:<[selected].unescaped>]> d:<[inventory]>
    - inventory open d:<[inventory]>

mod_report_inv_events:
  type: world
  debug: false
  events:
    on player left clicks red_terracotta in mod_report_inv:
      # Get definitions from inventory and item clicked
      - define info_item <context.inventory.slot[<script[mod_report_inv_open].data_key[data.slot_data.info]>]>
      - define target <[info_item].flag[target]>
      - define selected <[info_item].flag[selected]>
      - define message <[info_item].flag[message]> if:<[info_item].has_flag[message]>
      - define this <context.item.flag[infraction]>
      # Add if selected has less than five items
      - if <[selected].contains[<[this]>].not> && <[selected].size.add[1]> < 6:
        - define selected:->:<[this]>
      # Do not add if selected has five items
      - else if <[selected].contains[<[this]>].not> && <[selected].size.add[1]> == 6:
        - narrate "<&c>Only five reasons can be selected at maximum per report."
        - stop
      # Remove from selected
      - else:
        - define selected:<-:<[this]>
      # Check if player is reporting a message
      - if <[message].exists>:
        - run mod_report_inv_open def:<[target]>|<[selected].escaped>|<[message]>
      - else:
        - run mod_report_inv_open def:<[target]>|<[selected].escaped>

    on player left clicks lime_stained_glass_pane in mod_report_inv:
      - define info_item <context.inventory.slot[<script[mod_report_inv_open].data_key[data.slot_data.info]>]>
      - define target <[info_item].flag[target]>
      - define selected <[info_item].flag[selected]>
      - define message <[info_item].flag[message]> if:<[info_item].has_flag[message]>
      - flag <player> report:true expire:10m
      - flag <player> reported.<[target].uuid>:true expire:30m
      - if <[message].exists>:
        - run mod_message_discord_report "def:reported `<[target].name>` for <[selected].formatted> for the chat message `<[message].unescaped.strip_color>`."
        - narrate "<&a>You have reported <&e><[target].name><&a> for <&e><[selected].formatted><&a> for the chat message <&f><[message].unescaped.parse_color><&a>. Thank you for your report."
      - else:
        - run mod_message_discord_report "def:reported `<[target].name>` for <[selected].formatted>."
        - narrate "<&a>You have reported <&e><[target].name><&a> for <&e><[selected].formatted><&a>. Thank you for your report."
      - inventory close
