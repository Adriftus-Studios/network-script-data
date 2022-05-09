Levitation_shot_enchantment:
  type: enchantment
  id: Levitation_shot
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Causes victims to levitate for 2 seconds.
      - <empty>
      - Levels increase the speed of levitation.
    item_slots:
      - ranged
  category: bow
  full_name: <&7>Levitation Shot <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[bow|crossbow|trident]>
  after attack:
  - ratelimit <player> 12t
  - flag <context.victim> no_transform expire:40t
  - if <util.random.int[1].to[10]> > 9 && <context.victim.is_spawned>:
    - cast LEVITATION <context.victim> amplifier:<context.level.sub[1]> duration:2s

Levitation_shot_enchantment_transform_protection:
  type: world
  debug: false
  events:
    on entity_flagged:no_transform transforms:
      - determine passively cancelled
