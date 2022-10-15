uncompressed_totem_of_undying:
  type: item
  material: totem_of_undying
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_totem_of_undying
      output_quantity: 9

compressed_totem_of_undying:
  type: item
  material: totem_of_undying
  display name: <&f>Compressed Totem Of Undying
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Totem Of Undying
  data:
    recipe_book_category: blocks.totem_of_undying1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_totem_of_undying
      output_quantity: 9
    2:
      type: shaped
      input:
      - totem_of_undying|totem_of_undying|totem_of_undying
      - totem_of_undying|totem_of_undying|totem_of_undying
      - totem_of_undying|totem_of_undying|totem_of_undying

double_compressed_totem_of_undying:
  type: item
  material: totem_of_undying
  display name: <&f>Double Compressed Totem Of Undying
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Totem Of Undying
  data:
    recipe_book_category: blocks.totem_of_undying2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_totem_of_undying
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_totem_of_undying|compressed_totem_of_undying|compressed_totem_of_undying
      - compressed_totem_of_undying|compressed_totem_of_undying|compressed_totem_of_undying
      - compressed_totem_of_undying|compressed_totem_of_undying|compressed_totem_of_undying

triple_compressed_totem_of_undying:
  type: item
  material: totem_of_undying
  display name: <&f>Triple Compressed Totem Of Undying
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Totem Of Undying
  data:
    recipe_book_category: blocks.totem_of_undying3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_totem_of_undying
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_totem_of_undying|double_compressed_totem_of_undying|double_compressed_totem_of_undying
      - double_compressed_totem_of_undying|double_compressed_totem_of_undying|double_compressed_totem_of_undying
      - double_compressed_totem_of_undying|double_compressed_totem_of_undying|double_compressed_totem_of_undying

quadruple_compressed_totem_of_undying:
  type: item
  material: totem_of_undying
  display name: <&f>Quadruple Compressed Totem Of Undying
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Totem Of Undying
  data:
    recipe_book_category: blocks.totem_of_undying4
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_totem_of_undying|triple_compressed_totem_of_undying|triple_compressed_totem_of_undying
      - triple_compressed_totem_of_undying|triple_compressed_totem_of_undying|triple_compressed_totem_of_undying
      - triple_compressed_totem_of_undying|triple_compressed_totem_of_undying|triple_compressed_totem_of_undying