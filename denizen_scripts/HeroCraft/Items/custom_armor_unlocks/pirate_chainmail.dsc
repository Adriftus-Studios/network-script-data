skin_unlock_pirate_chainmail_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Pirate Chainmail Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 13
    color: <color[#0D03FD]>
  data:
    recipe_book_category: gadgets.pirate_chainmail
  flags:
    right_click_script: item_skin_unlock
    armor: <list[pirate_chainmail]>
    tools: <list[sword.stone_cutlass]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_iron_ingot|triple_compressed_iron_ingot|triple_compressed_iron_ingot
      - triple_compressed_iron_ingot|pirate_eye_patch|triple_compressed_iron_ingot
      - triple_compressed_iron_ingot|triple_compressed_iron_ingot|triple_compressed_iron_ingot
