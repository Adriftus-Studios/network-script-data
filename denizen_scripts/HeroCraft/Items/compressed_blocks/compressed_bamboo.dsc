uncompressed_bamboo:
  type: item
  material: bamboo
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_bamboo
      output_quantity: 9

compressed_bamboo:
  type: item
  material: bamboo
  display name: <&f>Compressed Bamboo
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Bamboo"
  data:
    recipe_book_category: blocks.bamboo1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_bamboo
      output_quantity: 9
    2:
      type: shaped
      input:
      - bamboo|bamboo|bamboo
      - bamboo|bamboo|bamboo
      - bamboo|bamboo|bamboo

double_compressed_bamboo:
  type: item
  material: bamboo
  display name: <&f>Double Compressed Bamboo
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Bamboo"
  data:
    recipe_book_category: blocks.bamboo2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_bamboo
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_bamboo|compressed_bamboo|compressed_bamboo
      - compressed_bamboo|compressed_bamboo|compressed_bamboo
      - compressed_bamboo|compressed_bamboo|compressed_bamboo

triple_compressed_bamboo:
  type: item
  material: bamboo
  display name: <&f>Triple Compressed Bamboo
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Bamboo"
  data:
    recipe_book_category: blocks.bamboo3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_bamboo
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_bamboo|double_compressed_bamboo|double_compressed_bamboo
      - double_compressed_bamboo|double_compressed_bamboo|double_compressed_bamboo
      - double_compressed_bamboo|double_compressed_bamboo|double_compressed_bamboo

quadruple_compressed_bamboo:
  type: item
  material: bamboo
  display name: <&f>Quadruple Compressed Bamboo
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Bamboo"
  data:
    recipe_book_category: blocks.bamboo4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_bamboo|triple_compressed_bamboo|triple_compressed_bamboo
      - triple_compressed_bamboo|triple_compressed_bamboo|triple_compressed_bamboo
      - triple_compressed_bamboo|triple_compressed_bamboo|triple_compressed_bamboo