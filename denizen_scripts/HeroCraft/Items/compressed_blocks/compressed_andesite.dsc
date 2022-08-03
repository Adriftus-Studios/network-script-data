uncompressed_andesite:
  type: item
  material: andesite
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_andesite
      output_quantity: 9

compressed_andesite:
  type: item
  material: andesite
  display name: <&f>Compressed Andesite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Andesite"
  data:
    recipe_book_category: blocks.andesite1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_andesite
      output_quantity: 9
    2:
      type: shaped
      input:
      - andesite|andesite|andesite
      - andesite|andesite|andesite
      - andesite|andesite|andesite

double_compressed_andesite:
  type: item
  material: andesite
  display name: <&f>Double Compressed Andesite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>81 Andesite"
  data:
    recipe_book_category: blocks.andesite2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_andesite
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_andesite|compressed_andesite|compressed_andesite
      - compressed_andesite|compressed_andesite|compressed_andesite
      - compressed_andesite|compressed_andesite|compressed_andesite

triple_compressed_andesite:
  type: item
  material: andesite
  display name: <&f>Triple Compressed Andesite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>729 Andesite"
  data:
    recipe_book_category: blocks.andesite3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_andesite
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_andesite|double_compressed_andesite|double_compressed_andesite
      - double_compressed_andesite|double_compressed_andesite|double_compressed_andesite
      - double_compressed_andesite|double_compressed_andesite|double_compressed_andesite

quadruple_compressed_andesite:
  type: item
  material: andesite
  display name: <&f>Quadruple Compressed Andesite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>6561 Andesite"
  data:
    recipe_book_category: blocks.andesite4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_andesite|triple_compressed_andesite|triple_compressed_andesite
      - triple_compressed_andesite|triple_compressed_andesite|triple_compressed_andesite
      - triple_compressed_andesite|triple_compressed_andesite|triple_compressed_andesite