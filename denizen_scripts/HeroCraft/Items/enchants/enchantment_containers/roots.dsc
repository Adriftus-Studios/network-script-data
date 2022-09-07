Roots_enchantment:
  type: enchantment
  id: Roots
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - 20% chance per level to prevent endermen from teleporting away.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Roots <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
#  is_compatible:
  after attack:
    - ratelimit <player> 12t
    - if <context.victim.entity_type.equals[ENDERMAN]> && <util.random_chance[<context.level.mul[20]>]>:
      - flag <context.victim> no_teleport expire:1m