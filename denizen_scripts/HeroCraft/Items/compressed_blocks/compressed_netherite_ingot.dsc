uncompressed_netherite_ingot:
  type: item
  material: netherite_ingot
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_netherite_ingot
      output_quantity: 9

compressed_netherite_ingot:
  type: item
  material: netherite_ingot
  display name: <&f>Compressed Netherite Ingot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Netherite Ingot
  data:
    recipe_book_category: blocks.netherite_ingot1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_netherite_ingot
      output_quantity: 9
    2:
      type: shaped
      input:
      - netherite_ingot|netherite_ingot|netherite_ingot
      - netherite_ingot|netherite_ingot|netherite_ingot
      - netherite_ingot|netherite_ingot|netherite_ingot

double_compressed_netherite_ingot:
  type: item
  material: netherite_ingot
  display name: <&f>Double Compressed Netherite Ingot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Netherite Ingot
  data:
    recipe_book_category: blocks.netherite_ingot2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_netherite_ingot
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_netherite_ingot|compressed_netherite_ingot|compressed_netherite_ingot
      - compressed_netherite_ingot|compressed_netherite_ingot|compressed_netherite_ingot
      - compressed_netherite_ingot|compressed_netherite_ingot|compressed_netherite_ingot

triple_compressed_netherite_ingot:
  type: item
  material: netherite_ingot
  display name: <&f>Triple Compressed Netherite Ingot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Netherite Ingot
  data:
    recipe_book_category: blocks.netherite_ingot3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_netherite_ingot
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_netherite_ingot|double_compressed_netherite_ingot|double_compressed_netherite_ingot
      - double_compressed_netherite_ingot|double_compressed_netherite_ingot|double_compressed_netherite_ingot
      - double_compressed_netherite_ingot|double_compressed_netherite_ingot|double_compressed_netherite_ingot

quadruple_compressed_netherite_ingot:
  type: item
  material: netherite_ingot
  display name: <&f>Quadruple Compressed Netherite Ingot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Netherite Ingot
  data:
    recipe_book_category: blocks.netherite_ingot4
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_netherite_ingot|triple_compressed_netherite_ingot|triple_compressed_netherite_ingot
      - triple_compressed_netherite_ingot|triple_compressed_netherite_ingot|triple_compressed_netherite_ingot
      - triple_compressed_netherite_ingot|triple_compressed_netherite_ingot|triple_compressed_netherite_ingot