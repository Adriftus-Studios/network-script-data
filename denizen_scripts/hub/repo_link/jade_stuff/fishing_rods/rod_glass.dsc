fishing_rod_glass:
  type: item
  material: fishing_rod
  display name: <&f>Glass Fishing Rod
  lore:
  - <&6>A light weight rod.
  - <&sp>
  - <&e>Increases fish catch rate by 50<&pc>.
  - <&6>Jade Level<&co> <&e>40
  mechanisms:
      custom_model_data: 4
  flags:
    durability: 128
    trips: 25
  recipes:
    1:
      type: shaped
      input:
      - air|air|glass
      - air|glass|fishing_rod_line
      - glass|air|fishing_rod_line
