uncompressed_cobbled_deepslate:
  type: item
  material: cobbled_deepslate
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_cobbled_deepslate
      output_quantity: 9

compressed_cobbled_deepslate:
  type: item
  material: cobbled_deepslate
  display name: <&f>Compressed Cobbled Deepslate
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Cobbled Deepslate
  data:
    recipe_book_category: blocks.cobbled_deepslate1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_cobbled_deepslate
      output_quantity: 9
    2:
      type: shaped
      input:
      - cobbled_deepslate|cobbled_deepslate|cobbled_deepslate
      - cobbled_deepslate|cobbled_deepslate|cobbled_deepslate
      - cobbled_deepslate|cobbled_deepslate|cobbled_deepslate

double_compressed_cobbled_deepslate:
  type: item
  material: cobbled_deepslate
  display name: <&f>Double Compressed Cobbled Deepslate
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Cobbled Deepslate
  data:
    recipe_book_category: blocks.cobbled_deepslate2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_cobbled_deepslate
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_cobbled_deepslate|compressed_cobbled_deepslate|compressed_cobbled_deepslate
      - compressed_cobbled_deepslate|compressed_cobbled_deepslate|compressed_cobbled_deepslate
      - compressed_cobbled_deepslate|compressed_cobbled_deepslate|compressed_cobbled_deepslate

triple_compressed_cobbled_deepslate:
  type: item
  material: cobbled_deepslate
  display name: <&f>Triple Compressed Cobbled Deepslate
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Cobbled Deepslate
  data:
    recipe_book_category: blocks.cobbled_deepslate3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_cobbled_deepslate
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_cobbled_deepslate|double_compressed_cobbled_deepslate|double_compressed_cobbled_deepslate
      - double_compressed_cobbled_deepslate|double_compressed_cobbled_deepslate|double_compressed_cobbled_deepslate
      - double_compressed_cobbled_deepslate|double_compressed_cobbled_deepslate|double_compressed_cobbled_deepslate

quadruple_compressed_cobbled_deepslate:
  type: item
  material: cobbled_deepslate
  display name: <&f>Quadruple Compressed Cobbled Deepslate
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Cobbled Deepslate
  data:
    recipe_book_category: blocks.cobbled_deepslate4
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_cobbled_deepslate|triple_compressed_cobbled_deepslate|triple_compressed_cobbled_deepslate
      - triple_compressed_cobbled_deepslate|triple_compressed_cobbled_deepslate|triple_compressed_cobbled_deepslate
      - triple_compressed_cobbled_deepslate|triple_compressed_cobbled_deepslate|triple_compressed_cobbled_deepslate