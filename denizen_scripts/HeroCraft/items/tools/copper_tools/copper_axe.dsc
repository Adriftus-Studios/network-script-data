copper_axe:
  type: item
  material: iron_axe
  flags:
    custom_durability:
      max: 200
      current: 0
  lore:
    - Softer than iron
  data:
    recipe_book_category: tools.copper.axe
  mechanisms:
    custom_model_data: 1
  display name: <&f>Copper Axe
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - copper_ingot|copper_ingot|air
      - copper_ingot|stick|air
      - air|stick|air

