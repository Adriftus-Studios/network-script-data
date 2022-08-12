steel_axe:
  type: item
  material: iron_axe
  flags:
    custom_durability:
      max: 469
      current: 0
  data:
    recipe_book_category: tools.steel.axe
  mechanisms:
    custom_model_data: 2
  lore:
    - <&r>Tougher than iron.
  display name: <&f>Steel Axe
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - steel_ingot|steel_ingot|air
      - steel_ingot|stick|air
      - air|stick|air
    2:
      type: shaped
      output_quantity: 1
      input:
      - air|steel_ingot|steel_ingot
      - air|stick|steel_ingot
      - air|stick|air
