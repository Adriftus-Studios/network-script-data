uncompressed_deepslate:
  type: item
  material: deepslate
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_deepslate
      output_quantity: 9

compressed_deepslate:
  type: item
  material: deepslate
  display name: <&f>Compressed Deepslate
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Deepslate"
  data:
    recipe_book_category: blocks.deepslate1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_deepslate
      output_quantity: 9
    2:
      type: shaped
      input:
      - deepslate|deepslate|deepslate
      - deepslate|deepslate|deepslate
      - deepslate|deepslate|deepslate

double_compressed_deepslate:
  type: item
  material: deepslate
  display name: <&f>Double Compressed Deepslate
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Deepslate"
  data:
    recipe_book_category: blocks.deepslate2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_deepslate
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_deepslate|compressed_deepslate|compressed_deepslate
      - compressed_deepslate|compressed_deepslate|compressed_deepslate
      - compressed_deepslate|compressed_deepslate|compressed_deepslate

triple_compressed_deepslate:
  type: item
  material: deepslate
  display name: <&f>Triple Compressed Deepslate
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Deepslate"
  data:
    recipe_book_category: blocks.deepslate3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_deepslate
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_deepslate|double_compressed_deepslate|double_compressed_deepslate
      - double_compressed_deepslate|double_compressed_deepslate|double_compressed_deepslate
      - double_compressed_deepslate|double_compressed_deepslate|double_compressed_deepslate

quadruple_compressed_deepslate:
  type: item
  material: deepslate
  display name: <&f>Quadruple Compressed Deepslate
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Deepslate"
  data:
    recipe_book_category: blocks.deepslate4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_deepslate|triple_compressed_deepslate|triple_compressed_deepslate
      - triple_compressed_deepslate|triple_compressed_deepslate|triple_compressed_deepslate
      - triple_compressed_deepslate|triple_compressed_deepslate|triple_compressed_deepslate