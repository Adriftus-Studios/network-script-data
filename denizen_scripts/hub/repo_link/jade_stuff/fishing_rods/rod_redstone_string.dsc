fishing_rod_redstone_line:
  type: item
  material: fishing_rod
  display name: <&f>Redstone Encrusted Fishing Line
  lore:
  - <&6>A very durable string, coated in redstone
  recipes:
    1:
      type: shaped
      input:
      - redstone|fishing_rod_line|redstone
  mechanisms:
    custom_model_data: 11


redstone_line_canceller:
  debug: false
  type: world
  events:
    on player right clicks block with:fishing_rod_redstone_line:
      - determine passively cancelled
