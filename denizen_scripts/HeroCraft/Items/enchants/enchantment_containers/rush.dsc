Rush_enchantment:
  type: enchantment
  id: Rush
  debug: false
  slots:
  - feet
  rarity: very_rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Has a chance to boost your speed by 20% when hit.
      - <empty>
      - Lasts 1 second per level
    item_slots:
      - boots
  category: WEARABLE
  full_name: <&7>Rush <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_boots]>
  after hurt:
  - if <util.random.int[1].to[5]> == 1:
    - cast speed amplifier:0 duration:<context.level>s
