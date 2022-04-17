uncompressed_diamond_block:
  type: item
  material: diamond_block
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_diamond_block
      output_quantity: 9

compressed_diamond_block:
  type: item
  material: diamond_block
  display name: <&f>Compressed Diamond Block
  lore:
    - "<&7>9 Diamond Block"
  data:
    recipe_book_category: blocks.diamond_block1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_diamond_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - diamond_block|diamond_block|diamond_block
      - diamond_block|diamond_block|diamond_block
      - diamond_block|diamond_block|diamond_block

double_compressed_diamond_block:
  type: item
  material: diamond_block
  display name: <&f>Double Compressed Diamond Block
  lore:
    - "<&7>81 Diamond Block"
  data:
    recipe_book_category: blocks.diamond_block2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_diamond_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_diamond_block|compressed_diamond_block|compressed_diamond_block
      - compressed_diamond_block|compressed_diamond_block|compressed_diamond_block
      - compressed_diamond_block|compressed_diamond_block|compressed_diamond_block

triple_compressed_diamond_block:
  type: item
  material: diamond_block
  display name: <&f>Triple Compressed Diamond Block
  lore:
    - "<&7>729 Diamond Block"
  data:
    recipe_book_category: blocks.diamond_block3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_diamond_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_diamond_block|double_compressed_diamond_block|double_compressed_diamond_block
      - double_compressed_diamond_block|double_compressed_diamond_block|double_compressed_diamond_block
      - double_compressed_diamond_block|double_compressed_diamond_block|double_compressed_diamond_block

quadruple_compressed_diamond_block:
  type: item
  material: diamond_block
  display name: <&f>Quadruple Compressed Diamond Block
  lore:
    - "<&7>6561 Diamond Block"
  data:
    recipe_book_category: blocks.diamond_block4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_diamond_block|triple_compressed_diamond_block|triple_compressed_diamond_block
      - triple_compressed_diamond_block|triple_compressed_diamond_block|triple_compressed_diamond_block
      - triple_compressed_diamond_block|triple_compressed_diamond_block|triple_compressed_diamond_block