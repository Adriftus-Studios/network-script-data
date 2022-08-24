prospector_enchantment:
  type: enchantment
  id: Prospector
  debug: false
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[2]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - Has a small chance to cause treasure to drop when a mob dies.
      - <empty>
      - Repeated strikes stack, up to the enchantment level.
    item_slots:
      - all_weapons
  category: breakable
  full_name: <&7>Prospector <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe|bow|crossbow|trident]>
  after attack:
    - ratelimit <player> 12t
    - if <list[pillager|evoker|vindicator|illusioner|zombie|piglin|piglin_brute|zombified_piglin].contains_any[<context.victim.entity_type>]> && <context.victim.is_spawned>:
      - if <context.victim.flag[temp.custom_enchant_prospector]||0> < <context.level>:
        - flag <context.victim> temp.custom_enchant_prospector:++ expire:20s
