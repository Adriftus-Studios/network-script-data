uncompressed_leather:
  type: item
  material: leather
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_leather
      output_quantity: 9

compressed_leather:
  type: item
  material: leather
  display name: <&f>Compressed Leather
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Leather
  data:
    recipe_book_category: blocks.leather1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_leather
      output_quantity: 9
    2:
      type: shaped
      input:
      - leather|leather|leather
      - leather|leather|leather
      - leather|leather|leather

double_compressed_leather:
  type: item
  material: leather
  display name: <&f>Double Compressed Leather
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Leather
  data:
    recipe_book_category: blocks.leather2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_leather
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_leather|compressed_leather|compressed_leather
      - compressed_leather|compressed_leather|compressed_leather
      - compressed_leather|compressed_leather|compressed_leather

triple_compressed_leather:
  type: item
  material: leather
  display name: <&f>Triple Compressed Leather
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Leather
  data:
    recipe_book_category: blocks.leather3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_leather
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_leather|double_compressed_leather|double_compressed_leather
      - double_compressed_leather|double_compressed_leather|double_compressed_leather
      - double_compressed_leather|double_compressed_leather|double_compressed_leather

quadruple_compressed_leather:
  type: item
  material: leather
  display name: <&f>Quadruple Compressed Leather
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Leather
  data:
    recipe_book_category: blocks.leather4
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_leather|triple_compressed_leather|triple_compressed_leather
      - triple_compressed_leather|triple_compressed_leather|triple_compressed_leather
      - triple_compressed_leather|triple_compressed_leather|triple_compressed_leather