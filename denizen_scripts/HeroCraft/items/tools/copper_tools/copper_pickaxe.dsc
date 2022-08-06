copper_pickaxe:
  type: item
  material: iron_pickaxe
  flags:
    custom_durability:
      max: 200
      current: 0
  mechanisms:
    custom_model_data: 2
  lore:
    - Softer than iron
  data:
    recipe_book_category: tools.copper.pickaxe
  display name: <&f>Copper Pickaxe
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - copper_ingot|copper_ingot|copper_ingot
      - air|stick|air
      - air|stick|air

