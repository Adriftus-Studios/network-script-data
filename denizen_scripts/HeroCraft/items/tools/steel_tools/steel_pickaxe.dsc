steel_pickaxe:
  type: item
  material: iron_pickaxe
  flags:
    custom_durability:
      max: 469
      current: 0
  mechanisms:
    custom_model_data: 3
  lore:
    - <&r>Tougher than iron.
  data:
    recipe_book_category: tools.steel.pickaxe
  display name: <&f>Steel Pickaxe
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - steel_ingot|steel_ingot|steel_ingot
      - air|stick|air
      - air|stick|air

