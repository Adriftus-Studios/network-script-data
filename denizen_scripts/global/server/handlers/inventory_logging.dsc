inventory_logger_death:
  type: world
  debug: false
  data:
    map:
      cause: Death
      location: <player.location>
      inventory: <player.inventory.map_slots>
      xp: <player.xp_total>
      time: <util.time_now>
      uuid: <util.random_uuid>
      milli_time: <server.current_time_millis>
  events:
    on player dies bukkit_priority:MONITOR:
      - stop if:<player.flag[saved_inventory.current].equals[default].not.if_null[false]>
      - stop if:<player.inventory.list_contents.is_empty>
      - flag <player> logged_inventories.death:->:<script.parsed_key[data.map]>
      - if <player.flag[logged_inventories.death].size> > 20:
        - flag <player> logged_inventories.death:<player.flag[logged_inventories.death].remove[first]>

inventory_logger_logout:
  type: world
  debug: false
  data:
    map:
      cause: Logout
      location: <player.location>
      inventory: <player.inventory.map_slots>
      xp: <player.xp_total>
      time: <util.time_now>
      uuid: <util.random_uuid>
      milli_time: <server.current_time_millis>

  events:
    on player joins:
      - stop if:<player.flag[saved_inventory.current].equals[default].not.if_null[false]>
      - stop if:<player.inventory.list_contents.is_empty>
      - flag <player> logged_inventories.logout:->:<script.parsed_key[data.map]>
      - if <player.flag[logged_inventories.logout].size> > 20:
        - flag <player> logged_inventories.logout:<player.flag[logged_inventories.logout].remove[first]>
