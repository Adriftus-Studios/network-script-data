skin_unlock_medium_chainmail_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Medium Chainmail Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 9
    color: <color[#0903FD]>
  data:
    recipe_book_category: gadgets.medium_chainmail
  flags:
    right_click_script: item_skin_unlock
    armor: <list[medium_chainmail]>
    tools: <list[sword.stone_broadsword|axe.stone_broadaxe|shovel.stone_trencher|pickaxe.stone_mattock|hoe.stone_handscythe]>
  recipes:
    1:
      type: shaped
      input:
      - double_compressed_iron_ingot|double_compressed_iron_ingot|double_compressed_iron_ingot
      - double_compressed_iron_ingot|chest|double_compressed_iron_ingot
      - double_compressed_iron_ingot|double_compressed_iron_ingot|double_compressed_iron_ingot
