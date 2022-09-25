fishing_bait_worm:
  type: item
  material: amethyst_shard
  display name: <&F>Worm Bait
  lore:
  - <&6>Increases <&e>fishing rolls <&6>by <&e>2<&pc><&6>.
  - <&sp>
  - <&6>Jade Level<&co> <&e>0
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_earthworm_item|fishing_bait_earthworm_item|fishing_bait_earthworm_item
      - fishing_bait_earthworm_item|fishing_bait_hook|fishing_bait_earthworm_item
      - fishing_bait_earthworm_item|fishing_bait_earthworm_item|fishing_bait_earthworm_item
  mechanisms:
    custom_model_data: 1

fishing_bait_earthworm_item:
  type: item
  material: amethyst_shard
  display name: <&f>Earthworm
  lore:
  - <&6>Fish love these!
  mechanisms:
    custom_model_data: 2

worm_item_giver:
  type: world
  debug: false
  events:
    on player breaks dirt|coarse_dirt|podzol|mycelium|grass_block chance:5:
      - drop <context.location> fishing_bait_earthworm_item
