uncompressed_tuff:
  type: item
  material: tuff
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_tuff
      output_quantity: 9

compressed_tuff:
  type: item
  material: tuff
  display name: <&f>Compressed Tuff
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Tuff"
  data:
    recipe_book_category: blocks.tuff1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_tuff
      output_quantity: 9
    2:
      type: shaped
      input:
      - tuff|tuff|tuff
      - tuff|tuff|tuff
      - tuff|tuff|tuff

double_compressed_tuff:
  type: item
  material: tuff
  display name: <&f>Double Compressed Tuff
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Tuff"
  data:
    recipe_book_category: blocks.tuff2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_tuff
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_tuff|compressed_tuff|compressed_tuff
      - compressed_tuff|compressed_tuff|compressed_tuff
      - compressed_tuff|compressed_tuff|compressed_tuff

triple_compressed_tuff:
  type: item
  material: tuff
  display name: <&f>Triple Compressed Tuff
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Tuff"
  data:
    recipe_book_category: blocks.tuff3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_tuff
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_tuff|double_compressed_tuff|double_compressed_tuff
      - double_compressed_tuff|double_compressed_tuff|double_compressed_tuff
      - double_compressed_tuff|double_compressed_tuff|double_compressed_tuff

quadruple_compressed_tuff:
  type: item
  material: tuff
  display name: <&f>Quadruple Compressed Tuff
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Tuff"
  data:
    recipe_book_category: blocks.tuff4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_tuff|triple_compressed_tuff|triple_compressed_tuff
      - triple_compressed_tuff|triple_compressed_tuff|triple_compressed_tuff
      - triple_compressed_tuff|triple_compressed_tuff|triple_compressed_tuff