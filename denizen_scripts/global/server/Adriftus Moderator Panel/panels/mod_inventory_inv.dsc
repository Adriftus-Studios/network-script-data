# -- INVENTORY PANEL
mod_inventory_inv:
  type: inventory
  debug: false
  title: <&f><&font[adriftus:mod_tools]><&chr[F808]><&chr[1003]>
  inventory: CHEST
  gui: true
  size: 54
  definitions:
    x: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    back: <item[feather].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel;custom_model_data=3].with_flag[to:actions]>
    head: <item[mod_player_item]>
    inv: <item[paper].with[display_name=<&a><&l>⬓<&sp>Inventory;custom_model_data=400;enchantments=arrow_infinite=1;hides=ALL].with_flag[to:inventory]>
    ec: <item[paper].with[display_name=<&d><&l>⬒<&sp>Ender<&sp>Chest;custom_model_data=402].with_flag[to:enderchest]>
    ac: <item[stone].with[display_name=<&6><&l>⬕<&sp>Adriftus<&sp>Chest;custom_model_data=1].with_flag[to:adriftuschest]>
  slots:
    - [x] [x] [] [] [] [] [] [x] [x]
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [back] [x] [x] [x] [head] [x] [inv] [ec] [ac]

mod_inventory_inv_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[mod_inventory_inv]>
    - foreach <player.flag[amp].get[player].inventory.map_slots>:
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
        - define slot 7
      - inventory set slot:<[slot]> o:<[value]> d:<[inventory]>
    - inventory open d:<[inventory]>

map_inventory_map:
  type: data
  37: 6
  38: 5
  39: 4
  40: 3

# ENDER CHEST
mod_ender_chest_inv:
  type: inventory
  debug: false
  title: <&f><&font[adriftus:mod_tools]><&chr[F808]><&chr[1004]>
  inventory: CHEST
  gui: true
  size: 54
  definitions:
    x: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    back: <item[feather].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel;custom_model_data=3].with_flag[to:actions]>
    head: <item[mod_player_item]>
    inv: <item[paper].with[display_name=<&a><&l>⬓<&sp>Inventory;custom_model_data=400].with_flag[to:inventory]>
    ec: <item[paper].with[display_name=<&d><&l>⬒<&sp>Ender<&sp>Chest;custom_model_data=402;enchantments=arrow_infinite=1;hides=ALL].with_flag[to:enderchest]>
    ac: <item[stone].with[display_name=<&6><&l>⬕<&sp>Adriftus<&sp>Chest;custom_model_data=1].with_flag[to:adriftuschest]>
  slots:
    - [x] [x] [x] [x] [x] [x] [x] [x] [x]
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [x] [x] [x] [x] [x] [x] [x] [x] [x]
    - [back] [x] [x] [x] [head] [x] [inv] [ec] [ac]

mod_ender_chest_inv_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[mod_ender_chest_inv]>
    - foreach <player.flag[amp].as_map.get[player].enderchest.map_slots>:
      - inventory set slot:<[key]> o:<[value]> d:<[inventory]>
    - inventory open d:<[inventory]>

# ADRIFTUS CHEST
mod_adriftus_chest_inv:
  type: inventory
  debug: false
  title: <&f><&font[adriftus:mod_tools]><&chr[F808]><&chr[1005]>
  inventory: CHEST
  gui: true
  size: 54
  definitions:
    x: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    back: <item[feather].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel;custom_model_data=3].with_flag[to:actions]>
    head: <item[mod_player_item]>
    inv: <item[paper].with[display_name=<&a><&l>⬓<&sp>Inventory;custom_model_data=400].with_flag[to:inventory]>
    ec: <item[paper].with[display_name=<&d><&l>⬒<&sp>Ender<&sp>Chest;custom_model_data=402].with_flag[to:enderchest]>
    ac: <item[stone].with[display_name=<&6><&l>⬕<&sp>Adriftus<&sp>Chest;custom_model_data=1;enchantments=arrow_infinite=1;hides=ALL].with_flag[to:adriftuschest]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [back] [x] [x] [x] [head] [x] [inv] [ec] [ac]

mod_adriftus_chest_inv_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[mod_adriftus_chest_inv]>
    - foreach <yaml[global.player.<player.flag[amp].as_map.get[uuid]>].read[adriftus.chest.contents_map]||<map>>:
      - inventory set slot:<[key]> o:<[value]> d:<[inventory]>
    - inventory open d:<[inventory]>

