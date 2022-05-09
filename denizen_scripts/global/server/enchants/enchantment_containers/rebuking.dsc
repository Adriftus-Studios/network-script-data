Rebuking_enchantment:
  type: enchantment
  id: Rebuking
  debug: false
  slots:
  - mainhand
  - offhand
  rarity: very_rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Stores damage in shield, Jump to release an attack
      - <empty>
      - 2S cd per stack Jump during block to release
    item_slots:
      - Shield
  category: breakable
  full_name: <&7>Rebuking <context.level.to_roman_numerals>
  min_level: 1
  max_level: 4
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_shield]>
#  is_compatible:
