skin_unlock_royal_gold_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Royal Gold Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 23
    color: <color[#1703FD]>
  data:
    recipe_book_category: gadgets.royal_gold
  flags:
    right_click_script: item_skin_unlock
    armor: <list[royal_gold]>
    tools: <list[sword.gold_spear|axe.gold_halberd|shovel.gold_warffork|pickaxe.gold_warhammer|hoe.gold_greatscythe|sword.gold_odachi]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_gold_block|triple_compressed_gold_block|triple_compressed_gold_block
      - triple_compressed_gold_block|royal_crest|triple_compressed_gold_block
      - triple_compressed_gold_block|triple_compressed_gold_block|triple_compressed_gold_block
