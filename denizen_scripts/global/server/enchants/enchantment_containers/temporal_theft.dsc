Temporal_theft_enchantment:
  type: enchantment
  id: Temporal_Theft
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Steals a portion of the victim's speed for 2 seconds.
      - <empty>
      - Levels increase the amount stolen by 10% per level.
    item_slots:
      - ranged
  category: bow
  full_name: <&7>Temporal Theft <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[bow|crossbow]>
  after attack:
  - ratelimit <player> 12t
  - if <util.random.int[1].to[10]> < 7:
    - stop
  - if <player.has_flag[temp.custom_enchantment_tempo]> || <context.victim.has_flag[temp.custom_enchantment_tempo]> || !<context.victim.is_spawned>:
    - stop
  - playsound sound:ENTITY_ENDERMAN_TELEPORT <player.location> pitch:1.5
  - flag <player> temp.custom_enchantment_tempo duration:100t
  - flag <context.victim> temp.custom_enchantment_tempo duration:40t
  - define player_speed <player.walk_speed>
  - define mob_speed <context.victim.speed>
  - adjust <context.victim> speed:<[mob_speed].sub[<context.victim.speed.div[7].mul[<context.level>]>]>
  - playsound sound:ENTITY_ENDERMAN_TELEPORT <context.victim.location> pitch:0.5
  - adjust <player> walk_speed:<[player_speed].add[<context.victim.speed.div[7].mul[<context.level>]>]>
  - wait <context.level.mul[15]>t
  - adjust <player> walk_speed:<[player_speed]>
  - playsound sound:ENTITY_ENDERMAN_TELEPORT <player.location> pitch:0.5
  - if <context.victim.is_spawned>:
    - adjust <context.victim> speed:<[mob_speed]>
    - playsound sound:ENTITY_ENDERMAN_TELEPORT <context.victim.location> pitch:1.5
