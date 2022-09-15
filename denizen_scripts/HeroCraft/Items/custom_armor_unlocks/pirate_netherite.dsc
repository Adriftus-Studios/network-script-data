skin_unlock_pirate_netherite_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Pirate Netherite Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 37
    color: <color[#2603FD]>
  data:
    recipe_book_category: gadgets.pirate_netherite
  flags:
    right_click_script: item_skin_unlock
    armor: <list[pirate_netherite]>
    tools: <list[sword.netherite_cutlass]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_netherite_ingot|triple_compressed_netherite_ingot|triple_compressed_netherite_ingot
      - triple_compressed_netherite_ingot|pirate_eye_patch|triple_compressed_netherite_ingot
      - triple_compressed_netherite_ingot|triple_compressed_netherite_ingot|triple_compressed_netherite_ingot
