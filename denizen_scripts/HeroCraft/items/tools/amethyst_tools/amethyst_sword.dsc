amethyst_sword:
  type: item
  material: diamond_sword
  flags:
    custom_durability:
      max: 400
      current: 0
  display name: <&f>Amethyst Sword
  data:
    recipe_book_category: tools.amethyst.sword
  mechanisms:
    custom_model_data: 100
  lore:
    - <&r>Far more brittle than diamond.
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - air|amethyst_ingot|air
      - air|amethyst_ingot|air
      - air|stick|air

