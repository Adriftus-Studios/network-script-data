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
      - if <script[per_player_loot_additions].data_key[<bungee.server>].exists>:
        - foreach <script[per_player_loot_additions].data_key[<bungee.server>]> key:item as:chance:
          - if <util.random_chance[<[chance]>]>:
            - define loot:->:<item[<[item]>]>
    - inventory set o:<[loot]> d:<[inventory]>
    - inventory open d:<[inventory]>

per_player_loot_additions:
  type: data
  zanzabar:
    multiverse_dust: 0.5
    tpa_crystal: 2
    back_crystal: 2
    morb_empty: 0.5
    grappling_hook_basic: 1
    grappling_hook_better: 0.5
    grappling_hook_advanced: 0.1
    grappling_hook_master: 0.01