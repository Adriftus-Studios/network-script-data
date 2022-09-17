skin_unlock_medium_leather_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Medium Leather Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 2
    color: <color[#0203FD]>
  data:
    recipe_book_category: gadgets.medium_leather
  flags:
    right_click_script: item_skin_unlock
    armor: <list[medium_leather]>
    tools: <list[sword.wooden_broadsword|axe.wooden_broadaxe|shovel.wooden_trencher|pickaxe.wooden_mattock|hoe.wooden_handscythe]>
  recipes:
    1:
      type: shaped
      input:
      - double_compressed_leather|double_compressed_leather|double_compressed_leather
      - double_compressed_leather|chest|double_compressed_leather
      - double_compressed_leather|double_compressed_leather|double_compressed_leather
