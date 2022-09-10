skin_unlock_pirate_leather_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Pirate Leather Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 6
    color: <color[#0603FD]>
  data:
    recipe_book_category: gadgets.pirate_leather
  flags:
    right_click_script: item_skin_unlock
    armor: <list[pirate_leather]>
    tools: <list[sword.wooden_cutlass]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_leather|triple_compressed_leather|triple_compressed_leather
      - triple_compressed_leather|pirate_eye_patch|triple_compressed_leather
      - triple_compressed_leather|triple_compressed_leather|triple_compressed_leather
