Amethyst_shovel:
  type: item
  material: diamond_shovel
  flags:
    custom_durability:
      max: 400
      current: 0
  lore:
    - Far more brittle than diamond.
  data:
    recipe_book_category: tools.Amethyst.shovel
  mechanisms:
    custom_model_data: 100
  display name: <&f>Amethyst Shovel
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - air|Amethyst_ingot|air
      - air|stick|air
      - air|stick|air

