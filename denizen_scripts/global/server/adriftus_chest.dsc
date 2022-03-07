adriftus_chest_inventory_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[adriftus_chest_inventory]>
    - adjust <[inventory]> size:<yaml[global.player.<player.uuid>].read[adriftus.chest.size]||9>
    - foreach <yaml[global.player.<player.uuid>].read[adriftus.chest.contents_map]||<list>>:
      - inventory set slot:<[key]> o:<[value]> d:<[inventory]>
    - inventory open d:<[inventory]>

adriftus_chest_inventory:
  type: inventory
  inventory: chest
  title: <&6>Adriftus Chest
  size: 9

adriftus_chest_inventory_events:
  type: world
  debug: false
  events:
    on player closes adriftus_chest_inventory:
      - define contents <context.inventory.map_slots>
      - run global_player_data_modify def:<player.uuid>|adriftus.chest.contents_map|<[contents]>