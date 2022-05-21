# -- INVENTORY PANEL
mod_inventory_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f><&gt> <&8>Inventory
  inventory: CHEST
  gui: true
  size: 27
  definitions:
    x: <item[air]>
    b1: <item[magenta_stained_glass_pane].with[display_name=<&sp>]>
    b2: <item[purple_stained_glass_pane].with[display_name=<&sp>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel].with_flag[to:actions]>
    head: <item[mod_player_item]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [b2] [b1] [b2] [back] [head] [back] [b2] [b1] [b2]

mod_inventory_inv_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[mod_inventory_inv]>
    - adjust def:inventory "title:<&6>A<&e>MP <&f><&gt> <&7><player.flag[amp_map].as_map.get[uuid].as_player.name><&sq>s <&8>Inventory."
    - foreach <player.flag[amp_map].as_map.get[uuid].as_player.inventory.map_slots>:
      - inventory set slot:<[value]> o:<[value].parse_value_tag[<[parse_value]>]> d:<[inventory]>
    - inventory open d:<[inventory]>
