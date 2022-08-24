uncompressed_sand:
  type: item
  material: sand
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_sand
      output_quantity: 9

compressed_sand:
  type: item
  material: sand
  display name: <&f>Compressed Sand
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Sand"
  data:
    recipe_book_category: blocks.sand1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_sand
      output_quantity: 9
    2:
      type: shaped
      input:
      - sand|sand|sand
      - sand|sand|sand
      - sand|sand|sand

double_compressed_sand:
  type: item
  material: sand
  display name: <&f>Double Compressed Sand
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Sand"
  data:
    recipe_book_category: blocks.sand2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_sand
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_sand|compressed_sand|compressed_sand
      - compressed_sand|compressed_sand|compressed_sand
      - compressed_sand|compressed_sand|compressed_sand

triple_compressed_sand:
  type: item
  material: sand
  display name: <&f>Triple Compressed Sand
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Sand"
  data:
    recipe_book_category: blocks.sand3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_sand
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_sand|double_compressed_sand|double_compressed_sand
      - double_compressed_sand|double_compressed_sand|double_compressed_sand
      - double_compressed_sand|double_compressed_sand|double_compressed_sand

quadruple_compressed_sand:
  type: item
  material: sand
  display name: <&f>Quadruple Compressed Sand
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Sand"
  data:
    recipe_book_category: blocks.sand4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_sand|triple_compressed_sand|triple_compressed_sand
      - triple_compressed_sand|triple_compressed_sand|triple_compressed_sand
      - triple_compressed_sand|triple_compressed_sand|triple_compressed_sand