Wild_Rage_enchantment:
  type: enchantment
  id: Wild_Rage
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Chance to confuse enemies and attack random targets.
      - <empty>
      - Increases duration by 1 second per level.
    item_slots:
      - bows
      - crossbows
      - tridents
  category: bow
  full_name: <&7>Wild Rage <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[bow|crossbow|trident]>
  after attack:
  - ratelimit <player> 12t
  - if <context.victim.has_flag[temp.custom_enchantment_wild_rage]> || <util.random.int[1].to[10]> < 8 || !<context.victim.is_spawned> || <context.victim.is_player>:
    - stop
  - flag <context.victim> temp.custom_enchantment_wild_rage duration:<context.level.add[2].mul[20]>t
  - while <context.victim.is_spawned> && <context.victim.has_flag[temp.custom_enchantment_wild_rage]>:
    - attack <context.victim> target:<context.victim.location.find_entities.within[8].random>
    - wait 40t
  - attack cancel <context.victim>
