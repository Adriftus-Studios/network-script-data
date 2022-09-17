skin_unlock_pirate_gold_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Pirate Gold Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 25
    color: <color[#1903FD]>
  data:
    recipe_book_category: gadgets.pirate_gold
  flags:
    right_click_script: item_skin_unlock
    armor: <list[pirate_gold]>
    tools: <list[sword.gold_cutlass]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_gold_block|triple_compressed_gold_block|triple_compressed_gold_block
      - triple_compressed_gold_block|pirate_eye_patch|triple_compressed_gold_block
      - triple_compressed_gold_block|triple_compressed_gold_block|triple_compressed_gold_block
