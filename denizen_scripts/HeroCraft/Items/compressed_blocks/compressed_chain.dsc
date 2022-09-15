uncompressed_chain:
  type: item
  material: chain
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_chain
      output_quantity: 9

compressed_chain:
  type: item
  material: chain
  display name: <&f>Compressed Chains
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Chains
  data:
    recipe_book_category: blocks.chain1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_chain
      output_quantity: 9
    2:
      type: shaped
      input:
      - chain|chain|chain
      - chain|chain|chain
      - chain|chain|chain

double_compressed_chain:
  type: item
  material: chain
  display name: <&f>Double Compressed Chains
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Chains
  data:
    recipe_book_category: blocks.chain2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_chain
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_chain|compressed_chain|compressed_chain
      - compressed_chain|compressed_chain|compressed_chain
      - compressed_chain|compressed_chain|compressed_chain

triple_compressed_chain:
  type: item
  material: chain
  display name: <&f>Triple Compressed Chains
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Chains
  data:
    recipe_book_category: blocks.chain3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_chain
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_chain|double_compressed_chain|double_compressed_chain
      - double_compressed_chain|double_compressed_chain|double_compressed_chain
      - double_compressed_chain|double_compressed_chain|double_compressed_chain

quadruple_compressed_chain:
  type: item
  material: chain
  display name: <&f>Quadruple Compressed Chains
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Chains
  data:
    recipe_book_category: blocks.chain4
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_chain|triple_compressed_chain|triple_compressed_chain
      - triple_compressed_chain|triple_compressed_chain|triple_compressed_chain
      - triple_compressed_chain|triple_compressed_chain|triple_compressed_chain