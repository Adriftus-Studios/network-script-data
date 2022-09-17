Precision_enchantment:
  type: enchantment
  id: Precision
  slots:
  - mainhand
  rarity: very_rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Causes more drops from sheared blocks and mobs
    item_slots:
      - shears
  category: breakable
  full_name: <&7>Precision <context.level.to_roman_numerals>
  min_level: 1
  max_level: 1
  is_tradable: false
  can_enchant: <context.item.advanced_matches[shears]>
##  is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:fortune].not>
  treasure_only: true
