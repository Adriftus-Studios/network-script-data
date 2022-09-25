fishing_rod_light:
  type: item
  material: fishing_rod
  display name: <&f>Light Up Fishing Rod
  lore:
  - <&6>The blank of this rod glows softly.
  - <&sp>
  - <&e>Increases legendary catch rate by 50<&pc>.
  - <&6>Jade Level<&co> <&e>30
  mechanisms:
      custom_model_data: 3
  flags:
    durability: 128
    trips: 24
  recipes:
    1:
      type: shaped
      input:
      - air|air|glowstone/sea_lantern/redstone_lamp
      - air|glowstone/sea_lantern/redstone_lamp|fishing_rod_line
      - glowstone/sea_lantern/redstone_lamp|air|fishing_rod_line
