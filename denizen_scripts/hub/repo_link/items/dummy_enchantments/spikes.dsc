spikes_enchantment:
  type: enchantment
  id: spikes
  debug: false
  slots:
  - mainhand
  - offhand
  rarity: common
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Returns 1 damage per level to the attacker.
      - <empty>
      - Only effective during blocking. 2s CD
    item_slots:
      - Shield
  category: breakable
  full_name: <&7>spikes <context.level.to_roman_numerals>
  min_level: 1
  max_level: 5
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*shield]>
#  is_compatible:
