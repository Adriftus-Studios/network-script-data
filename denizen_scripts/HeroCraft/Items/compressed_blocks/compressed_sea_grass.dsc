uncompressed_sea_grass:
  type: item
  material: sea_grass
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_sea_grass
      output_quantity: 9

compressed_sea_grass:
  type: item
  material: sea_grass
  display name: <&f>Compressed Sea Grass
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Sea Grass"
  data:
    recipe_book_category: blocks.sea_grass1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_sea_grass
      output_quantity: 9
    2:
      type: shaped
      input:
      - sea_grass|sea_grass|sea_grass
      - sea_grass|sea_grass|sea_grass
      - sea_grass|sea_grass|sea_grass

double_compressed_sea_grass:
  type: item
  material: sea_grass
  display name: <&f>Double Compressed Sea Grass
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Sea Grass"
  data:
    recipe_book_category: blocks.sea_grass2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_sea_grass
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_sea_grass|compressed_sea_grass|compressed_sea_grass
      - compressed_sea_grass|compressed_sea_grass|compressed_sea_grass
      - compressed_sea_grass|compressed_sea_grass|compressed_sea_grass

triple_compressed_sea_grass:
  type: item
  material: sea_grass
  display name: <&f>Triple Compressed Sea Grass
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Sea Grass"
  data:
    recipe_book_category: blocks.sea_grass3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_sea_grass
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_sea_grass|double_compressed_sea_grass|double_compressed_sea_grass
      - double_compressed_sea_grass|double_compressed_sea_grass|double_compressed_sea_grass
      - double_compressed_sea_grass|double_compressed_sea_grass|double_compressed_sea_grass

quadruple_compressed_sea_grass:
  type: item
  material: sea_grass
  display name: <&f>Quadruple Compressed Sea Grass
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Sea Grass"
  data:
    recipe_book_category: blocks.sea_grass4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_sea_grass|triple_compressed_sea_grass|triple_compressed_sea_grass
      - triple_compressed_sea_grass|triple_compressed_sea_grass|triple_compressed_sea_grass
      - triple_compressed_sea_grass|triple_compressed_sea_grass|triple_compressed_sea_grass