hardened_copper_ingot:
  type: item
  material: feather
  display name: <&r>Hardened Copper Ingot
  mechanisms:
    custom_model_data: 10001
  lore:
    - <&r>Its almost iron!!
  data:
      recipe_book_category: misc.hardened_copper.ingot
  recipes:
    1:
      type: furnace
      cook_time: 120s
      experience: 0.25
      input: hardened_copper
    2:
      type: blast
      cook_time: 60s
      experience: 0.15
      input: hardened_copper

hardened_copper_block:
  type: item
  material: feather
  display name: <&r>Hardened Copper Block
  mechanisms:
    custom_model_data: 10002
  data:
    recipe_book_category: blocks.hardened_copper_block1
  recipes:
    1:
      type: shaped
      input:
        - hardened_copper_ingot|hardened_copper_ingot|hardened_copper_ingot
        - hardened_copper_ingot|air|hardened_copper_ingot
        - hardened_copper_ingot|hardened_copper_ingot|hardened_copper_ingot
    2:
      type: shapeless
      input: compressed_hardened_copper_block
      output_quantity: 9

compressed_hardened_copper_block:
  type: item
  material: feather
  display name: <&f>Compressed Hardened Copper Block
  mechanisms:
    custom_model_data: 10002
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 Hardened Copper Block"
  data:
    recipe_book_category: blocks.hardened_copper_block1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_hardened_copper_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - hardened_copper_block|hardened_copper_block|hardened_copper_block
      - hardened_copper_block|hardened_copper_block|hardened_copper_block
      - hardened_copper_block|hardened_copper_block|hardened_copper_block

double_compressed_hardened_copper_block:
  type: item
  material: feather
  display name: <&f>Double Compressed Hardened Copper Block
  mechanisms:
    custom_model_data: 10002
    hides: ENCHANTS
  enchantments:
  - sharpness:2
  lore:
    - "<&7>81 Hardened Copper Blocks"
  data:
    recipe_book_category: blocks.hardened_copper_block2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_hardened_copper_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_hardened_copper_block|compressed_hardened_copper_block|compressed_hardened_copper_block
      - compressed_hardened_copper_block|compressed_hardened_copper_block|compressed_hardened_copper_block
      - compressed_hardened_copper_block|compressed_hardened_copper_block|compressed_hardened_copper_block

triple_compressed_hardened_copper_block:
  type: item
  material: feather
  display name: <&f>Triple Compressed Hardened Copper Block
  mechanisms:
    custom_model_data: 10002
    hides: ENCHANTS
  enchantments:
  - sharpness:3
  lore:
    - "<&7>729 Hardened Copper Blocks"
  data:
    recipe_book_category: blocks.hardened_copper_block3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_hardened_copper_block
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_hardened_copper_block|double_compressed_hardened_copper_block|double_compressed_hardened_copper_block
      - double_compressed_hardened_copper_block|double_compressed_hardened_copper_block|double_compressed_hardened_copper_block
      - double_compressed_hardened_copper_block|double_compressed_hardened_copper_block|double_compressed_hardened_copper_block

quadruple_compressed_hardened_copper_block:
  type: item
  material: feather
  display name: <&f>Quadruple Compressed Hardened Copper Block
  mechanisms:
    custom_model_data: 10002
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - "<&7>6561 Hardened Copper Blocks"
  data:
    recipe_book_category: blocks.hardened_copper_block4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_hardened_copper_block|triple_compressed_hardened_copper_block|triple_compressed_hardened_copper_block
      - triple_compressed_hardened_copper_block|triple_compressed_hardened_copper_block|triple_compressed_hardened_copper_block
      - triple_compressed_hardened_copper_block|triple_compressed_hardened_copper_block|triple_compressed_hardened_copper_block
