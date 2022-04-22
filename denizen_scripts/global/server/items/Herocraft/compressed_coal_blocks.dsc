uncompressed_coal_block:
  type: item
  material: coal_block
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_coal_block
      output_quantity: 9

compressed_coal_block:
  type: item
  material: coal_block
  display name: <&f>Compressed Coal Block
  lore:
    - "<&7>9 Coal Block"
  data:
    recipe_book_category: blocks.coal_block1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_coal_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - coal_block|coal_block|coal_block
      - coal_block|coal_block|coal_block
      - coal_block|coal_block|coal_block

double_compressed_coal_block:
  type: item
  material: coal_block
  display name: <&f>Double Compressed Coal Block
  lore:
    - "<&7>81 Coal Block"
  data:
    recipe_book_category: blocks.coal_block2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_coal_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_coal_block|compressed_coal_block|compressed_coal_block
      - compressed_coal_block|compressed_coal_block|compressed_coal_block
      - compressed_coal_block|compressed_coal_block|compressed_coal_block

triple_compressed_coal_block:
  type: item
  material: coal_block
  display name: <&f>Triple Compressed Coal Block
  lore:
    - "<&7>729 Coal Block"
  data:
    recipe_book_category: blocks.coal_block3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_coal_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_coal_block|double_compressed_coal_block|double_compressed_coal_block
      - double_compressed_coal_block|double_compressed_coal_block|double_compressed_coal_block
      - double_compressed_coal_block|double_compressed_coal_block|double_compressed_coal_block

quadruple_compressed_coal_block:
  type: item
  material: coal_block
  display name: <&f>Quadruple Compressed Coal Block
  lore:
    - "<&7>6561 Coal Block"
  data:
    recipe_book_category: blocks.coal_block4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_coal_block|triple_compressed_coal_block|triple_compressed_coal_block
      - triple_compressed_coal_block|triple_compressed_coal_block|triple_compressed_coal_block
      - triple_compressed_coal_block|triple_compressed_coal_block|triple_compressed_coal_block