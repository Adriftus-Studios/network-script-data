Amethyst_sword:
  type: item
  material: diamond_sword
  flags:
    custom_durability:
      max: 400
      current: 0
  display name: <&f>Amethyst Sword
  data:
    recipe_book_category: tools.Amethyst.sword
  mechanisms:
    custom_model_data: 100
  lore:
    - Far more brittle than diamond.
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - air|Amethyst_ingot|air
      - air|Amethyst_ingot|air
      - air|stick|air

