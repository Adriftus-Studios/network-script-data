shockwave_enchantment:
  type: enchantment
  id: shockwave
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - A 3 hit combo will knock monsters back, dealing 2 damage per level.
      - <empty>
      - Cannot be combined with Swirling or Vortex.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Shockwave <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  is_compatible: <context.enchantment_key.advanced_matches_text[denizen:swirling|denizen:vortex].not>
  after attack:
  - ratelimit <player> 12t
  - if !<player.has_flag[temp.custom_enchant_shockwave]>:
    - flag <player> temp.custom_enchant_shockwave:1 expire:5s
    - stop
  - if <player.has_flag[temp.custom_enchant_shockwave]> && <player.flag[temp.custom_enchant_shockwave]> < 3:
    - flag <player> temp.custom_enchant_shockwave:++ expire:5s
    - playeffect <player.location> effect:sweep_attack quantity:<player.flag[temp.custom_enchant_shockwave]>
    - stop
  - if <player.flag[temp.custom_enchant_shockwave]> == 3:
    - flag <player> temp.custom_enchant_shockwave:!
    - mythicskill <player> ShockwaveSweep<context.level>
    - define level <player.item_in_hand.enchantment_map.get[shockwave].div[10]>
    - define location <context.victim.location||player.location>
    - playsound <[location].above[1]>  sound:BLOCK_BEACON_DEACTIVATE
    - foreach <player.location.find_entities.within[<element[2].mul[<context.level>]>]> as:entity:
      - if <list[player|dropped_item|armor_stand|item_frame|arrow|trident|shulker_bullet|experience_orb].contains_any[<[entity].entity_type>]> || !<[entity].is_spawned> || <[entity].is_tamed||false>:
        - foreach next
      - hurt <[entity]> <context.level> cause:void
      - define vector <[entity].location.sub[<player.location>].normalize.mul[<[level].mul[4]>]>
      - adjust <[entity]> velocity:<[vector].x>,0.4,<[vector].z>
      - playsound sound:entity_ghast_shoot <[entity].location> pitch:1.5
