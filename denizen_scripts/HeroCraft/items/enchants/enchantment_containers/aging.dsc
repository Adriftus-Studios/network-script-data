aging_enchantment:
  type: enchantment
  id: aging
  debug: false
  slots:
  - mainhand
  rarity: very_rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Has a chance to make baby mobs grow older.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Aging <context.level.to_roman_numerals>
  min_level: 1
  max_level: 5
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: false
  can_enchant: <context.item.advanced_matches[sword|axe]>
  after attack:
    - ratelimit <player> 12t
    - if <util.random_chance[<context.level.mul[10]>].not> || <context.victim.is_baby.not>:
      - stop
    - determine passively cancelled
    - playeffect at:<context.victim.location> effect:villager_happy offset:0.5,0.5,0.5 quantity:100
    - age <context.victim> adult