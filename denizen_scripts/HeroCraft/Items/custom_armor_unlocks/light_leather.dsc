skin_unlock_light_leather_item:
  type: item
  material: leather_helmet
  display name: <&b>COSMETIC<&co><&6> Light Leather Set
  lore:
  - <&e>Right Click while holding
  - <&b>Apply at Spawn!
  mechanisms:
    custom_model_data: 1
    color: <color[#0103FD]>
  data:
    recipe_book_category: gadgets.light_leather
  flags:
    right_click_script: item_skin_unlock
    armor: <list[light_leather]>
    tools: <list[sword.wooden_dagger|axe.wooden_hatchet|shovel.wooden_pitchfork|pickaxe.wooden_mallet|hoe.wooden_sickle]>
  recipes:
    1:
      type: shaped
      input:
      - compressed_leather|compressed_leather|compressed_leather
      - compressed_leather|chest|compressed_leather
      - compressed_leather|compressed_leather|compressed_leather
