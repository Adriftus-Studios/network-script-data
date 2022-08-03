uncompressed_clay:
  type: item
  material: clay
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_clay
      output_quantity: 9

compressed_clay:
  type: item
  material: clay
  display name: <&f>Compressed Clay
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Clay"
  data:
    recipe_book_category: blocks.clay1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_clay
      output_quantity: 9
    2:
      type: shaped
      input:
      - clay|clay|clay
      - clay|clay|clay
      - clay|clay|clay

double_compressed_clay:
  type: item
  material: clay
  display name: <&f>Double Compressed Clay
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>81 Clay"
  data:
    recipe_book_category: blocks.clay2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_clay
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_clay|compressed_clay|compressed_clay
      - compressed_clay|compressed_clay|compressed_clay
      - compressed_clay|compressed_clay|compressed_clay

triple_compressed_clay:
  type: item
  material: clay
  display name: <&f>Triple Compressed Clay
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>729 Clay"
  data:
    recipe_book_category: blocks.clay3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_clay
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_clay|double_compressed_clay|double_compressed_clay
      - double_compressed_clay|double_compressed_clay|double_compressed_clay
      - double_compressed_clay|double_compressed_clay|double_compressed_clay

quadruple_compressed_clay:
  type: item
  material: clay
  display name: <&f>Quadruple Compressed Clay
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>6561 Clay"
  data:
    recipe_book_category: blocks.clay4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_clay|triple_compressed_clay|triple_compressed_clay
      - triple_compressed_clay|triple_compressed_clay|triple_compressed_clay
      - triple_compressed_clay|triple_compressed_clay|triple_compressed_clay