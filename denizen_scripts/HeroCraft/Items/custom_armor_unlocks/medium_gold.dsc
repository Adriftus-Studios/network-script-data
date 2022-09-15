skin_unlock_medium_gold_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Medium Gold Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 21
    color: <color[#1503FD]>
  data:
    recipe_book_category: gadgets.medium_gold
  flags:
    right_click_script: item_skin_unlock
    armor: <list[medium_gold]>
    tools: <list[sword.gold_broadsword|axe.gold_broadaxe|shovel.gold_trencher|pickaxe.gold_mattock|hoe.gold_handscythe]>
  recipes:
    1:
      type: shaped
      input:
      - double_compressed_gold_block|double_compressed_gold_block|double_compressed_gold_block
      - double_compressed_gold_block|chest|double_compressed_gold_block
      - double_compressed_gold_block|double_compressed_gold_block|double_compressed_gold_block
