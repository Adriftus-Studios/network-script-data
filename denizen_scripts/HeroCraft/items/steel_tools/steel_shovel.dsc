steel_shovel:
  type: item
  material: iron_shovel
  flags:
    custom_durability:
      max: 469
      current: 0
  lore:
    - Tougher than iron
  data:
    recipe_book_category: tools.Steel.shovel
  mechanisms:
    custom_model_data: 2
  display name: <&f>Steel Shovel
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - air|steel_ingot|air
      - air|stick|air
      - air|stick|air

