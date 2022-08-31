skin_unlock_pirate_diamond_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Pirate Diamond Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 31
    color: <color[#2003FD]>
  data:
    recipe_book_category: gadgets.pirate_diamond
  flags:
    right_click_script: item_skin_unlock
    armor: <list[pirate_diamond]>
    tools: <list[sword.diamond_cutlass]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_diamond_block|triple_compressed_diamond_block|triple_compressed_diamond_block
      - triple_compressed_diamond_block|pirate_eye_patch|triple_compressed_diamond_block
      - triple_compressed_diamond_block|triple_compressed_diamond_block|triple_compressed_diamond_block
