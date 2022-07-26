Steel_axe:
  type: item
  material: iron_axe
  flags:
    custom_durability:
      max: 469
      current: 0
  data:
    recipe_book_category: tools.Steel.axe
  mechanisms:
    custom_model_data: 2
  lore:
    - Tougher than iron
  display name: <&f>Steel Axe
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - Steel_ingot|Steel_ingot|air
      - Steel_ingot|stick|air
      - air|stick|air
