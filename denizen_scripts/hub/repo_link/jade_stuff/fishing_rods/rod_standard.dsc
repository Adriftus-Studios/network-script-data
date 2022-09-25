fishing_rod_wood:
  type: item
  material: fishing_rod
  display name: <&f>Wooden Fishing Rod
  lore:
  - <&6> Your normal, every day rod
  - <&sp>
  - <&6>Jade Level<&co> <&e>10
  flags:
    durability: 64
    trips: 10
  recipes:
    1:
      type: shaped
      input:
      - air|air|stick
      - air|stick|fishing_rod_line
      - stick|air|fishing_rod_line
