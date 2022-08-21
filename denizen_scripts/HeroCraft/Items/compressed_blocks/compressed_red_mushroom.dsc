uncompressed_red_mushroom:
  type: item
  material: red_mushroom
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_red_mushroom
      output_quantity: 9

compressed_red_mushroom:
  type: item
  material: red_mushroom
  display name: <&f>Compressed Red Mushroom
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Red Mushroom"
  data:
    recipe_book_category: blocks.red_mushroom1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_red_mushroom
      output_quantity: 9
    2:
      type: shaped
      input:
      - red_mushroom|red_mushroom|red_mushroom
      - red_mushroom|red_mushroom|red_mushroom
      - red_mushroom|red_mushroom|red_mushroom

double_compressed_red_mushroom:
  type: item
  material: red_mushroom
  display name: <&f>Double Compressed Red Mushroom
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Red Mushroom"
  data:
    recipe_book_category: blocks.red_mushroom2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_red_mushroom
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_red_mushroom|compressed_red_mushroom|compressed_red_mushroom
      - compressed_red_mushroom|compressed_red_mushroom|compressed_red_mushroom
      - compressed_red_mushroom|compressed_red_mushroom|compressed_red_mushroom

triple_compressed_red_mushroom:
  type: item
  material: red_mushroom
  display name: <&f>Triple Compressed Red Mushroom
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Red Mushroom"
  data:
    recipe_book_category: blocks.red_mushroom3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_red_mushroom
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_red_mushroom|double_compressed_red_mushroom|double_compressed_red_mushroom
      - double_compressed_red_mushroom|double_compressed_red_mushroom|double_compressed_red_mushroom
      - double_compressed_red_mushroom|double_compressed_red_mushroom|double_compressed_red_mushroom

quadruple_compressed_red_mushroom:
  type: item
  material: red_mushroom
  display name: <&f>Quadruple Compressed Red Mushroom
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Red Mushroom"
  data:
    recipe_book_category: blocks.red_mushroom4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_red_mushroom|triple_compressed_red_mushroom|triple_compressed_red_mushroom
      - triple_compressed_red_mushroom|triple_compressed_red_mushroom|triple_compressed_red_mushroom
      - triple_compressed_red_mushroom|triple_compressed_red_mushroom|triple_compressed_red_mushroom