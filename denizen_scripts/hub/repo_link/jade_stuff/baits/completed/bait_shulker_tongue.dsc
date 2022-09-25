fishing_bait_shulker:
  type: item
  material: amethyst_shard
  display name: <&F>Shulker Eye Bait
  lore:
  - <&6>Increases chance to <&e>catch fish <&6>by <&e>18<&pc><&6>.
  - <&sp>
  - <&6>Jade Level<&co> <&e>61
  mechanisms:
    custom_model_data: 18
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_shulker_item|fishing_bait_shulker_item|fishing_bait_shulker_item
      - fishing_bait_shulker_item|fishing_bait_hook|fishing_bait_shulker_item
      - fishing_bait_shulker_item|fishing_bait_shulker_item|fishing_bait_shulker_item

fishing_bait_shulker_item:
  type: item
  debug: false
  material: amethyst_shard
  display name: <&F>Shulker Tongue
  lore:
  - <&6>Smells terrible.
  mechanisms:
    custom_model_data: 19

fishing_bait_shulker_giver:
  type: world
  debug: false
  events:
    on player kills shulker chance:10:
      - drop <context.entity.location> fishing_bait_shulker_item
