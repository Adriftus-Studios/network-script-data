Flamebrand_enchantment:
  type: enchantment
  id: Flamebrand
  debug: true
  slots:
  - mainhand
  - offhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Sets the attacker on fire for 1s per level
      - <empty>
      - Only effective during blocking. 2s CD
    item_slots:
      - Shield
  category: breakable
  full_name: <&7>Flamebrand <context.level.to_roman_numerals>
  min_level: 1
  max_level: 4
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*shield]>
