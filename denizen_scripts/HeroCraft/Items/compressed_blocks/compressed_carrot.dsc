uncompressed_carrot:
  type: item
  material: carrot
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_carrot
      output_quantity: 9

compressed_carrot:
  type: item
  material: carrot
  display name: <&f>Compressed Carrot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Carrot"
  data:
    recipe_book_category: blocks.carrot1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_carrot
      output_quantity: 9
    2:
      type: shaped
      input:
      - carrot|carrot|carrot
      - carrot|carrot|carrot
      - carrot|carrot|carrot

double_compressed_carrot:
  type: item
  material: carrot
  display name: <&f>Double Compressed Carrot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Carrot"
  data:
    recipe_book_category: blocks.carrot2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_carrot
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_carrot|compressed_carrot|compressed_carrot
      - compressed_carrot|compressed_carrot|compressed_carrot
      - compressed_carrot|compressed_carrot|compressed_carrot

triple_compressed_carrot:
  type: item
  material: carrot
  display name: <&f>Triple Compressed Carrot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Carrot"
  data:
    recipe_book_category: blocks.carrot3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_carrot
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_carrot|double_compressed_carrot|double_compressed_carrot
      - double_compressed_carrot|double_compressed_carrot|double_compressed_carrot
      - double_compressed_carrot|double_compressed_carrot|double_compressed_carrot

quadruple_compressed_carrot:
  type: item
  material: carrot
  display name: <&f>Quadruple Compressed Carrot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Carrot"
  data:
    recipe_book_category: blocks.carrot4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_carrot|triple_compressed_carrot|triple_compressed_carrot
      - triple_compressed_carrot|triple_compressed_carrot|triple_compressed_carrot
      - triple_compressed_carrot|triple_compressed_carrot|triple_compressed_carrot