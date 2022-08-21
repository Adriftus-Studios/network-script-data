uncompressed_glow_berries:
  type: item
  material: glow_berries
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_glow_berries
      output_quantity: 9

compressed_glow_berries:
  type: item
  material: glow_berries
  display name: <&f>Compressed Glow Berries
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Glow Berries"
  data:
    recipe_book_category: blocks.glow_berries1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_glow_berries
      output_quantity: 9
    2:
      type: shaped
      input:
      - glow_berries|glow_berries|glow_berries
      - glow_berries|glow_berries|glow_berries
      - glow_berries|glow_berries|glow_berries

double_compressed_glow_berries:
  type: item
  material: glow_berries
  display name: <&f>Double Compressed Glow Berries
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Glow Berries"
  data:
    recipe_book_category: blocks.glow_berries2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_glow_berries
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_glow_berries|compressed_glow_berries|compressed_glow_berries
      - compressed_glow_berries|compressed_glow_berries|compressed_glow_berries
      - compressed_glow_berries|compressed_glow_berries|compressed_glow_berries

triple_compressed_glow_berries:
  type: item
  material: glow_berries
  display name: <&f>Triple Compressed Glow Berries
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Glow Berries"
  data:
    recipe_book_category: blocks.glow_berries3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_glow_berries
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_glow_berries|double_compressed_glow_berries|double_compressed_glow_berries
      - double_compressed_glow_berries|double_compressed_glow_berries|double_compressed_glow_berries
      - double_compressed_glow_berries|double_compressed_glow_berries|double_compressed_glow_berries

quadruple_compressed_glow_berries:
  type: item
  material: glow_berries
  display name: <&f>Quadruple Compressed Glow Berries
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Glow Berries"
  data:
    recipe_book_category: blocks.glow_berries4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_glow_berries|triple_compressed_glow_berries|triple_compressed_glow_berries
      - triple_compressed_glow_berries|triple_compressed_glow_berries|triple_compressed_glow_berries
      - triple_compressed_glow_berries|triple_compressed_glow_berries|triple_compressed_glow_berries