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
    - Far more brittle than diamond.
  display name: <&f>Amethyst Axe
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - amethyst_ingot|amethyst_ingot|air
      - amethyst_ingot|stick|air
      - air|stick|air
