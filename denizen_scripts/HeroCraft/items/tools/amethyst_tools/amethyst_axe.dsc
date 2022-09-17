amethyst_axe:
  type: item
  material: diamond_axe
  flags:
    custom_durability:
      max: 400
      current: 0
  data:
    recipe_book_category: tools.amethyst.axe
  mechanisms:
    custom_model_data: 100
  lore:
    - <&r>Far more brittle than diamond.
  display name: <&f>Amethyst Axe
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - amethyst_ingot|amethyst_ingot|air
      - amethyst_ingot|stick|air
      - air|stick|air
    2:
      type: shaped
      output_quantity: 1
      input:
      - air|amethyst_ingot|amethyst_ingot
      - air|stick|amethyst_ingot
      - air|stick|air
