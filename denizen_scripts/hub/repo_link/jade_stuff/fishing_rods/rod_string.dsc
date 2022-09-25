fishing_rod_line:
  type: item
  material: fishing_rod
  display name: <&f>Fishing Line
  lore:
  - <&6>A very durable string
  - <&sp>
  - <&6>Jade Level<&co> <&e>0
  mechanisms:
    custom_model_data: 1
  flags:
    durability: 32
    trips: 6
  recipes:
    1:
      type: shaped
      input:
      - air|air|string
      - air|string|air
      - string|air|air
