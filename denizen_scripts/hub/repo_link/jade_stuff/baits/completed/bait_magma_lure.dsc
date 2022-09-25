fishing_bait_magma:
  type: item
  material: amethyst_shard
  display name: <&F>Magma Lure Bait
  lore:
  - <&6>Increases <&e>fishing rolls <&6>by <&e>8<&pc><&6>.
  - <&sp>
  - <&6>Jade Level<&co> <&e>21
  mechanisms:
    custom_model_data: 8
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_magma_item|fishing_bait_magma_item|fishing_bait_magma_item
      - fishing_bait_magma_item|fishing_bait_hook|fishing_bait_magma_item
      - fishing_bait_magma_item|fishing_bait_magma_item|fishing_bait_magma_item

fishing_bait_magma_item:
  type: item
  debug: false
  material: amethyst_shard
  display name: <&F>Magma Ooze
  lore:
  - <&6>Scalding to the touch.
  mechanisms:
    custom_model_data: 9
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: magma_cream|magma_cream|magma_cream

fishing_bait_magma_giver:
  type: world
  debug: false
  events:
    on player kills magma_cube chance:10:
      - drop <context.entity.location> fishing_bait_magma_item
