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
    - Far more brittle than diamond.
  data:
    recipe_book_category: tools.Amethyst.pickaxe
  display name: <&f>Amethyst Pickaxe
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - Amethyst_ingot|Amethyst_ingot|Amethyst_ingot
      - air|stick|air
      - air|stick|air

