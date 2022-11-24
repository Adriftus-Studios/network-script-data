dispenser_instrument_flute:
  type: item
  material: feather
  mechanisms:
    custom_model_data: 2008
  display name: <&b>Flute
  flags:
    custom_dispense: note
    pitch: 0.5
    instrument: flute
  lore:
  - <&6>Current Pitch<&co> <&e>F♯ <&6>(<&e>0.5<&6>)
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
        - stick|blackstone_button|air
        - stick|stone_button|air
        - stick|blackstone_button|air
  data:
    recipe_book_category: decor.instrument.flute
