uncompressed_kelp:
  type: item
  material: kelp
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_kelp
      output_quantity: 9

compressed_kelp:
  type: item
  material: kelp
  display name: <&f>Compressed Kelp
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Kelp"
  data:
    recipe_book_category: blocks.kelp1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_kelp
      output_quantity: 9
    2:
      type: shaped
      input:
      - kelp|kelp|kelp
      - kelp|kelp|kelp
      - kelp|kelp|kelp

double_compressed_kelp:
  type: item
  material: kelp
  display name: <&f>Double Compressed Kelp
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Kelp"
  data:
    recipe_book_category: blocks.kelp2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_kelp
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_kelp|compressed_kelp|compressed_kelp
      - compressed_kelp|compressed_kelp|compressed_kelp
      - compressed_kelp|compressed_kelp|compressed_kelp

triple_compressed_kelp:
  type: item
  material: kelp
  display name: <&f>Triple Compressed Kelp
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Kelp"
  data:
    recipe_book_category: blocks.kelp3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_kelp
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_kelp|double_compressed_kelp|double_compressed_kelp
      - double_compressed_kelp|double_compressed_kelp|double_compressed_kelp
      - double_compressed_kelp|double_compressed_kelp|double_compressed_kelp

quadruple_compressed_kelp:
  type: item
  material: kelp
  display name: <&f>Quadruple Compressed Kelp
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Kelp"
  data:
    recipe_book_category: blocks.kelp4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_kelp|triple_compressed_kelp|triple_compressed_kelp
      - triple_compressed_kelp|triple_compressed_kelp|triple_compressed_kelp
      - triple_compressed_kelp|triple_compressed_kelp|triple_compressed_kelp