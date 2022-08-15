diamond_horse_armor_alternative_recipe:
  type: item
  material: diamond_horse_armor
  no_id: true
  data:
    recipe_book_category: travel.horse_armor4
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - air|air|diamond_helmet
      - diamond|leather|diamond
      - diamond_leggings|air|diamond_leggings

golden_horse_armor_alternative_recipe:
  type: item
  material: golden_horse_armor
  no_id: true
  data:
    recipe_book_category: travel.horse_armor3
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - air|air|golden_helmet
      - gold_ingot|leather|gold_ingot
      - golden_leggings|air|golden_leggings

iron_horse_armor_alternative_recipe:
  type: item
  material: iron_horse_armor
  no_id: true
  data:
    recipe_book_category: travel.horse_armor2
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - air|air|iron_helmet
      - iron_ingot|leather|iron_ingot
      - iron_leggings|air|iron_leggings

saddle_alternative_recipe:
  type: item
  material: saddle
  data:
    recipe_book_category: travel.horse_armor0
  no_id: true
  recipes:
    1:
      type: shaped
      input:
      - leather|leather|leather
      - string|air|air
      - iron_ingot|air|iron_ingot
    2:
      type: shaped
      input:
      - leather|leather|leather
      - string|air|air
      - copper_ingot|air|copper_ingot
