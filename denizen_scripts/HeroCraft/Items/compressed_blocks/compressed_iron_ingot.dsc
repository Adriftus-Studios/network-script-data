uncompressed_iron_ingot:
  type: item
  material: iron_ingot
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_iron_ingot
      output_quantity: 9

compressed_iron_ingot:
  type: item
  material: iron_ingot
  display name: <&f>Compressed Iron Ingot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Iron Ingot
  data:
    recipe_book_category: blocks.iron_ingot1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_iron_ingot
      output_quantity: 9

double_compressed_iron_ingot:
  type: item
  material: iron_ingot
  display name: <&f>Double Compressed Iron Ingot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Iron Ingot
  data:
    recipe_book_category: blocks.iron_ingot2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_iron_ingot
      output_quantity: 9

triple_compressed_iron_ingot:
  type: item
  material: iron_ingot
  display name: <&f>Triple Compressed Iron Ingot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Iron Ingot
  data:
    recipe_book_category: blocks.iron_ingot3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_iron_ingot
      output_quantity: 9

quadruple_compressed_iron_ingot:
  type: item
  material: iron_ingot
  display name: <&f>Quadruple Compressed Iron Ingot
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Iron Ingot
  data:
    recipe_book_category: blocks.iron_ingot4
  flags:
    on_place: cancel