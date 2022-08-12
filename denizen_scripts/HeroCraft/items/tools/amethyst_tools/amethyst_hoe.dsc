Amethyst_hoe:
  type: item
  material: diamond_hoe
  flags:
    custom_durability:
      max: 400
      current: 0
  data:
    recipe_book_category: tools.amethyst.hoe
  mechanisms:
    custom_model_data: 100
  lore:
    - <&r>Far more brittle than diamond.
  display name: <&f>Amethyst Hoe
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - amethyst_ingot|amethyst_ingot|air
      - air|stick|air
      - air|stick|air
    2:
      type: shaped
      output_quantity: 1
      input:
      - air|amethyst_ingot|amethyst_ingot
      - air|stick|air
      - air|stick|air
