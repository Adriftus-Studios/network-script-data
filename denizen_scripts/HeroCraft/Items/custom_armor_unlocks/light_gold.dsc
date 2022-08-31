skin_unlock_light_gold_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Light Gold Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 20
    color: <color[#1403FD]>
  data:
    recipe_book_category: gadgets.light_gold
  flags:
    right_click_script: item_skin_unlock
    armor: <list[light_gold]>
    tools: <list[sword.gold_dagger|axe.gold_hatchet|shovel.gold_pitchfork|pickaxe.gold_mallet|hoe.gold_sickle]>
  recipes:
    1:
      type: shaped
      input:
      - compressed_gold_block|compressed_gold_block|compressed_gold_block
      - compressed_gold_block|chest|compressed_gold_block
      - compressed_gold_block|compressed_gold_block|compressed_gold_block
