fishing_rod_netherite:
  type: item
  material: fishing_rod
  display name: <&F>Netherite Fishing Rod
  lore:
  - <&6>A rod bathed in lava. Tough enough to survive anything.
  - <&sp>
  - <&6>Jade Level<&co> <&e>80
  mechanisms:
      custom_model_data: 8
  flags:
    durability: 600
    trips: 120
  recipes:
    1:
      type: shaped
      input:
      - air|air|netherite_ingot
      - air|netherite_ingot|fishing_rod_redstone_line
      - netherite_ingot|air|fishing_rod_redstone_line
