fishing_bait_chum:
  type: item
  material: amethyst_shard
  display name: <&F>Chum Bait
  lore:
  - <&6>Increases chance to <&e>catch fish <&6>by <&e>10<&pc><&6>.
  - <&sp>
  - <&6>Jade Level<&co> <&e>16
  mechanisms:
    custom_model_data: 6
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_chum_item|fishing_bait_chum_item|fishing_bait_chum_item
      - fishing_bait_chum_item|fishing_bait_hook|fishing_bait_chum_item
      - fishing_bait_chum_item|fishing_bait_chum_item|fishing_bait_chum_item


fishing_bait_chum_item:
  type: item
  debug: false
  material: amethyst_shard
  display name: <&F>Fish Chunks
  lore:
  - <&6>Slimy and smells terrible.
  mechanisms:
    custom_model_data: 7
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: fishing_bait_leech_item|fishing_bait_leech_item|fishing_bait_leech_item

fishing_bait_chum_giver:
  type: world
  debug: false
  events:
    on player kills salmon|cod|squid|turtle chance:2:
      - drop <context.entity.location> fishing_bait_chum_item
