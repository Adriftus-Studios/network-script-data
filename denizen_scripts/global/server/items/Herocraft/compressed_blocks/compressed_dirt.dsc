uncompressed_dirt:
  type: item
  material: dirt
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_dirt
      output_quantity: 9

compressed_dirt:
  type: item
  material: dirt
  display name: <&f>Compressed Dirt
  lore:
    - "<&7>9 Dirt"
  data:
    recipe_book_category: blocks.dirt1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_dirt
      output_quantity: 9
    2:
      type: shaped
      input:
      - dirt|dirt|dirt
      - dirt|dirt|dirt
      - dirt|dirt|dirt

double_compressed_dirt:
  type: item
  material: dirt
  display name: <&f>Double Compressed Dirt
  lore:
    - "<&7>81 Dirt"
  data:
    recipe_book_category: blocks.dirt2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_dirt
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_dirt|compressed_dirt|compressed_dirt
      - compressed_dirt|compressed_dirt|compressed_dirt
      - compressed_dirt|compressed_dirt|compressed_dirt

triple_compressed_dirt:
  type: item
  material: dirt
  display name: <&f>Triple Compressed Dirt
  lore:
    - "<&7>729 Dirt"
  data:
    recipe_book_category: blocks.dirt3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_dirt
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_dirt|double_compressed_dirt|double_compressed_dirt
      - double_compressed_dirt|double_compressed_dirt|double_compressed_dirt
      - double_compressed_dirt|double_compressed_dirt|double_compressed_dirt

quadruple_compressed_dirt:
  type: item
  material: dirt
  display name: <&f>Quadruple Compressed Dirt
  lore:
    - "<&7>6561 Dirt"
  data:
    recipe_book_category: blocks.dirt4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_dirt|triple_compressed_dirt|triple_compressed_dirt
      - triple_compressed_dirt|triple_compressed_dirt|triple_compressed_dirt
      - triple_compressed_dirt|triple_compressed_dirt|triple_compressed_dirt