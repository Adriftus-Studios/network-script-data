bonus_shot_enchantment:
  type: enchantment
  id: bonus_shot
  debug: false
  slots:
  - mainhand
  rarity: common
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Has a small chance to fire an extra arrow at a nearby enemy.
    item_slots:
      - bows
      - crossbows
  category: bow
  full_name: <&7>Bonus Shot <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_tradable: false
  can_enchant: <context.item.advanced_matches[bow|crossbow]>
  after attack:
    - ratelimit <player> 12t
    - if <util.random.int[1].to[10]> < 9:
      - stop
    - define shots_fired 0
    - foreach <player.location.find_entities.within[7]> as:entity:
      - if <[shots_fired]> < <context.level> && !<list[player|wolf|cat|axolotl|villager|dropped_item|armor_stand|item_frame|arrow|trident|shulker_bullet|experience_orb].contains_any[<[entity].entity_type>]> && <[entity]> != <context.victim> && <[entity].is_Spawned>:
        - shoot arrow origin:<player.eye_location> destination:<[entity].eye_location> speed:1.5 save:arrow
        - flag <entry[arrow].shot_entity> fake_arrow
        - define shots_fired <[shots_fired].add[1]>
