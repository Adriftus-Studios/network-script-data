uncompressed_amethyst_block:
  type: item
  material: amethyst_block
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_amethyst_block
      output_quantity: 9

compressed_amethyst_block:
  type: item
  material: amethyst_block
  display name: <&f>Compressed Amethyst
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Amethyst
  data:
    recipe_book_category: blocks.amethyst_block1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_amethyst_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - amethyst_block|amethyst_block|amethyst_block
      - amethyst_block|amethyst_block|amethyst_block
      - amethyst_block|amethyst_block|amethyst_block

double_compressed_amethyst_block:
  type: item
  material: amethyst_block
  display name: <&f>Double Compressed Amethyst
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Amethyst
  data:
    recipe_book_category: blocks.amethyst_block2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_amethyst_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_amethyst_block|compressed_amethyst_block|compressed_amethyst_block
      - compressed_amethyst_block|compressed_amethyst_block|compressed_amethyst_block
      - compressed_amethyst_block|compressed_amethyst_block|compressed_amethyst_block

triple_compressed_amethyst_block:
  type: item
  material: amethyst_block
  display name: <&f>Triple Compressed Amethyst
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Amethyst
  data:
    recipe_book_category: blocks.amethyst_block3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_amethyst_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_amethyst_block|double_compressed_amethyst_block|double_compressed_amethyst_block
      - double_compressed_amethyst_block|double_compressed_amethyst_block|double_compressed_amethyst_block
      - double_compressed_amethyst_block|double_compressed_amethyst_block|double_compressed_amethyst_block

quadruple_compressed_amethyst_block:
  type: item
  material: amethyst_block
  display name: <&f>Quadruple Compressed Amethyst
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Amethyst
  data:
    recipe_book_category: blocks.amethyst_block4
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_amethyst_block|triple_compressed_amethyst_block|triple_compressed_amethyst_block
      - triple_compressed_amethyst_block|triple_compressed_amethyst_block|triple_compressed_amethyst_block
      - triple_compressed_amethyst_block|triple_compressed_amethyst_block|triple_compressed_amethyst_block