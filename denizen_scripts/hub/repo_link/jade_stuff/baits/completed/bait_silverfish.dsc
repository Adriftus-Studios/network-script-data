fishing_bait_silverfish:
  type: item
  material: amethyst_shard
  display name: <&F>Silverfish Bait
  lore:
  - <&6>Increases chance to <&e>catch fish <&6>by <&e>14<&pc><&6>.
  - <&sp>
  - <&6>Jade Level<&co> <&e>31
  mechanisms:
    custom_model_data: 12
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_silverfish_item|fishing_bait_silverfish_item|fishing_bait_silverfish_item
      - fishing_bait_silverfish_item|fishing_bait_hook|fishing_bait_silverfish_item
      - fishing_bait_silverfish_item|fishing_bait_silverfish_item|fishing_bait_silverfish_item


fishing_bait_silverfish_item:
  type: item
  debug: false
  material: amethyst_shard
  display name: <&F>Silverfish
  lore:
  - <&6>Wily little feller.
  mechanisms:
    custom_model_data: 13


fishing_bait_silverfish_giver:
  type: world
  debug: false
  events:
    on player kills silverfish chance:5:
      - drop <context.entity.location> fishing_bait_silverfish_item
