fishing_rod_golden:
  type: item
  material: fishing_rod
  display name: <&7>Golden Fishing Rod
  lore:
  - <&6>The blank of this rod drips with opulence.
  - <&sp>
  - <&e>1<&pc> chance to catch a key each cast.
  - <&6>Jade Level<&co> <&e>70
  mechanisms:
      custom_model_data: 7
  flags:
    durability: 100
    trips: 20
  recipes:
    1:
      type: shaped
      input:
      - air|air|gold_ingot
      - air|gold_ingot|fishing_rod_lapis_line
      - gold_ingot|air|fishing_rod_lapis_line
