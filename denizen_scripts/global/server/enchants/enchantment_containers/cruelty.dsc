Cruelty_enchantment:
  type: enchantment
  id: Cruelty
  debug: false
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Increases damage by 1.5 points per level to already damaged enemies.
    item_slots:
      - all_weapons
  category: breakable
  full_name: <&7>Cruelty <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_sword|*_axe|bow|crossbow|trident]>
