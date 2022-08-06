Ricochet_enchantment:
  type: enchantment
  id: Ricochet
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Arrows fired have a chance to bounce to enemies.
      - Levels increase number of bounces.
      - Cannot be used with Chain Reaction.
    item_slots:
      - bows
      - crossbows
  category: bow
  full_name: <&7>Ricochet <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[bow|crossbow]>
  is_compatible: <context.enchantment_key.advanced_matches[denizen:chain_reaction].not>
  after attack:
  - ratelimit <player> 12t
  - if <util.random.int[1].to[10]> < 9 || !<context.victim.is_spawned>:
    - stop
  - if <context.victim.is_spawned>:
      - define ricochet_count 0
      - define bounce_origin <context.victim.eye_location>
      - foreach <context.victim.location.find_entities.within[6]> as:entity:
        - if <[ricochet_count]> >= <context.level>:
          - stop
        - if <list[player|wolf|cat|axolotl|villager|dropped_item|armor_stand|item_frame|arrow|trident|shulker_bullet|experience_orb].contains_any[<[entity].entity_type>]> || !<[entity].is_Spawned> || <[entity]> == <context.victim>:
          - foreach next
        - shoot arrow origin:<[bounce_origin]> destination:<[entity].eye_location> speed:1 save:ricochet_arrow
        - flag <entry[ricochet_arrow].shot_entity> fake_arrow
        - define ricochet_count <[ricochet_count].add[1]>
        - define bounce_origin <[entity].eye_location>
        - define timer <server.delta_time_since_start>
        - waituntil !<entry[ricochet_arrow].shot_entity.is_spawned||true>
        - wait 1t
        - if <server.delta_time_since_start.sub[<[timer]>].in_ticks> > 20:
          - stop
