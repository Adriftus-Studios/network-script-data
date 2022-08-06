uncompressed_obsidian:
  type: item
  material: obsidian
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_obsidian
      output_quantity: 9

compressed_obsidian:
  type: item
  material: obsidian
  display name: <&f>Compressed Obsidian
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Obsidian
  data:
    recipe_book_category: blocks.obsidian1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_obsidian
      output_quantity: 9
    2:
      type: shaped
      input:
      - obsidian|obsidian|obsidian
      - obsidian|obsidian|obsidian
      - obsidian|obsidian|obsidian

double_compressed_obsidian:
  type: item
  material: obsidian
  display name: <&f>Double Compressed Obsidian
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Obsidian
  data:
    recipe_book_category: blocks.obsidian2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_obsidian
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_obsidian|compressed_obsidian|compressed_obsidian
      - compressed_obsidian|compressed_obsidian|compressed_obsidian
      - compressed_obsidian|compressed_obsidian|compressed_obsidian

triple_compressed_obsidian:
  type: item
  material: obsidian
  display name: <&f>Triple Compressed Obsidian
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Obsidian
  data:
    recipe_book_category: blocks.obsidian3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_obsidian
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_obsidian|double_compressed_obsidian|double_compressed_obsidian
      - double_compressed_obsidian|double_compressed_obsidian|double_compressed_obsidian
      - double_compressed_obsidian|double_compressed_obsidian|double_compressed_obsidian

quadruple_compressed_obsidian:
  type: item
  material: obsidian
  display name: <&f>Quadruple Compressed Obsidian
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Obsidian
  data:
    recipe_book_category: blocks.obsidian4
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_obsidian|triple_compressed_obsidian|triple_compressed_obsidian
      - triple_compressed_obsidian|triple_compressed_obsidian|triple_compressed_obsidian
      - triple_compressed_obsidian|triple_compressed_obsidian|triple_compressed_obsidian