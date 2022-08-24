uncompressed_wheat_seeds:
  type: item
  material: wheat_seeds
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_wheat_seeds
      output_quantity: 9

compressed_wheat_seeds:
  type: item
  material: wheat_seeds
  display name: <&f>Compressed Wheat Seeds
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Wheat Seeds"
  data:
    recipe_book_category: blocks.wheat_seeds1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_wheat_seeds
      output_quantity: 9
    2:
      type: shaped
      input:
      - wheat_seeds|wheat_seeds|wheat_seeds
      - wheat_seeds|wheat_seeds|wheat_seeds
      - wheat_seeds|wheat_seeds|wheat_seeds

double_compressed_wheat_seeds:
  type: item
  material: wheat_seeds
  display name: <&f>Double Compressed Wheat Seeds
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Wheat Seeds"
  data:
    recipe_book_category: blocks.wheat_seeds2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_wheat_seeds
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_wheat_seeds|compressed_wheat_seeds|compressed_wheat_seeds
      - compressed_wheat_seeds|compressed_wheat_seeds|compressed_wheat_seeds
      - compressed_wheat_seeds|compressed_wheat_seeds|compressed_wheat_seeds

triple_compressed_wheat_seeds:
  type: item
  material: wheat_seeds
  display name: <&f>Triple Compressed Wheat Seeds
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Wheat Seeds"
  data:
    recipe_book_category: blocks.wheat_seeds3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_wheat_seeds
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_wheat_seeds|double_compressed_wheat_seeds|double_compressed_wheat_seeds
      - double_compressed_wheat_seeds|double_compressed_wheat_seeds|double_compressed_wheat_seeds
      - double_compressed_wheat_seeds|double_compressed_wheat_seeds|double_compressed_wheat_seeds

quadruple_compressed_wheat_seeds:
  type: item
  material: wheat_seeds
  display name: <&f>Quadruple Compressed Wheat Seeds
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Wheat Seeds"
  data:
    recipe_book_category: blocks.wheat_seeds4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_wheat_seeds|triple_compressed_wheat_seeds|triple_compressed_wheat_seeds
      - triple_compressed_wheat_seeds|triple_compressed_wheat_seeds|triple_compressed_wheat_seeds
      - triple_compressed_wheat_seeds|triple_compressed_wheat_seeds|triple_compressed_wheat_seeds