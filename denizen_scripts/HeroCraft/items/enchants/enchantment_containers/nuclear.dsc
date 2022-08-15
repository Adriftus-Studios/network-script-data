nuclear_enchantment:
  type: enchantment
  id: nuclear
  debug: false
  slots:
  - mainhand
  rarity: very_rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Can give nearly every negative effect randomly.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Nuclear <context.level.to_roman_numerals>
  min_level: 1
  max_level: 1
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: false
  can_enchant: <context.item.advanced_matches[sword|axe]>
  after attack:
  - ratelimit <player> 12t
  - stop if:<util.random_chance[50]>
  - define e <context.victim>
  - random:
    - cast SLOW <[e]> duration:<util.random.int[5].to[30]> amplifier:<util.random.int[0].to[2]>
    - cast POISON <[e]> duration:<util.random.int[5].to[15]> amplifier:<util.random.int[0].to[2]>
    - cast WITHER <[e]> duration:<util.random.int[5].to[15]> amplifier:<util.random.int[0].to[2]>
    - cast SLOW_DIGGING <[e]> duration:<util.random.int[5].to[15]> amplifier:<util.random.int[0].to[2]>
    - cast BLINDNESS <[e]> duration:<util.random.int[5].to[15]> amplifier:<util.random.int[0].to[2]>
    - cast CONFUSION <[e]> duration:<util.random.int[5].to[30]> amplifier:<util.random.int[0].to[2]>
    - cast HUNGER <[e]> duration:<util.random.int[5].to[30]> amplifier:<util.random.int[0].to[2]>
    - cast WEAKNESS <[e]> duration:<util.random.int[5].to[30]> amplifier:<util.random.int[0].to[2]>
    - cast UNLUCK <[e]> duration:<util.random.int[5].to[120]> amplifier:<util.random.int[0].to[2]>
    - cast DARKNESS <[e]> duration:<util.random.int[5].to[120]> amplifier:<util.random.int[0].to[2]>
