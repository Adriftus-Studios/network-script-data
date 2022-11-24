dispenser_instrument_Chime:
  type: item
  material: feather
  mechanisms:
    custom_model_data: 2007
  display name: <&b>Chimes
  flags:
    custom_dispense: note
    pitch: 0.5
    instrument: Chime
  lore:
  - <&6>Current Pitch<&co> <&e>F♯ <&6>(<&e>0.5<&6>)
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
        - stick|string|stick
        - iron_ingot|Gold_ingot|iron_ingot
        - iron_ingot|Gold_ingot|iron_ingot
  data:
    recipe_book_category: decor.instrument.chimes
