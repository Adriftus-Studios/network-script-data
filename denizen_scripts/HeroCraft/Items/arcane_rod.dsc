arcane_rod:
  type: item
  debug: false
  display name: <&6>Arcane Rod
  material: prismarine_shard
  mechanisms:
    hides: ENCHANTS
    custom_model_data: 9000
  enchantments:
  - sharpness:1
  data:
      recipe_book_category: misc.arcane_rod
  lore:
  - <&6>A mysterious rod, made of elaborate materials.
  - <&8>Used to upgrade items.
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - double_compressed_netherite_ingot|double_compressed_diamond_block|air
      - double_compressed_diamond_block|arcane_core_item|air
      - air|air|double_compressed_netherite_ingot
