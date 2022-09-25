fishing_bait_blinding:
  type: item
  material: amethyst_shard
  display name: <&F>Blinding Shard Bait
  lore:
  - <&6>Increases chance to catch <&e>legendary fish <&6>to <&e>1.5<&pc><&6>.
  - <&sp>
  - <&6>Jade Level<&co> <&e>91
  mechanisms:
    custom_model_data: 24
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_blinding_shard_item|fishing_bait_blinding_shard_item|fishing_bait_blinding_shard_item
      - fishing_bait_blinding_shard_item|fishing_bait_hook|fishing_bait_blinding_shard_item
      - fishing_bait_blinding_shard_item|fishing_bait_blinding_shard_item|fishing_bait_blinding_shard_item

fishing_bait_blinding_shard_item:
  type: item
  material: amethyst_shard
  display name: <&f>Blinding Shard
  lore:
  - <&6>Emits a light that is painful to look at
  mechanisms:
    custom_model_data: 25
  recipes:
    1:
      type: shaped
      input:
      - shroomlight|fishing_bait_gilded_fragment_item|froglight
      - fishing_bait_gilded_fragment_item|conduit|fishing_bait_gilded_fragment_item
      - sea_lantern|fishing_bait_gilded_fragment_item|glowstone
