dispenser_instrument_Pling:
  type: item
  material: feather
  mechanisms:
    custom_model_data: 2012
  display name: <&b>Pling
  flags:
    custom_dispense: note
    pitch: 0.5
    instrument: Pling
  lore:
  - <&6>Current Pitch<&co> <&e>F♯ <&6>(<&e>0.5<&6>)
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
        - string|string|string
        - bone_block|obsidian|bone_block
        - oak_log/spruce_log/birch_log/jungle_log/acacia_log/dark_oak_log/crimson_log/warped_log|oak_log/spruce_log/birch_log/jungle_log/acacia_log/dark_oak_log/crimson_log/warped_log|oak_log/spruce_log/birch_log/jungle_log/acacia_log/dark_oak_log/crimson_log/warped_log
  data:
    recipe_book_category: decor.instrument.pling
