uncompressed_moss_block:
  type: item
  material: moss_block
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_moss_block
      output_quantity: 9

compressed_moss_block:
  type: item
  material: moss_block
  display name: <&f>Compressed Moss Block
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Moss Block
  data:
    recipe_book_category: blocks.moss_block1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_moss_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - moss_block|moss_block|moss_block
      - moss_block|moss_block|moss_block
      - moss_block|moss_block|moss_block

double_compressed_moss_block:
  type: item
  material: moss_block
  display name: <&f>Double Compressed Moss Block
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Moss Block
  data:
    recipe_book_category: blocks.moss_block2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_moss_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_moss_block|compressed_moss_block|compressed_moss_block
      - compressed_moss_block|compressed_moss_block|compressed_moss_block
      - compressed_moss_block|compressed_moss_block|compressed_moss_block

triple_compressed_moss_block:
  type: item
  material: moss_block
  display name: <&f>Triple Compressed Moss Block
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Moss Block
  data:
    recipe_book_category: blocks.moss_block3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_moss_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_moss_block|double_compressed_moss_block|double_compressed_moss_block
      - double_compressed_moss_block|double_compressed_moss_block|double_compressed_moss_block
      - double_compressed_moss_block|double_compressed_moss_block|double_compressed_moss_block

quadruple_compressed_moss_block:
  type: item
  material: moss_block
  display name: <&f>Quadruple Compressed Moss Block
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Moss Block
  data:
    recipe_book_category: blocks.moss_block4
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_moss_block|triple_compressed_moss_block|triple_compressed_moss_block
      - triple_compressed_moss_block|triple_compressed_moss_block|triple_compressed_moss_block
      - triple_compressed_moss_block|triple_compressed_moss_block|triple_compressed_moss_block