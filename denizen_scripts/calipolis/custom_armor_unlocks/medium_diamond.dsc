skin_unlock_medium_diamond_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Medium Diamond Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 27
    color: <color[#1B03FD]>
  data:
    recipe_book_category: gadgets.medium_diamond
  flags:
    right_click_script: item_skin_unlock
    armor: <list[medium_diamond]>
    tools: <list[sword.diamond_broadsword|axe.diamond_broadaxe|shovel.diamond_trencher|pickaxe.diamond_mattock|hoe.diamond_handscythe]>
  recipes:
    1:
      type: shaped
      input:
      - double_compressed_diamond_block|double_compressed_diamond_block|double_compressed_diamond_block
      - double_compressed_diamond_block|chest|double_compressed_diamond_block
      - double_compressed_diamond_block|double_compressed_diamond_block|double_compressed_diamond_block
