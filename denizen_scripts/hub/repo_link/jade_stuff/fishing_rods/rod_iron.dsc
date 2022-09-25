fishing_rod_iron:
  type: item
  material: fishing_rod
  display name: <&f>Iron Reinforced Rod
  lore:
  - <&6>A heavy duty fishing rod
  - <&sp>
  - <&6>Jade Level<&co> <&e>20
  mechanisms:
      custom_model_data: 2
  flags:
    durability: 150
    trips: 30
  recipes:
    1:
      type: shaped
      input:
      - air|air|iron_ingot
      - air|iron_ingot|fishing_rod_line
      - iron_ingot|air|fishing_rod_line
