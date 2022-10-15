uncompressed_beetroot:
  type: item
  material: beetroot
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_beetroot
      output_quantity: 9

compressed_beetroot:
  type: item
  material: beetroot
  display name: <&f>Compressed Beetroot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Beetroot"
  data:
    recipe_book_category: blocks.beetroot1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_beetroot
      output_quantity: 9
    2:
      type: shaped
      input:
      - beetroot|beetroot|beetroot
      - beetroot|beetroot|beetroot
      - beetroot|beetroot|beetroot

double_compressed_beetroot:
  type: item
  material: beetroot
  display name: <&f>Double Compressed Beetroot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Beetroot"
  data:
    recipe_book_category: blocks.beetroot2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_beetroot
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_beetroot|compressed_beetroot|compressed_beetroot
      - compressed_beetroot|compressed_beetroot|compressed_beetroot
      - compressed_beetroot|compressed_beetroot|compressed_beetroot

triple_compressed_beetroot:
  type: item
  material: beetroot
  display name: <&f>Triple Compressed Beetroot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Beetroot"
  data:
    recipe_book_category: blocks.beetroot3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_beetroot
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_beetroot|double_compressed_beetroot|double_compressed_beetroot
      - double_compressed_beetroot|double_compressed_beetroot|double_compressed_beetroot
      - double_compressed_beetroot|double_compressed_beetroot|double_compressed_beetroot

quadruple_compressed_beetroot:
  type: item
  material: beetroot
  display name: <&f>Quadruple Compressed Beetroot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Beetroot"
  data:
    recipe_book_category: blocks.beetroot4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_beetroot|triple_compressed_beetroot|triple_compressed_beetroot
      - triple_compressed_beetroot|triple_compressed_beetroot|triple_compressed_beetroot
      - triple_compressed_beetroot|triple_compressed_beetroot|triple_compressed_beetroot