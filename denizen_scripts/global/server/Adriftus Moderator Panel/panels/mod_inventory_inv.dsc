# -- INVENTORY PANEL
mod_inventory_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f><&gt> <&8>Inventory
  inventory: CHEST
  gui: true
  size: 54
  definitions:
    x: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    b1: <item[lime_stained_glass_pane].with[display_name=<&sp>]>
    b2: <item[green_stained_glass_pane].with[display_name=<&sp>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel].with_flag[to:actions]>
    head: <item[mod_player_item]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [back] [b1] [b2] [b1] [head] [b1] [b2] [b1] [b2]

mod_inventory_inv_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[mod_inventory_inv]>
    - define map <player.flag[amp_map].as_map.get[uuid].as_player.inventory.map_slots>
    - adjust def:inventory "title:<&6>A<&e>MP <&f><&gt> <&2><player.flag[amp_map].as_map.get[uuid].as_player.name><&a>'s Inventory."
    - foreach <[map]>:
      # How do I do a range? (from 1 to 9, etc.)
      - define slot <[key]>
      # Hotbar
      - if <list[1|2|3|4|5|6|7|8|9].contains[<[key]>]>:
        - define slot:+:36
      # Armour
      - else if <list[37|38|39|40].contains[<[key]>]>:
        - define slot <script[map_inventory_map].data_key[<[slot]>]>
      # Offhand
      - else if <[key]> == 41:
        - define slot 5
      - inventory set slot:<[slot]> o:<[value]> d:<[inventory]>
    - inventory open d:<[inventory]>

map_inventory_map:
  type: data
  37: 4
  38: 3
  39: 2
  40: 1
