skin_unlock_pirate_iron_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Pirate Iron Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 19
    color: <color[#1303FD]>
  data:
    recipe_book_category: gadgets.pirate_iron
  flags:
    right_click_script: item_skin_unlock
    armor: <list[pirate_iron]>
    tools: <list[sword.iron_cutlass]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_iron_block|triple_compressed_iron_block|triple_compressed_iron_block
      - triple_compressed_iron_block|pirate_eye_patch|triple_compressed_iron_block
      - triple_compressed_iron_block|triple_compressed_iron_block|triple_compressed_iron_block
