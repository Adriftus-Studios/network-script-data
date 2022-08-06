uncompressed_netherrack:
  type: item
  material: netherrack
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_netherrack
      output_quantity: 9

compressed_netherrack:
  type: item
  material: netherrack
  display name: <&f>Compressed Netherrack
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Netherrack
  data:
    recipe_book_category: blocks.netherrack1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_netherrack
      output_quantity: 9
    2:
      type: shaped
      input:
      - netherrack|netherrack|netherrack
      - netherrack|netherrack|netherrack
      - netherrack|netherrack|netherrack

double_compressed_netherrack:
  type: item
  material: netherrack
  display name: <&f>Double Compressed Netherrack
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Netherrack
  data:
    recipe_book_category: blocks.netherrack2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_netherrack
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_netherrack|compressed_netherrack|compressed_netherrack
      - compressed_netherrack|compressed_netherrack|compressed_netherrack
      - compressed_netherrack|compressed_netherrack|compressed_netherrack

triple_compressed_netherrack:
  type: item
  material: netherrack
  display name: <&f>Triple Compressed Netherrack
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Netherrack
  data:
    recipe_book_category: blocks.netherrack3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_netherrack
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_netherrack|double_compressed_netherrack|double_compressed_netherrack
      - double_compressed_netherrack|double_compressed_netherrack|double_compressed_netherrack
      - double_compressed_netherrack|double_compressed_netherrack|double_compressed_netherrack

quadruple_compressed_netherrack:
  type: item
  material: netherrack
  display name: <&f>Quadruple Compressed Netherrack
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Netherrack
  data:
    recipe_book_category: blocks.netherrack4
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_netherrack|triple_compressed_netherrack|triple_compressed_netherrack
      - triple_compressed_netherrack|triple_compressed_netherrack|triple_compressed_netherrack
      - triple_compressed_netherrack|triple_compressed_netherrack|triple_compressed_netherrack