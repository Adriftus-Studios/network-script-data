Beastmaster_enchantment:
  type: enchantment
  id: Beastmaster
  debug: false
  slots:
  - feet
  - legs
  - chest
  - head
  rarity: common
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Increases the damage done by your tamed pets.
      - <empty>
      - Damage increases by 1 per level.
    item_slots:
      - Any Armor
  category: WEARABLE
  full_name: <&7>Beastmaster <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_helmet|*_chestplace|*_leggings|*_boots]>
