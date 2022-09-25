fishing_rod_diamond:
  type: item
  material: fishing_rod
  display name: <&F>Diamond Fishing Rod
  lore:
  - <&6>A remarkably strong fishing rod
  - <&sp>
  - <&6>Jade Level<&co> <&e>60
  mechanisms:
      custom_model_data: 6
  flags:
    durability_max: 400
    trips: 80
  recipes:
    1:
      type: shaped
      input:
      - air|air|diamond
      - air|diamond|fishing_rod_redstone_line
      - diamond|air|fishing_rod_redstone_line
