Dark_Vision_enchantment:
  type: enchantment
  id: Dark_Vision
  debug: false
  slots:
  - head
  rarity: rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Gives the user Night Vision while worn.
    item_slots:
      - helmets
  category: breakable
  full_name: <&7>Dark Vision <context.level.to_roman_numerals>
  min_level: 1
  max_level: 1
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_helmet]>

Dark_Vision_enchantment_events:
  type: world
  debug: false
  events:
    on player equips item_enchanted:dark_vision:
    - cast NIGHT_VISION amplifier:1 duration:999d no_ambient hide_particles
    - flag <player> dark_vision
    on player unequips item_enchanted:dark_vision flagged:dark_vision:
    - cast NIGHT_VISION amplifier:1 duration:0t
    - flag <player> dark_vision:!