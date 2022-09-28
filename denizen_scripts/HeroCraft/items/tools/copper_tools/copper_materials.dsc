unhardened_copper_ingot:
  type: item
  material: copper_ingot
  no_id: true
  recipes:
    1:
      type: shapeless
      input: hardened_copper_ingot
      output_quantity: 1

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
