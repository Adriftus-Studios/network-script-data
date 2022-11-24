dispenser_instrument_harp:
  type: item
  material: feather
  mechanisms:
    custom_model_data: 2009
  display name: <&b>Harp
  flags:
    custom_dispense: note
    pitch: 0.5
    instrument: Harp
  lore:
  - <&6>Current Pitch<&co> <&e>F♯ <&6>(<&e>0.5<&6>)
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
        - oak_log/spruce_log/birch_log/jungle_log/acacia_log/dark_oak_log/crimson_log/warped_log|oak_planks/spruce_planks/birch_planks/jungle_planks/acacia_planks/dark_oak_planks/crimson_planks/warped_planks|stick
        - oak_log/spruce_log/birch_log/jungle_log/acacia_log/dark_oak_log/crimson_log/warped_log|string|stick
        - oak_log/spruce_log/birch_log/jungle_log/acacia_log/dark_oak_log/crimson_log/warped_log|oak_planks/spruce_planks/birch_planks/jungle_planks/acacia_planks/dark_oak_planks/crimson_planks/warped_planks|stick
  data:
    recipe_book_category: decor.instrument.harp
