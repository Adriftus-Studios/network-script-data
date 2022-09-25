fishing_bait_endmite:
  type: item
  material: amethyst_shard
  display name: <&F>End Mite Bait
  lore:
  - <&6>Increases <&e>fishing rolls <&6>by <&e>10<&pc><&6>.
  - <&sp>
  - <&6>Jade Level<&co> <&e>51
  mechanisms:
    custom_model_data: 16
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_end_mite_item|fishing_bait_end_mite_item|fishing_bait_end_mite_item
      - fishing_bait_end_mite_item|fishing_bait_hook|fishing_bait_end_mite_item
      - fishing_bait_end_mite_item|fishing_bait_end_mite_item|fishing_bait_end_mite_item


fishing_bait_end_mite_item:
  type: item
  debug: false
  material: amethyst_shard
  display name: <&F>End Mite
  lore:
  - <&6>Huh, something's wrong with this one
  mechanisms:
    custom_model_data: 17
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: ender_pearl|fishing_bait_silverfish_item|ender_pearl

fishing_bait_end_mite_giver:
  type: world
  debug: false
  events:
    on player kills end_mite chance:2:
      - drop <context.entity.location> fishing_bait_end_mite_item
