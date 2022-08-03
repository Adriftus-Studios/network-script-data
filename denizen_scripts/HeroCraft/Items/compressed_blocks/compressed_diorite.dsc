uncompressed_diorite:
  type: item
  material: diorite
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_diorite
      output_quantity: 9

compressed_diorite:
  type: item
  material: diorite
  display name: <&f>Compressed Diorite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Diorite"
  data:
    recipe_book_category: blocks.diorite1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_diorite
      output_quantity: 9
    2:
      type: shaped
      input:
      - diorite|diorite|diorite
      - diorite|diorite|diorite
      - diorite|diorite|diorite

double_compressed_diorite:
  type: item
  material: diorite
  display name: <&f>Double Compressed Diorite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>81 Diorite"
  data:
    recipe_book_category: blocks.diorite2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_diorite
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_diorite|compressed_diorite|compressed_diorite
      - compressed_diorite|compressed_diorite|compressed_diorite
      - compressed_diorite|compressed_diorite|compressed_diorite

triple_compressed_diorite:
  type: item
  material: diorite
  display name: <&f>Triple Compressed Diorite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>729 Diorite"
  data:
    recipe_book_category: blocks.diorite3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_diorite
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_diorite|double_compressed_diorite|double_compressed_diorite
      - double_compressed_diorite|double_compressed_diorite|double_compressed_diorite
      - double_compressed_diorite|double_compressed_diorite|double_compressed_diorite

quadruple_compressed_diorite:
  type: item
  material: diorite
  display name: <&f>Quadruple Compressed Diorite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>6561 Diorite"
  data:
    recipe_book_category: blocks.diorite4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_diorite|triple_compressed_diorite|triple_compressed_diorite
      - triple_compressed_diorite|triple_compressed_diorite|triple_compressed_diorite
      - triple_compressed_diorite|triple_compressed_diorite|triple_compressed_diorite