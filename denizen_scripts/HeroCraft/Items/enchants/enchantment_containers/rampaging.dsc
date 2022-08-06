rampaging_enchantment:
  type: enchantment
  id: rampaging
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - After defeating a mob, there is a chance to increase attack damage by 3 for 5 seconds per level.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Rampaging <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
