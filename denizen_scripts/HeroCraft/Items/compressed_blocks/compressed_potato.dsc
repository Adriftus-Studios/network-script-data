uncompressed_potato:
  type: item
  material: potato
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_potato
      output_quantity: 9

compressed_potato:
  type: item
  material: potato
  display name: <&f>Compressed Potato
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Potato"
  data:
    recipe_book_category: blocks.potato1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_potato
      output_quantity: 9
    2:
      type: shaped
      input:
      - potato|potato|potato
      - potato|potato|potato
      - potato|potato|potato

double_compressed_potato:
  type: item
  material: potato
  display name: <&f>Double Compressed Potato
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Potato"
  data:
    recipe_book_category: blocks.potato2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_potato
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_potato|compressed_potato|compressed_potato
      - compressed_potato|compressed_potato|compressed_potato
      - compressed_potato|compressed_potato|compressed_potato

triple_compressed_potato:
  type: item
  material: potato
  display name: <&f>Triple Compressed Potato
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Potato"
  data:
    recipe_book_category: blocks.potato3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_potato
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_potato|double_compressed_potato|double_compressed_potato
      - double_compressed_potato|double_compressed_potato|double_compressed_potato
      - double_compressed_potato|double_compressed_potato|double_compressed_potato

quadruple_compressed_potato:
  type: item
  material: potato
  display name: <&f>Quadruple Compressed Potato
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Potato"
  data:
    recipe_book_category: blocks.potato4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_potato|triple_compressed_potato|triple_compressed_potato
      - triple_compressed_potato|triple_compressed_potato|triple_compressed_potato
      - triple_compressed_potato|triple_compressed_potato|triple_compressed_potato