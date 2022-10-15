uncompressed_emerald_block:
  type: item
  material: emerald_block
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_emerald_block
      output_quantity: 9

compressed_emerald_block:
  type: item
  material: emerald_block
  display name: <&f>Compressed Emerald Block
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Emerald Block
  data:
    recipe_book_category: blocks.emerald_block1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_emerald_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - emerald_block|emerald_block|emerald_block
      - emerald_block|emerald_block|emerald_block
      - emerald_block|emerald_block|emerald_block

double_compressed_emerald_block:
  type: item
  material: emerald_block
  display name: <&f>Double Compressed Emerald Block
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Emerald Block
  data:
    recipe_book_category: blocks.emerald_block2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_emerald_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_emerald_block|compressed_emerald_block|compressed_emerald_block
      - compressed_emerald_block|compressed_emerald_block|compressed_emerald_block
      - compressed_emerald_block|compressed_emerald_block|compressed_emerald_block

triple_compressed_emerald_block:
  type: item
  material: emerald_block
  display name: <&f>Triple Compressed Emerald Block
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Emerald Block
  data:
    recipe_book_category: blocks.emerald_block3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_emerald_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_emerald_block|double_compressed_emerald_block|double_compressed_emerald_block
      - double_compressed_emerald_block|double_compressed_emerald_block|double_compressed_emerald_block
      - double_compressed_emerald_block|double_compressed_emerald_block|double_compressed_emerald_block

quadruple_compressed_emerald_block:
  type: item
  material: emerald_block
  display name: <&f>Quadruple Compressed Emerald Block
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Emerald Block
  data:
    recipe_book_category: blocks.emerald_block4
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_emerald_block|triple_compressed_emerald_block|triple_compressed_emerald_block
      - triple_compressed_emerald_block|triple_compressed_emerald_block|triple_compressed_emerald_block
      - triple_compressed_emerald_block|triple_compressed_emerald_block|triple_compressed_emerald_block