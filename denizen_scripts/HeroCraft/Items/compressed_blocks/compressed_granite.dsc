uncompressed_granite:
  type: item
  material: granite
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_granite
      output_quantity: 9

compressed_granite:
  type: item
  material: granite
  display name: <&f>Compressed Granite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Granite"
  data:
    recipe_book_category: blocks.granite1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_granite
      output_quantity: 9
    2:
      type: shaped
      input:
      - granite|granite|granite
      - granite|granite|granite
      - granite|granite|granite

double_compressed_granite:
  type: item
  material: granite
  display name: <&f>Double Compressed Granite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>81 Granite"
  data:
    recipe_book_category: blocks.granite2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_granite
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_granite|compressed_granite|compressed_granite
      - compressed_granite|compressed_granite|compressed_granite
      - compressed_granite|compressed_granite|compressed_granite

triple_compressed_granite:
  type: item
  material: granite
  display name: <&f>Triple Compressed Granite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>729 Granite"
  data:
    recipe_book_category: blocks.granite3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_granite
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_granite|double_compressed_granite|double_compressed_granite
      - double_compressed_granite|double_compressed_granite|double_compressed_granite
      - double_compressed_granite|double_compressed_granite|double_compressed_granite

quadruple_compressed_granite:
  type: item
  material: granite
  display name: <&f>Quadruple Compressed Granite
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>6561 Granite"
  data:
    recipe_book_category: blocks.granite4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_granite|triple_compressed_granite|triple_compressed_granite
      - triple_compressed_granite|triple_compressed_granite|triple_compressed_granite
      - triple_compressed_granite|triple_compressed_granite|triple_compressed_granite