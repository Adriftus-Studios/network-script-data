# -- Inventory Restoration
# View inventory log
inventory_logger_inventory:
  type: inventory
  debug: false
  inventory: chest
  size: 54
  gui: true
  definitions:
    x: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    previous: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    next: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    head: <item[mod_player_item]>
    back: <item[feather].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel;custom_model_data=3]>
  slots:
    - [x] [x] [x] [x] [x] [x] [x] [x] [x]
    - [x] [] [] [] [] [] [] [] [x]
    - [x] [] [] [] [] [] [] [] [x]
    - [x] [] [] [] [] [] [] [] [x]
    - [previous] [x] [x] [x] [x] [x] [x] [x] [next]
    - [back] [x] [x] [x] [head] [x] [x] [x] [x]

inventory_logger_list:
  type: task
  debug: true
  definitions: target|page
  data:
    slot_data:
      slots_used: 11|12|13|14|15|16|17|20|21|22|23|24|25|26|29|30|31|32|33|34|35
      back: 46
      page: 50
      previous_page: 37
      next_page: 45
  script:
    # Pagination
    - define page 1 if:<[page].exists.not>
    - define slots <list[<script.parsed_key[data.slot_data.slots_used]>]>
    - define start <[page].sub[1].mul[<[slots].size>].add[1]>
    - define end <[slots].size.mul[<[page]>]>
    # Logged inventories
    - define inventory <inventory[inventory_logger_inventory]>
    - define target <context.item.flag[target]> if:<[target].exists.not>
    - define list <list>
    - if <[target].has_flag[logged_inventories.logout]>:
      - define list:|:<[target].flag[logged_inventories.logout]>
    - if <[target].has_flag[logged_inventories.death]>:
      - define list:|:<[target].flag[logged_inventories.death]>
    - define list <[list].sort_by_number[get[milli_time]].reverse>
    - if <[list].is_empty>:
      - narrate "<&c>No Saved Inventories Recorded."
      - stop
    - define items <list>
    - foreach <[list].get[<[start]>].to[<[end]>]> as:map:
      - define lore "<&e>Cause<&co> <&f><[map].get[cause]>|<&e>Time<&co> <&f><[map].get[time].format>|<&e>Location<&co> <&f><[map].get[location].simple>"
      - if <[map].get[cause]> == Death:
        - define "items:|:<item[paper].with[display=<&6>Logged Inventory;lore=<[lore]>;flag=run_script:inventory_logger_view_inventory;flag=uuid:<[map].get[uuid]>;flag=target:<[target]>;custom_model_data=405]>"
      - else:
        - define "items:|:<item[paper].with[display=<&6>Logged Inventory;lore=<[lore]>;flag=run_script:inventory_logger_view_inventory;flag=uuid:<[map].get[uuid]>;flag=target:<[target]>;custom_model_data=404]>"
    - foreach <[items]>:
      - inventory set slot:<[slots].get[<[loop_index]>]> o:<[value]> d:<[inventory]>

    # Pagination Item
    - inventory set slot:<script.data_key[data.slot_data.page]> o:<item[mod_player_item].with[flag=target:<[target]>;flag=page:<[page]>]> d:<[inventory]>

    # Previous Page Button
    - if <[page]> != 1:
      - inventory set slot:<script.data_key[data.slot_data.previous_page]> o:<item[leather_horse_armor].with[hides=all;display_name=<&a>Previous<&sp>Page;flag=run_script:inventory_logger_list_previous_page;color=green;custom_model_data=6]> d:<[inventory]>

    # Next Page Button
    - if <[list].size> > <[end]>:
      - inventory set slot:<script.data_key[data.slot_data.next_page]> o:<item[leather_horse_armor].with[hides=all;display_name=<&a>Next<&sp>Page;flag=run_script:inventory_logger_list_next_page;color=green;custom_model_data=7]> d:<[inventory]>

    # Back Button
    - if <[target]> != <player>:
      - inventory set slot:46 d:<[inventory]> o:<item[red_stained_glass_pane].with[hides=all;display_name=<&c><&l>↩<&sp>Actions<&sp>panel;flag=run_script:mod_actions_inv_open;flag=target:<[target]>]>
    - else:
      - inventory set slot:46 d:<[inventory]> o:<item[red_stained_glass_pane].with[hides=all;display_name=<&c><&l>↩<&sp>Actions<&sp>panel;flag=run_script:inventory_logger_back_cancel;flag=target:<[target]>]>

    - adjust def:inventory "title:<&6>A<&e>MP <&f>· <&a>Restore <&2><[target].name><&a>'s inventories."
    - inventory open d:<[inventory]>

inventory_logger_list_previous_page:
  type: task
  debug: false
  script:
    - define page_item <context.inventory.slot[<script[inventory_logger_list].data_key[data.slot_data.page]>]>
    - run inventory_logger_list def:<[page_item].flag[target]>|<[page_item].flag[page].sub[1]>

