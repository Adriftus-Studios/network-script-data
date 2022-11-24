dispenser_instrument_Hat:
  type: item
  material: feather
  mechanisms:
    custom_model_data: 2010
  display name: <&b>Hi Hat
  flags:
    custom_dispense: note
    pitch: 0.5
    instrument: Hat
  lore:
  - <&6>Current Pitch<&co> <&e>F♯ <&6>(<&e>0.5<&6>)
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
        - air|stone_button|air
        - copper_ingot|copper_block|copper_ingot
        - copper_ingot|copper_block|copper_ingot
  data:
    recipe_book_category: decor.instrument.hi_hat
