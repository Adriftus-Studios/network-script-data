uncompressed_copper_block:
  type: item
  material: copper_block
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_copper_block
      output_quantity: 9

compressed_copper_block:
  type: item
  material: copper_block
  display name: <&f>Compressed Copper Block
  lore:
    - "<&7>9 Copper Block"
  data:
    recipe_book_category: blocks.copper_block1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_copper_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - copper_block|copper_block|copper_block
      - copper_block|copper_block|copper_block
      - copper_block|copper_block|copper_block

double_compressed_copper_block:
  type: item
  material: copper_block
  display name: <&f>Double Compressed Copper Block
  lore:
    - "<&7>81 Copper Block"
  data:
    recipe_book_category: blocks.copper_block2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_copper_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_copper_block|compressed_copper_block|compressed_copper_block
      - compressed_copper_block|compressed_copper_block|compressed_copper_block
      - compressed_copper_block|compressed_copper_block|compressed_copper_block

triple_compressed_copper_block:
  type: item
  material: copper_block
  display name: <&f>Triple Compressed Copper Block
  lore:
    - "<&7>729 Copper Block"
  data:
    recipe_book_category: blocks.copper_block3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_copper_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_copper_block|double_compressed_copper_block|double_compressed_copper_block
      - double_compressed_copper_block|double_compressed_copper_block|double_compressed_copper_block
      - double_compressed_copper_block|double_compressed_copper_block|double_compressed_copper_block

quadruple_compressed_copper_block:
  type: item
  material: copper_block
  display name: <&f>Quadruple Compressed Copper Block
  lore:
    - "<&7>6561 Copper Block"
  data:
    recipe_book_category: blocks.copper_block4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_copper_block|triple_compressed_copper_block|triple_compressed_copper_block
      - triple_compressed_copper_block|triple_compressed_copper_block|triple_compressed_copper_block
      - triple_compressed_copper_block|triple_compressed_copper_block|triple_compressed_copper_block