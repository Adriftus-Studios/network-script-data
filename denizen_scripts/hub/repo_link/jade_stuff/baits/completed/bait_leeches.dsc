fishing_bait_leech:
  type: item
  material: amethyst_shard
  display name: <&F>Leech Bait
  lore:
  - <&6>Increases <&e>fishing rolls <&6>by <&e>5<&pc><&6>.
  - <&sp>
  - <&6>Jade Level<&co> <&e>5
  mechanisms:
    custom_model_data: 3
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_leech_item|fishing_bait_leech_item|fishing_bait_leech_item
      - fishing_bait_leech_item|fishing_bait_hook|fishing_bait_leech_item
      - fishing_bait_leech_item|fishing_bait_leech_item|fishing_bait_leech_item

fishing_bait_leech_item:
  type: item
  debug: false
  material: amethyst_shard
  display name: <&F>Leech
  lore:
  - <&6>Nasty little suckers.
  mechanisms:
    custom_model_data: 4

fishing_bait_leech_giver:
  type: world
  debug: false
  events:
    on player kills salmon|cod|squid|turtle chance:10:
      - drop <context.entity.location> fishing_bait_leech_item



