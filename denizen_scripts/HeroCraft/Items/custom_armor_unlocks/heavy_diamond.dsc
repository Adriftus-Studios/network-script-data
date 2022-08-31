skin_unlock_heavy_diamond_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Heavy Diamond Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 28
    color: <color[#1C03FD]>
  data:
    recipe_book_category: gadgets.heavy_diamond
  flags:
    right_click_script: item_skin_unlock
    armor: <list[heavy_diamond]>
    tools: <list[sword.diamond_greatsword|axe.diamond_battleaxe|pickaxe.diamond_sledge]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_diamond_block|triple_compressed_diamond_block|triple_compressed_diamond_block
      - triple_compressed_diamond_block|chest|triple_compressed_diamond_block
      - triple_compressed_diamond_block|triple_compressed_diamond_block|triple_compressed_diamond_block
