freezing_enchantment:
  type: enchantment
  id: freezing
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Can slow enemies by 15% per level for 3 seconds.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Freezing <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  after attack:
    - ratelimit <player> 12t
    - if <context.victim.is_spawned>:
      - cast SLOW <context.victim> amplifier:<context.level.sub[1]> duration:3s
