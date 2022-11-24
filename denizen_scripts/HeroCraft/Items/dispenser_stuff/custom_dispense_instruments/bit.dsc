dispenser_instrument_bit:
  type: item
  material: feather
  mechanisms:
    custom_model_data: 2015
  display name: <&b>Bit
  flags:
    custom_dispense: note
    pitch: 0.5
    instrument: bit
  lore:
  - <&6>Current Pitch<&co> <&e>F♯ <&6>(<&e>0.5<&6>)
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
        - white_wool/orange_wool/magenta_wool/light_blue_wool/yellow_wool/lime_wool/pink_wool/gray_wool/light_gray_wool/cyan_wool/purple_wool/blue_wool/brown_wool/green_wool/red_wool/black_wool|redstone_block|white_wool/orange_wool/magenta_wool/light_blue_wool/yellow_wool/lime_wool/pink_wool/gray_wool/light_gray_wool/cyan_wool/purple_wool/blue_wool/brown_wool/green_wool/red_wool/black_wool
        - stone_button|blackstone_button|stone_button
        - redstone|redstone|steel_ingot
  data:
    recipe_book_category: decor.instrument.bit
