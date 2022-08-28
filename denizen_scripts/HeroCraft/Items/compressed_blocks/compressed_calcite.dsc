uncompressed_calcite:
  type: item
  material: calcite
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_calcite
      output_quantity: 9

compressed_calcite:
  type: item
  material: calcite
  display name: <&f>Compressed Calcite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Calcite"
  data:
    recipe_book_category: blocks.calcite1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_calcite
      output_quantity: 9
    2:
      type: shaped
      input:
      - calcite|calcite|calcite
      - calcite|calcite|calcite
      - calcite|calcite|calcite

double_compressed_calcite:
  type: item
  material: calcite
  display name: <&f>Double Compressed Calcite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Calcite"
  data:
    recipe_book_category: blocks.calcite2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_calcite
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_calcite|compressed_calcite|compressed_calcite
      - compressed_calcite|compressed_calcite|compressed_calcite
      - compressed_calcite|compressed_calcite|compressed_calcite

triple_compressed_calcite:
  type: item
  material: calcite
  display name: <&f>Triple Compressed Calcite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Calcite"
  data:
    recipe_book_category: blocks.calcite3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_calcite
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_calcite|double_compressed_calcite|double_compressed_calcite
      - double_compressed_calcite|double_compressed_calcite|double_compressed_calcite
      - double_compressed_calcite|double_compressed_calcite|double_compressed_calcite

quadruple_compressed_calcite:
  type: item
  material: calcite
  display name: <&f>Quadruple Compressed Calcite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Calcite"
  data:
    recipe_book_category: blocks.calcite4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_calcite|triple_compressed_calcite|triple_compressed_calcite
      - triple_compressed_calcite|triple_compressed_calcite|triple_compressed_calcite
      - triple_compressed_calcite|triple_compressed_calcite|triple_compressed_calcite