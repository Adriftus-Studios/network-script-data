steel_sword:
  type: item
  material: iron_sword
  flags:
    custom_durability:
      max: 469
      current: 0
  display name: <&f>Steel Sword
  data:
    recipe_book_category: tools.steel.sword
  mechanisms:
    custom_model_data: 2
  lore:
    - <&r>Tougher than iron.
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - air|steel_ingot|air
      - air|steel_ingot|air
      - air|stick|air

