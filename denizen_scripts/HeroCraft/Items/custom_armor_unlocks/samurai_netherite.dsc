skin_unlock_samurai_netherite_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Samurai Netherite Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 36
    color: <color[#2503FD]>
  data:
    recipe_book_category: gadgets.samurai_netherite
  flags:
    right_click_script: item_skin_unlock
    armor: <list[samurai_netherite]>
    tools: <list[sword.netherite_katana|axe.netherite_ono|shovel.netherite_spade|hoe.netherite_kama]>
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_netherite_ingot|triple_compressed_netherite_ingot|triple_compressed_netherite_ingot
      - triple_compressed_netherite_ingot|samurai_headband|triple_compressed_netherite_ingot
      - triple_compressed_netherite_ingot|triple_compressed_netherite_ingot|triple_compressed_netherite_ingot
