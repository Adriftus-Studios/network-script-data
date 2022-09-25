fishing_bait_mysterious:
  type: item
  material: amethyst_shard
  display name: <&F>Mysterious Shard Bait
  lore:
  - <&6>Increases chance to <&e>catch items <&6>by <&e>18<&pc><&6>.
  - <&sp>
  - <&6>Jade Level<&co> <&e>71
  mechanisms:
    custom_model_data: 20
  recipes:
    1:
      type: shaped
      input:
      - fishing_bait_mysterious_fragment_item|fishing_bait_mysterious_fragment_item|fishing_bait_mysterious_fragment_item
      - fishing_bait_mysterious_fragment_item|fishing_bait_hook|fishing_bait_mysterious_fragment_item
      - fishing_bait_mysterious_fragment_item|fishing_bait_mysterious_fragment_item|fishing_bait_mysterious_fragment_item


fishing_bait_mysterious_fragment_item:
  type: item
  debug: false
  material: amethyst_shard
  display name: <&F>Mysterious Shard
  lore:
  - <&6>Broken to bits, maybe there is still a use for this.
  mechanisms:
    custom_model_data: 21

fishing_bait_mysterious_giver:
  type: world
  debug: false
  events:
    on player kills warden|illager|pillager|evoker|illusioner|villager chance:5:
      - determine fishing_bait_mysterious_fragment_item
