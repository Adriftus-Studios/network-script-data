uncompressed_iron_block:
  type: item
  material: iron_block
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_iron_block
      output_quantity: 9

compressed_iron_block:
  type: item
  material: iron_block
  display name: <&f>Compressed Iron Block
  lore:
    - "<&7>9 Iron Block"
  data:
    recipe_book_category: blocks.iron_block1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_iron_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - iron_block|iron_block|iron_block
      - iron_block|iron_block|iron_block
      - iron_block|iron_block|iron_block

double_compressed_iron_block:
  type: item
  material: iron_block
  display name: <&f>Double Compressed Iron Block
  lore:
    - "<&7>81 Iron Block"
  data:
    recipe_book_category: blocks.iron_block2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_iron_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_iron_block|compressed_iron_block|compressed_iron_block
      - compressed_iron_block|compressed_iron_block|compressed_iron_block
      - compressed_iron_block|compressed_iron_block|compressed_iron_block

triple_compressed_iron_block:
  type: item
  material: iron_block
  display name: <&f>Triple Compressed Iron Block
  lore:
    - "<&7>729 Iron Block"
  data:
    recipe_book_category: blocks.iron_block3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_iron_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_iron_block|double_compressed_iron_block|double_compressed_iron_block
      - double_compressed_iron_block|double_compressed_iron_block|double_compressed_iron_block
      - double_compressed_iron_block|double_compressed_iron_block|double_compressed_iron_block

quadruple_compressed_iron_block:
  type: item
  material: iron_block
  display name: <&f>Quadruple Compressed Iron Block
  lore:
    - "<&7>6561 Iron Block"
  data:
    recipe_book_category: blocks.iron_block4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_iron_block|triple_compressed_iron_block|triple_compressed_iron_block
      - triple_compressed_iron_block|triple_compressed_iron_block|triple_compressed_iron_block
      - triple_compressed_iron_block|triple_compressed_iron_block|triple_compressed_iron_block