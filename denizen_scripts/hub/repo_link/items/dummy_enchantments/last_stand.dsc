last_Stand_enchantment:
  type: enchantment
  id: Last_Stand
  debug: false
  slots:
  - head
  rarity: very_rare
  min_cost: <context.level.mul[2]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - If your health goes below 10%, recieve 90% less damage for 5 seconds.
      - <empty>
      - Percent increases by 10% per level. 5 minute cooldown.
    item_slots:
      - Legs
  category: WEARABLE
  full_name: <&7>Last Stand <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_leggings]>
  after hurt:
  - if <player.health_percentage> < <element[10].mul[<context.level>]> && !<player.has_flag[temp.custom_enchantment_last_stand_cooldown]>:
    - playsound sound:ENTITY_PILLAGER_AMBIENT <player.location> pitch:0.5
    - flag <player> temp.custom_enchantment_last_stand expire:5s
    - flag <player> temp.custom_enchantment_last_stand_cooldown expire:300s
