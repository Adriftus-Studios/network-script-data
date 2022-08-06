cowardice_enchantment:
  type: enchantment
  id: Cowardice
  debug: false
  slots:
  - feet
  - legs
  - chest
  - head
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - When over 90% health, you deal 1 damage extra per level on attacks.
    item_slots:
      - Any Armor
  category: WEARABLE
  full_name: <&7>Cowardice <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_helmet|*_chestplate|*_leggings|*_boots]>
