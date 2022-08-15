rain_dance_enchantment:
  type: enchantment
  id: rain_dance
  debug: false
  slots:
  - feet
  - legs
  - chest
  - head
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Increases defense when there is a storm.
    item_slots:
      - Any Armor
  category: WEARABLE
  full_name: <&7>Rain Dance <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_helmet|*_chestplate|*_leggings|*_boots]>
  after hurt:
    - ratelimit <player> 40t
    - heal <context.level> <player> if:<util.random_boolean.and[<player.location.world.has_storm>]>