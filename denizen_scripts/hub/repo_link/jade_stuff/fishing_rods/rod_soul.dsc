fishing_rod_soul:
  type: item
  material: fishing_rod
  display name: <&7>Soul Rod
  lore:
  - <&6>Powered by the countless souls trapped within.
  - <&sp>
  - <&e>Increases legendary catch rate by 100<&pc>.
  - <&6>Jade Level<&co> <&e>95
  mechanisms:
      custom_model_data: 9
  flags:
    durability: 400
    trips: 80
  recipes:
    1:
      type: shaped
      input:
      - air|air|end_rod
      - air|conduit|fishing_rod_lapis_line
      - end_rod|air|nether_star
