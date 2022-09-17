skin_unlock_medium_netherite_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Medium Netherite Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 33
    color: <color[#2203FD]>
  data:
    recipe_book_category: gadgets.medium_netherite
  flags:
    right_click_script: item_skin_unlock
    armor: <list[medium_netherite]>
    tools: <list[sword.netherite_broadsword|axe.netherite_broadaxe|shovel.netherite_trencher|pickaxe.netherite_mattock|hoe.netherite_handscythe]>
  recipes:
    1:
      type: shaped
      input:
      - double_compressed_netherite_ingot|double_compressed_netherite_ingot|double_compressed_netherite_ingot
      - double_compressed_netherite_ingot|chest|double_compressed_netherite_ingot
      - double_compressed_netherite_ingot|double_compressed_netherite_ingot|double_compressed_netherite_ingot
