copper_sword:
  type: item
  material: iron_sword
  flags:
    custom_durability:
      max: 200
      current: 0
  display name: <&f>Copper Sword
  lore:
    - Softer than iron
  data:
    recipe_book_category: tools.copper.sword
  mechanisms:
    custom_model_data: 1
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - air|copper_ingot|air
      - air|copper_ingot|air
      - air|stick|air

