uncompressed_gold_block:
  type: item
  material: gold_block
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_gold_block
      output_quantity: 9

compressed_gold_block:
  type: item
  material: gold_block
  display name: <&f>Compressed Gold Block
  lore:
    - "<&7>9 Gold Block"
  data:
    recipe_book_category: blocks.gold_block1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_gold_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - gold_block|gold_block|gold_block
      - gold_block|gold_block|gold_block
      - gold_block|gold_block|gold_block

double_compressed_gold_block:
  type: item
  material: gold_block
  display name: <&f>Double Compressed Gold Block
  lore:
    - "<&7>81 Gold Block"
  data:
    recipe_book_category: blocks.gold_block2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_gold_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_gold_block|compressed_gold_block|compressed_gold_block
      - compressed_gold_block|compressed_gold_block|compressed_gold_block
      - compressed_gold_block|compressed_gold_block|compressed_gold_block

triple_compressed_gold_block:
  type: item
  material: gold_block
  display name: <&f>Triple Compressed Gold Block
  lore:
    - "<&7>729 Gold Block"
  data:
    recipe_book_category: blocks.gold_block3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_gold_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_gold_block|double_compressed_gold_block|double_compressed_gold_block
      - double_compressed_gold_block|double_compressed_gold_block|double_compressed_gold_block
      - double_compressed_gold_block|double_compressed_gold_block|double_compressed_gold_block

quadruple_compressed_gold_block:
  type: item
  material: gold_block
  display name: <&f>Quadruple Compressed Gold Block
  lore:
    - "<&7>6561 Gold Block"
  data:
    recipe_book_category: blocks.gold_block4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_gold_block|triple_compressed_gold_block|triple_compressed_gold_block
      - triple_compressed_gold_block|triple_compressed_gold_block|triple_compressed_gold_block
      - triple_compressed_gold_block|triple_compressed_gold_block|triple_compressed_gold_block