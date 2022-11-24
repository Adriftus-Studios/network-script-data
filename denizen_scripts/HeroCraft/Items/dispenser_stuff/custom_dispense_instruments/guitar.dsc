dispenser_instrument_Guitar:
  type: item
  material: feather
  mechanisms:
    custom_model_data: 2004
  display name: <&b>Guitar
  flags:
    custom_dispense: note
    pitch: 0.5
    instrument: Guitar
  lore:
  - <&6>Current Pitch<&co> <&e>F♯ <&6>(<&e>0.5<&6>)
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
        - air|stick|air
        - air|string|air
        - oak_planks/spruce_planks/birch_planks/jungle_planks/acacia_planks/dark_oak_planks/crimson_planks/warped_planks|oak_planks/spruce_planks/birch_planks/jungle_planks/acacia_planks/dark_oak_planks/crimson_planks/warped_planks|oak_planks/spruce_planks/birch_planks/jungle_planks/acacia_planks/dark_oak_planks/crimson_planks/warped_planks
  data:
    recipe_book_category: decor.instrument.guitar
