skin_unlock_light_diamond_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Light Diamond Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 26
    color: <color[#1A03FD]>
  data:
    recipe_book_category: gadgets.light_diamond
  flags:
    right_click_script: item_skin_unlock
    armor: <list[light_diamond]>
    tools: <list[sword.diamond_dagger|axe.diamond_hatchet|shovel.diamond_pitchfork|pickaxe.diamond_mallet|hoe.diamond_sickle]>
  recipes:
    1:
      type: shaped
      input:
      - compressed_diamond_block|compressed_diamond_block|compressed_diamond_block
      - compressed_diamond_block|chest|compressed_diamond_block
      - compressed_diamond_block|compressed_diamond_block|compressed_diamond_block
