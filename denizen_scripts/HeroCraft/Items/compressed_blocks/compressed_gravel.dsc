uncompressed_gravel:
  type: item
  material: gravel
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_gravel
      output_quantity: 9

compressed_gravel:
  type: item
  material: gravel
  display name: <&f>Compressed Gravel
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Gravel"
  data:
    recipe_book_category: blocks.gravel1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_gravel
      output_quantity: 9
    2:
      type: shaped
      input:
      - gravel|gravel|gravel
      - gravel|gravel|gravel
      - gravel|gravel|gravel

double_compressed_gravel:
  type: item
  material: gravel
  display name: <&f>Double Compressed Gravel
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>81 Gravel"
  data:
    recipe_book_category: blocks.gravel2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_gravel
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_gravel|compressed_gravel|compressed_gravel
      - compressed_gravel|compressed_gravel|compressed_gravel
      - compressed_gravel|compressed_gravel|compressed_gravel

triple_compressed_gravel:
  type: item
  material: gravel
  display name: <&f>Triple Compressed Gravel
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>729 Gravel"
  data:
    recipe_book_category: blocks.gravel3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_gravel
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_gravel|double_compressed_gravel|double_compressed_gravel
      - double_compressed_gravel|double_compressed_gravel|double_compressed_gravel
      - double_compressed_gravel|double_compressed_gravel|double_compressed_gravel

quadruple_compressed_gravel:
  type: item
  material: gravel
  display name: <&f>Quadruple Compressed Gravel
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>6561 Gravel"
  data:
    recipe_book_category: blocks.gravel4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_gravel|triple_compressed_gravel|triple_compressed_gravel
      - triple_compressed_gravel|triple_compressed_gravel|triple_compressed_gravel
      - triple_compressed_gravel|triple_compressed_gravel|triple_compressed_gravel