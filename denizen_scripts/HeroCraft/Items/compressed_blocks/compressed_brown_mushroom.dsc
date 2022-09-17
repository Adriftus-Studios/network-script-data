uncompressed_brown_mushroom:
  type: item
  material: brown_mushroom
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_brown_mushroom
      output_quantity: 9

compressed_brown_mushroom:
  type: item
  material: brown_mushroom
  display name: <&f>Compressed Brown Mushroom
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Brown Mushroom"
  data:
    recipe_book_category: blocks.brown_mushroom1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_brown_mushroom
      output_quantity: 9
    2:
      type: shaped
      input:
      - brown_mushroom|brown_mushroom|brown_mushroom
      - brown_mushroom|brown_mushroom|brown_mushroom
      - brown_mushroom|brown_mushroom|brown_mushroom

double_compressed_brown_mushroom:
  type: item
  material: brown_mushroom
  display name: <&f>Double Compressed Brown Mushroom
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Brown Mushroom"
  data:
    recipe_book_category: blocks.brown_mushroom2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_brown_mushroom
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_brown_mushroom|compressed_brown_mushroom|compressed_brown_mushroom
      - compressed_brown_mushroom|compressed_brown_mushroom|compressed_brown_mushroom
      - compressed_brown_mushroom|compressed_brown_mushroom|compressed_brown_mushroom

triple_compressed_brown_mushroom:
  type: item
  material: brown_mushroom
  display name: <&f>Triple Compressed Brown Mushroom
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Brown Mushroom"
  data:
    recipe_book_category: blocks.brown_mushroom3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_brown_mushroom
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_brown_mushroom|double_compressed_brown_mushroom|double_compressed_brown_mushroom
      - double_compressed_brown_mushroom|double_compressed_brown_mushroom|double_compressed_brown_mushroom
      - double_compressed_brown_mushroom|double_compressed_brown_mushroom|double_compressed_brown_mushroom

quadruple_compressed_brown_mushroom:
  type: item
  material: brown_mushroom
  display name: <&f>Quadruple Compressed Brown Mushroom
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Brown Mushroom"
  data:
    recipe_book_category: blocks.brown_mushroom4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_brown_mushroom|triple_compressed_brown_mushroom|triple_compressed_brown_mushroom
      - triple_compressed_brown_mushroom|triple_compressed_brown_mushroom|triple_compressed_brown_mushroom
      - triple_compressed_brown_mushroom|triple_compressed_brown_mushroom|triple_compressed_brown_mushroom