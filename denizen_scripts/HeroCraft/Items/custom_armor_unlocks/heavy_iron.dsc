skin_unlock_heavy_iron_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Heavy Iron Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 16
    color: <color[#1003FD]>
  data:
    recipe_book_category: gadgets.heavy_iron
  flags:
    right_click_script: item_skin_unlock
    armor: <list[heavy_iron]>
    tools: <list[sword.iron_greatsword|axe.iron_battleaxe|pickaxe.iron_sledge]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_iron_block|triple_compressed_iron_block|triple_compressed_iron_block
      - triple_compressed_iron_block|chest|triple_compressed_iron_block
      - triple_compressed_iron_block|triple_compressed_iron_block|triple_compressed_iron_block
