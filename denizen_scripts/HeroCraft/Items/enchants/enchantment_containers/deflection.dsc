deflection_enchantment:
  type: enchantment
  id: Deflection
  debug: false
  slots:
  - legs
  - chest
  rarity: rare
  min_cost: <context.level.mul[2]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - Gives a small chance to deflect incoming arrows.
      - <empty>
      - Chance increases by 2% per level.
    item_slots:
      - Chest, Legs
  category: WEARABLE
  full_name: <&7>Deflection <context.level.to_roman_numerals>
  min_level: 1
  max_level: 5
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_chestplate|*_leggings]>
