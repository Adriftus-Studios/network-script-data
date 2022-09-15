skin_unlock_medium_iron_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Medium Iron Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 15
    color: <color[#0F03FD]>
  data:
    recipe_book_category: gadgets.medium_iron
  flags:
    right_click_script: item_skin_unlock
    armor: <list[medium_iron]>
    tools: <list[sword.iron_broadsword|axe.iron_broadaxe|shovel.iron_trencher|pickaxe.iron_mattock|hoe.iron_handscythe]>
  recipes:
    1:
      type: shaped
      input:
      - double_compressed_iron_block|double_compressed_iron_block|double_compressed_iron_block
      - double_compressed_iron_block|chest|double_compressed_iron_block
      - double_compressed_iron_block|double_compressed_iron_block|double_compressed_iron_block
