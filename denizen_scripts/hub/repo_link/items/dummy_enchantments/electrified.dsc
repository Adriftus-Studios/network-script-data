Electrified_enchantment:
  type: enchantment
  id: Electrified
  debug: false
  slots:
  - head
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Has a chance to release an electric charge dealing 3 damage.
      - <empty>
      - Increased levels grant 1 bounce per level.
    item_slots:
      - boots
  category: WEARABLE
  full_name: <&7>Electrified <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_boots]>
  after hurt:
  - if <util.random.int[1].to[10]> > 9:
    - define bounce_count 0
    - define valid_entities <list[dropped_item|armor_stand|item_frame|arrow|trident|shulker_bullet|experience_orb].include[player]>
    - if <context.attacker.is_player>:
      - define valid_entities <[valid_entities].include[player]>
    - foreach <context.attacker.location.find_entities.within[5]> as:entity:
      - if <[bounce_count]> == <context.level.add[1]>:
        - stop
      - if <[entity]> == <context.victim> || <[entity]> == <context.attacker> || !<[valid_entities].contains_any[<[entity].entity_type>]>:
        - foreach next
      - playeffect effect:crit <context.attacker.location.points_between[<[entity].location>].distance[0.25]> offset:0.15 quantity:1
      - playeffect effect:crit <[entity].location> offset:0.5,0.75,0.5 quantity:50
      - hurt <[entity]> 3
      - define bounce_count <[bounce_count].add[1]>
