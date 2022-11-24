dispenser_visual_confetti_charge:
  type: item
  debug: false
  material: snowball
  display name: <&6>Confetti Charge
  lore:
  - <&e>Make an entrance!
  data:
    recipe_book_category: decor.confetti_charge
  mechanisms:
    custom_model_data: 1
  flags:
    custom_dispense: confetti

  recipes:
    1:
      type: shapeless
      output_quantity: 1
      input: confetti_ball|fire_charge

