uncompressed_stone:
  type: item
  material: stone
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_stone
      output_quantity: 9

compressed_stone:
  type: item
  material: stone
  display name: <&f>Compressed Stone
  lore:
    - "<&7>9 Stone"
  data:
    recipe_book_category: blocks.stone1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_stone
      output_quantity: 9
    2:
      type: shaped
      input:
      - stone|stone|stone
      - stone|stone|stone
      - stone|stone|stone

double_compressed_stone:
  type: item
  material: stone
  display name: <&f>Double Compressed Stone
  lore:
    - "<&7>81 Stone"
  data:
    recipe_book_category: blocks.stone2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_stone
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_stone|compressed_stone|compressed_stone
      - compressed_stone|compressed_stone|compressed_stone
      - compressed_stone|compressed_stone|compressed_stone

triple_compressed_stone:
  type: item
  material: stone
  display name: <&f>Triple Compressed Stone
  lore:
    - "<&7>729 Stone"
  data:
    recipe_book_category: blocks.stone3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_stone
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_stone|double_compressed_stone|double_compressed_stone
      - double_compressed_stone|double_compressed_stone|double_compressed_stone
      - double_compressed_stone|double_compressed_stone|double_compressed_stone

quadruple_compressed_stone:
  type: item
  material: stone
  display name: <&f>Quadruple Compressed Stone
  lore:
    - "<&7>6561 Stone"
  data:
    recipe_book_category: blocks.stone4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_stone|triple_compressed_stone|triple_compressed_stone
      - triple_compressed_stone|triple_compressed_stone|triple_compressed_stone
      - triple_compressed_stone|triple_compressed_stone|triple_compressed_stone