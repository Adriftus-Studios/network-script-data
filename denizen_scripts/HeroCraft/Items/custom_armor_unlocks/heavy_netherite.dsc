skin_unlock_heavy_netherite_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Heavy Netherite Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 34
    color: <color[#2303FD]>
  data:
    recipe_book_category: gadgets.heavy_netherite
  flags:
    right_click_script: item_skin_unlock
    armor: <list[heavy_netherite]>
    tools: <list[sword.netherite_greatsword|axe.netherite_battleaxe|pickaxe.netherite_sledge]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_netherite_ingot|triple_compressed_netherite_ingot|triple_compressed_netherite_ingot
      - triple_compressed_netherite_ingot|chest|triple_compressed_netherite_ingot
      - triple_compressed_netherite_ingot|triple_compressed_netherite_ingot|triple_compressed_netherite_ingot
