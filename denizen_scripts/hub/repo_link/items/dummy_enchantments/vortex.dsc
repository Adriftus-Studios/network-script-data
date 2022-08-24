Vortex_enchantment:
  type: enchantment
  id: vortex
  debug: false
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[2]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - Pulls in monsters within 7 blocks.
      - <empty>
      - Increased levels increase the force of the pull.
    item_slots:
      - all_weapons
  category: breakable
  full_name: <&7>Vortex <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  is_compatible: <context.enchantment_key.advanced_matches_text[denizen:shockwave].not>
  after attack:
    - ratelimit <player> 12t
    - if <util.random.int[1].to[10]> > 8:
      - define level <context.level.div[5]>
      - define location <context.victim.location||player.location>
      - playsound <[location].above[1]>  sound:BLOCK_BEACON_DEACTIVATE
      - foreach <[location].find_entities.within[7].exclude[<context.victim>]> as:entity:
        - if !<list[player|dropped_item|armor_stand|item_frame|arrow|trident|shulker_bullet|experience_orb].contains_any[<[entity].entity_type>]> && <[entity].is_spawned> && !<[entity].is_tamed||false>:
          - define vector <context.victim.location.sub[<[entity].location>].normalize.mul[<[level]>]>
          - adjust <[entity]> velocity:<[vector].x>,0.4,<[vector].z>
