fishing_rod_magnetic:
  type: item
  material: fishing_rod
  display name: <&f>Magnetic Fishing Rod
  lore:
  - <&6>A heavy weight rod.
  - <&sp>
  - <&e>Increases item catch rate by 50<&pc>.
  - <&6>Jade Level<&co> <&e>50
  mechanisms:
      custom_model_data: 5
  flags:
    durability: 128
    trips: 25
  recipes:
    1:
      type: shaped
      input:
      - air|air|iron_ingot
      - air|iron_ingot|fishing_rod_redstone_line
      - iron_ingot|air|fishing_rod_redstone_line
