fishing_dungeon_key:
  type: item
  material: tripwire_hook
  display name: <&6>Fishing Dungeon Key
  mechanisms:
    hides: all
    custom_model_data: 1
    enchantments: luck,1
  lore:
  - <&6>Jade can use this to explore dangerous places.

jade_key_canceller:
  type: world
  debug: false
  events:
    on player right clicks block with:fishing_dungeon_key:
      - determine passively cancelled
