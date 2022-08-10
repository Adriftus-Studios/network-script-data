Steel_hoe:
  type: item
  material: iron_hoe
  flags:
    custom_durability:
      max: 469
      current: 0
  data:
    recipe_book_category: tools.Steel.hoe
  mechanisms:
    custom_model_data: 2
  lore:
    - <&r>Tougher than iron.
  display name: <&f>Steel Hoe
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - Steel_ingot|Steel_ingot|air
      - air|stick|air
      - air|stick|air
    2:
      type: shaped
      output_quantity: 1
      input:
      - air|Steel_ingot|Steel_ingot
      - air|stick|air
      - air|stick|air

