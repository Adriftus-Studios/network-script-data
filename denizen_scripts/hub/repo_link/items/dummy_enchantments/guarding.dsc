guarding_enchantment:
  type: enchantment
  id: guarding
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - When a monster is slain grants 3 shield per level
    item_slots:
      - sword
      - axe
  category: weapon
  full_name: <&7>Guarding <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
