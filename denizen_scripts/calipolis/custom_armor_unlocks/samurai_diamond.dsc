skin_unlock_samurai_diamond_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Samurai Diamond Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 30
    color: <color[#1F03FD]>
  data:
    recipe_book_category: gadgets.samurai_diamond
  flags:
    right_click_script: item_skin_unlock
    armor: <list[samurai_diamond]>
    tools: <list[sword.diamond_katana|axe.diamond_ono|shovel.diamond_spade|hoe.diamond_kama]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_diamond_block|triple_compressed_diamond_block|triple_compressed_diamond_block
      - triple_compressed_diamond_block|samurai_headband|triple_compressed_diamond_block
      - triple_compressed_diamond_block|triple_compressed_diamond_block|triple_compressed_diamond_block
