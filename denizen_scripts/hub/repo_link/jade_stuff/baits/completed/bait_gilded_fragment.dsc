fishing_bait_golden:
  type: item
  material: amethyst_shard
  display name: <&F>Golden Fragment Bait
  lore:
  - <&6>Increases chance to catch <&e>legendary fish <&6>to <&e>1<&pc><&6>.
  - <&sp>
  - <&6>Jade Level<&co> <&e>81
  mechanisms:
    custom_model_data: 22
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_gilded_fragment_item|fishing_bait_gilded_fragment_item|fishing_bait_gilded_fragment_item
      - fishing_bait_gilded_fragment_item|fishing_bait_hook|fishing_bait_gilded_fragment_item
      - fishing_bait_gilded_fragment_item|fishing_bait_gilded_fragment_item|fishing_bait_gilded_fragment_item

fishing_bait_gilded_fragment_item:
  type: item
  material: amethyst_shard
  display name: <&f>Golden Fragment
  lore:
  - <&6>Pulses with a strange energy
  mechanisms:
    custom_model_data: 23
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_shulker_item|gold_ingot|fishing_bait_shulker_item
      - gold_ingot|fishing_bait_mysterious_fragment_item|gold_ingot
      - fishing_bait_shulker_item|gold_ingot|fishing_bait_shulker_item
