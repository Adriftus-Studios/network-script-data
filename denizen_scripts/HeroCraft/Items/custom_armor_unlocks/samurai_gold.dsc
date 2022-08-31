skin_unlock_samurai_gold_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Samurai Gold Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 24
    color: <color[#1803FD]>
  data:
    recipe_book_category: gadgets.samurai_gold
  flags:
    right_click_script: item_skin_unlock
    armor: <list[samurai_gold]>
    tools: <list[sword.golden_katana|axe.golden_ono|shovel.golden_spade|hoe.golden_kama]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_golden_block|triple_compressed_golden_block|triple_compressed_golden_block
      - triple_compressed_golden_block|samurai_headband|triple_compressed_golden_block
      - triple_compressed_golden_block|triple_compressed_golden_block|triple_compressed_golden_block
