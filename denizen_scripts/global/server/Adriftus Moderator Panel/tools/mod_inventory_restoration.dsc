# -- Inventory Restoration
inventory_logger_list:
  type: task
  debug: true
  definitions: target
  script:
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
    - define inventory <inventory[inventory_logger_inventory]>
    - foreach <[list]> as:map:
      - define lore "<&e>Cause<&co> <&f><[map].get[cause]>|<&e>Time<&co> <&f><[map].get[time].format>|<&e>Location<&co> <&f><[map].get[location].simple>"
      - if <[map].get[cause]> == Death:
        - define "list:->:<item[black_wool].with[display=<&6>Logged Inventory;lore=<[lore]>;flag=run_script:inventory_logger_view_inventory;flag=uuid:<[map].get[uuid]>;flag=target:<[target]>]>"
      - else:
        - define "list:->:<item[white_wool].with[display=<&6>Logged Inventory;lore=<[lore]>;flag=run_script:inventory_logger_view_inventory;flag=uuid:<[map].get[uuid]>;flag=target:<[target]>]>"
    - give <[list]> to:<[inventory]>
    # Title
    - adjust def:inventory "title:<&6>A<&e>MP <&f>· <&a>Restore <&2><[target].name><&a>'s inventories."
    # Back Button
    - inventory set slot:46 d:<[inventory]> o:<item[leather_horse_armor].with[hides=all;display_name=<&a>Back;flag=run_script:mod_actions_inv_open;flag=target:<[target]>;color=red;custom_model_data=6]>
    - inventory open d:<[inventory]>

inventory_logger_inventory:
  type: inventory
  debug: false
  inventory: chest
  size: 54
  gui: true

inventory_log_open:
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
    - run mod_initialize def:<[target].uuid>
    - run inventory_logger_list def:<[target]>

inventory_logger_view_inventory:
  type: task
  debug: true
  definitions: uuid|target
  script:
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
    - define inventory <inventory[inventory_logger_inventory]>
    - foreach <[list]> as:map:
      - if <[map].get[uuid]> == <[uuid]>:
        - inventory set o:<[map].get[inventory].parse_value_tag[<[parse_value].with_flag[run_script:inventory_logger_view_inventory_single].with_flag[target:<[target]>]>]> d:<[inventory]>
        - define the_map <[map]>

    # Restore Inventory Button
    - inventory set slot:50 d:<[inventory]> "o:player_head[skull_skin=<[target].skull_skin>;display=<&a>Restore Inventory;lore=<&e>Requires Empty Inventory|<&nl><&e>Cause<&co> <&f><[the_map].get[cause]>|<&e>Time<&co> <&f><[the_map].get[time].format>|<&e>Location<&co> <&f><[the_map].get[location].simple>;flag=cause:<[the_map].get[cause]>;flag=run_script:inventory_logger_view_inventory_restore;flag=uuid:<[the_map].get[uuid]>;flag=target:<[target]>]"

    # Back Button
    - inventory set slot:46 d:<[inventory]> o:<item[leather_horse_armor].with[hides=all;display_name=<&a>Back;flag=run_script:inventory_logger_list;flag=target:<[target]>;color=red;custom_model_data=6]>

    # Title
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
