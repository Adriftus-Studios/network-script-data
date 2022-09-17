uncompressed_melon:
  type: item
  material: melon
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_melon
      output_quantity: 9

compressed_melon:
  type: item
  material: melon
  display name: <&f>Compressed Melon
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Melon"
  data:
    recipe_book_category: blocks.melon1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_melon
      output_quantity: 9
    2:
      type: shaped
      input:
      - melon|melon|melon
      - melon|melon|melon
      - melon|melon|melon

double_compressed_melon:
  type: item
  material: melon
  display name: <&f>Double Compressed Melon
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Melon"
  data:
    recipe_book_category: blocks.melon2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_melon
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_melon|compressed_melon|compressed_melon
      - compressed_melon|compressed_melon|compressed_melon
      - compressed_melon|compressed_melon|compressed_melon

triple_compressed_melon:
  type: item
  material: melon
  display name: <&f>Triple Compressed Melon
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Melon"
  data:
    recipe_book_category: blocks.melon3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_melon
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_melon|double_compressed_melon|double_compressed_melon
      - double_compressed_melon|double_compressed_melon|double_compressed_melon
      - double_compressed_melon|double_compressed_melon|double_compressed_melon

quadruple_compressed_melon:
  type: item
  material: melon
  display name: <&f>Quadruple Compressed Melon
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Melon"
  data:
    recipe_book_category: blocks.melon4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_melon|triple_compressed_melon|triple_compressed_melon
      - triple_compressed_melon|triple_compressed_melon|triple_compressed_melon
      - triple_compressed_melon|triple_compressed_melon|triple_compressed_melon