Chilling_enchantment:
  type: enchantment
  id: Chilling
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
      - Has a chance to release a barrage of ice spikes
      - <empty>
      - Deals 2 damage per level.
    item_slots:
      - Any Armor
  category: WEARABLE
  full_name: <&7>Chilling <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_helmet|*_chestplate|*_leggings|*_boots]>
  after hurt:
    - ratelimit <player> 10t
    - if <util.random.int[1].to[10]> > 9:
        - mythicspawn ChillBlaster_<context.attacker.is_player.if_true[player].if_false[mob]> <player.location> level:<context.level>
