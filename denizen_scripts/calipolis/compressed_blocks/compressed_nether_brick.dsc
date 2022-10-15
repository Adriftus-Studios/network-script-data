uncompressed_nether_brick:
  type: item
  material: nether_brick
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_nether_brick
      output_quantity: 9

compressed_nether_brick:
  type: item
  material: nether_brick
  display name: <&f>Compressed Nether Brick
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Nether Brick"
  data:
    recipe_book_category: blocks.nether_brick1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_nether_brick
      output_quantity: 9
    2:
      type: shaped
      input:
      - nether_brick|nether_brick|nether_brick
      - nether_brick|nether_brick|nether_brick
      - nether_brick|nether_brick|nether_brick

double_compressed_nether_brick:
  type: item
  material: nether_brick
  display name: <&f>Double Compressed Nether Brick
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Nether Brick"
  data:
    recipe_book_category: blocks.nether_brick2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_nether_brick
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_nether_brick|compressed_nether_brick|compressed_nether_brick
      - compressed_nether_brick|compressed_nether_brick|compressed_nether_brick
      - compressed_nether_brick|compressed_nether_brick|compressed_nether_brick

triple_compressed_nether_brick:
  type: item
  material: nether_brick
  display name: <&f>Triple Compressed Nether Brick
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Nether Brick"
  data:
    recipe_book_category: blocks.nether_brick3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_nether_brick
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_nether_brick|double_compressed_nether_brick|double_compressed_nether_brick
      - double_compressed_nether_brick|double_compressed_nether_brick|double_compressed_nether_brick
      - double_compressed_nether_brick|double_compressed_nether_brick|double_compressed_nether_brick

quadruple_compressed_nether_brick:
  type: item
  material: nether_brick
  display name: <&f>Quadruple Compressed Nether Brick
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Nether Brick"
  data:
    recipe_book_category: blocks.nether_brick4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_nether_brick|triple_compressed_nether_brick|triple_compressed_nether_brick
      - triple_compressed_nether_brick|triple_compressed_nether_brick|triple_compressed_nether_brick
      - triple_compressed_nether_brick|triple_compressed_nether_brick|triple_compressed_nether_brick