inventory_logger_list_next_page:
  type: task
  debug: false
  script:
    - define page_item <context.inventory.slot[<script[inventory_logger_list].data_key[data.slot_data.page]>]>
    - run inventory_logger_list def:<[page_item].flag[target]>|<[page_item].flag[page].add[1]>

inventory_logger_back_cancel:
  type: task
  debug: false
  script:
    - narrate "<&c>You cannot perform actions on yourself."

# View logged inventory
inventory_logger_view_inventory:
  type: task
  debug: true
  definitions: uuid|target
  script:
    - define inventory <inventory[inventory_logger_inventory]>
    - define target <context.item.flag[target]> if:<[target].exists.not>
    - define uuid <context.item.flag[uuid]> if:<[uuid].exists.not>
    - define list <list>
    - if <[target].has_flag[logged_inventories.logout]>:
      - define list:|:<[target].flag[logged_inventories.logout]>
    - if <[target].has_flag[logged_inventories.death]>:
      - define list:|:<[target].flag[logged_inventories.death]>
    - if <[list].is_empty>:
      - narrate "<&c>No Saved Inventories Recorded."
      - stop
    - foreach <[list]> as:map:
      - if <[map].get[uuid]> == <[uuid]>:
        - inventory set o:<[map].get[inventory].parse_value_tag[<[parse_value].with_flag[run_script:inventory_logger_view_inventory_single].with_flag[target:<[target]>]>]> d:<[inventory]>
        - define the_map <[map]>

    # Restore Inventory Button
    - inventory set slot:50 d:<[inventory]> "o:player_head[skull_skin=<[target].skull_skin>;display=<&a>Restore Inventory;lore=<&e>Requires Empty Inventory|<&nl><&e>Cause<&co> <&f><[the_map].get[cause]>|<&e>Time<&co> <&f><[the_map].get[time].format>|<&e>Location<&co> <&f><[the_map].get[location].simple>;flag=cause:<[the_map].get[cause]>;flag=run_script:inventory_logger_view_inventory_restore;flag=uuid:<[the_map].get[uuid]>;flag=target:<[target]>]"

    # Back Button
    - inventory set slot:46 d:<[inventory]> o:<item[leather_horse_armor].with[hides=all;display_name=<&a>Back;flag=run_script:inventory_logger_list;flag=target:<[target]>;color=red;custom_model_data=6]>

    - adjust def:inventory "title:<&6>A<&e>MP <&f>· <&a><[the_map].get[cause]> <[the_map].get[time].format>"
    - inventory open d:<[inventory]>

inventory_logger_view_inventory_restore:
  type: task
  debug: false
  definitions: target|uuid
  script:
    - define target <context.item.flag[target]> if:<[target].exists.not>
    - define uuid <context.item.flag[uuid]> if:<[uuid].exists.not>
    - if !<[target].inventory.list_contents.is_empty>:
      - narrate "<&c>Target's Inventory must be empty."
      - stop
    - foreach <[target].flag[logged_inventories.<context.item.flag[cause]>]>:
      - if <[value].get[uuid]> == <[uuid]>:
        - inventory set d:<[target].inventory> o:<[value].get[inventory]>
        - narrate "<&a>Restored <[target].name>'s inventory<&co> <[value].get[cause]><&sp><[value].get[time].format>"
        - run mod_message_discord_notification def:<player.uuid>|restored<&sp>`<[target].name>`<&sq>s<&sp>inventory<&co><&sp>`<[value].get[cause]><&sp><[value].get[time].format>`
        - run mod_chat_notifier def:<player.uuid>|<[target].uuid> def.action:InventoryRestore def.text:<[value].get[cause]><&sp><[value].get[time].format>
        - inventory close

inventory_logger_view_inventory_single:
  type: task
  debug: false
  definitions: target|uuid
  script:
    - define item <context.item>
    - define target <context.item.flag[target]> if:<[target].exists.not>
    - flag <[item]> run_script:!
    - flag <[item]> target:!
    - give <[item]> to:<player.inventory>
    - run mod_message_discord_notification def:<player.uuid>|restored<&sp>`<[target].name>`<&sq>s<&sp>item<&co><&sp>`<[item]>`

inventory_log_command:
  type: command
  name: inventorylog
  permission: adriftus.moderator
  description: View a player's saved inventories
  usage: /inventorylog (player)
  tab completions:
    1: <server.online_players.parse[name]>
  script:
    - if <context.args.size> < 1:
      - narrate "<&c>You must specify a player name."
      - stop
    - define target <server.match_player[<context.args.first>].if_null[null]>
    - if <[target]> == null:
      - narrate "<&c>Unknown Player<&co> <&f><context.args.first>"
      - stop
    - define uuid <[target].uuid>
    - inject mod_initialize
    - run inventory_logger_list def:<[target]>
