uncompressed_pumpkin:
  type: item
  material: pumpkin
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_pumpkin
      output_quantity: 9

compressed_pumpkin:
  type: item
  material: pumpkin
  display name: <&f>Compressed Pumpkin
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Pumpkin"
  data:
    recipe_book_category: blocks.pumpkin1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_pumpkin
      output_quantity: 9
    2:
      type: shaped
      input:
      - pumpkin|pumpkin|pumpkin
      - pumpkin|pumpkin|pumpkin
      - pumpkin|pumpkin|pumpkin

double_compressed_pumpkin:
  type: item
  material: pumpkin
  display name: <&f>Double Compressed Pumpkin
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Pumpkin"
  data:
    recipe_book_category: blocks.pumpkin2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_pumpkin
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_pumpkin|compressed_pumpkin|compressed_pumpkin
      - compressed_pumpkin|compressed_pumpkin|compressed_pumpkin
      - compressed_pumpkin|compressed_pumpkin|compressed_pumpkin

triple_compressed_pumpkin:
  type: item
  material: pumpkin
  display name: <&f>Triple Compressed Pumpkin
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Pumpkin"
  data:
    recipe_book_category: blocks.pumpkin3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_pumpkin
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_pumpkin|double_compressed_pumpkin|double_compressed_pumpkin
      - double_compressed_pumpkin|double_compressed_pumpkin|double_compressed_pumpkin
      - double_compressed_pumpkin|double_compressed_pumpkin|double_compressed_pumpkin

quadruple_compressed_pumpkin:
  type: item
  material: pumpkin
  display name: <&f>Quadruple Compressed Pumpkin
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Pumpkin"
  data:
    recipe_book_category: blocks.pumpkin4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_pumpkin|triple_compressed_pumpkin|triple_compressed_pumpkin
      - triple_compressed_pumpkin|triple_compressed_pumpkin|triple_compressed_pumpkin
      - triple_compressed_pumpkin|triple_compressed_pumpkin|triple_compressed_pumpkin