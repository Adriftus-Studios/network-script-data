fishing_rod_lapis_line:
  type: item
  material: fishing_rod
  display name: <&f>Lapis Lazuli Encrusted Fishing Line
  lore:
  - <&6>A magical string, brimming with potential
  mechanisms:
    custom_model_data: 10
  recipes:
    1:
      type: shaped
      input:
      - lapis_lazuli|fishing_rod_redstone_line|lapis_lazuli

lapis_line_canceller:
  debug: false
  type: world
  events:
    on player right clicks block with:fishing_rod_lapis_line:
      - determine passively cancelled
