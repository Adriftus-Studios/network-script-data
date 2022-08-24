weakening_enchantment:
  type: enchantment
  id: weakening
  debug: false
  slots:
  - mainhand
  rarity: common
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Can cause enemies within 2 blocks per level to have their damage reduced for 5 seconds.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Weakening <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  after attack:
  - ratelimit <player> 12t
  - if <util.random.int[1].to[10]> > 9:
    - foreach <player.location.find_entities.within[<context.level.mul[2]>]> as:entity:
      - if <list[player|dropped_item|armor_stand|item_frame|arrow|trident|shulker_bullet|experience_orb].contains_any[<[entity].entity_type>]> || <[entity].is_tamed||false> || !<context.victim.is_spawned>:
        - foreach next
      - cast weakness amplifier:0 duration:5s <[entity]>
