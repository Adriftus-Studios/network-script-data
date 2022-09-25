fishing_bait_gilded:
  type: item
  material: amethyst_shard
  display name: <&F>Gilded Worm Bait
  lore:
  - <&6>Increases chance to catch <&e>legendary fish <&6>to <&e>0.5<&pc><&6>.
  - <&sp>
  - <&6>Jade Level<&co> <&e>25
  mechanisms:
    custom_model_data: 10
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_gilded_worm_item|fishing_bait_gilded_worm_item|fishing_bait_gilded_worm_item
      - fishing_bait_gilded_worm_item|fishing_bait_hook|fishing_bait_gilded_worm_item
      - fishing_bait_gilded_worm_item|fishing_bait_gilded_worm_item|fishing_bait_gilded_worm_item

fishing_bait_gilded_worm_item:
  type: item
  material: amethyst_shard
  display name: <&f>Gilded Worm
  lore:
  - <&6>Leaves a thin trail of gold behind it.
  mechanisms:
    custom_model_data: 11
  recipes:
    1:
      type: shaped
      input:
      - gold_ingot|gold_ingot|gold_ingot
      - gold_ingot|fishing_bait_earthworm_item|gold_ingot
      - gold_ingot|gold_ingot|gold_ingot
