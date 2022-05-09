per_player_loot_inventory:
  type: inventory
  inventory: chest
  title: <&c>Personalized Loot
  size: 54
  data:
    on_close: per_player_loot_save

per_player_loot_save:
  type: task
  debug: fase
  script:
    - define location <player.flag[looted_locations.current]>
    - flag player looted_locations.<[location]>:<context.inventory.map_slots>
    - flag player looted_locations.current:!

per_player_loot:
  type: task
  debug: false
  script:
    - if !<context.location.has_loot_table>:
      - stop
    - determine passively cancelled
    - define inventory <inventory[per_player_loot_inventory]>
    - flag <player> looted_locations.current:<context.location.simple>
    - if <player.has_flag[looted_locations.<context.location.simple>]>:
      - define loot <player.flag[looted_locations.<context.location.simple>]>
    - else if <context.location.has_loot_table>:
      - define loot <server.generate_loot_table[<map[id=<context.location.loot_table_id>;location=<context.location>]>]>
      - flag player looted_locations.<context.location.simple>:<[loot]>
    - inventory set o:<[loot]> d:<[inventory]>
    - inventory open d:<[inventory]>