Hardened_enchantment:
  type: enchantment
  id: Dark_Vision
  debug: false
  slots:
  - head
  - chest
  - legs
  - feet
  - mainhand
  rarity: common
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - The enchanted item becomes resistent to corrosive entities.
    item_slots:
      - Any Armor
      - all_weapons
  category: breakable
  full_name: <&7>Hardened <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_helmet|*_chestplate|*_leggings|*_boots|*_sword|*_axe]>