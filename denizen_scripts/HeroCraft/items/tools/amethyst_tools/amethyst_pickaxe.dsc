Amethyst_pickaxe:
  type: item
  material: diamond_pickaxe
  flags:
    custom_durability:
      max: 400
      current: 0
  mechanisms:
    custom_model_data: 100
  lore:
    - <&r>Far more brittle than diamond.
  data:
    recipe_book_category: tools.amethyst.pickaxe
  display name: <&f>Amethyst Pickaxe
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - amethyst_ingot|amethyst_ingot|amethyst_ingot
      - air|stick|air
      - air|stick|air

