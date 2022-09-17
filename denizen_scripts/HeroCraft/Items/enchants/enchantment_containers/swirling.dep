Swirling_enchantment:
  type: enchantment
  id: Swirling
  debug: true
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[2]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - The last attack in a combo performs a swirling attack damaging enemies within 2 blocks/damage per level.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Swirling <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  after attack:
  - ratelimit <player> 12t
  - if !<player.has_flag[temp.custom_enchant_Swirling]>:
    - flag <player> temp.custom_enchant_Swirling:1 expire:5s
    - stop
  - if <player.has_flag[temp.custom_enchant_Swirling]> && <player.flag[temp.custom_enchant_Swirling]> < 2:
    - flag <player> temp.custom_enchant_Swirling:++ expire:5s
    - playeffect <player.location> effect:sweep_attack quantity:<player.flag[temp.custom_enchant_Swirling]>
    - stop
  - if <player.flag[temp.custom_enchant_Swirling]> == 2:
    - flag <player> temp.custom_enchant_Swirling:!
    - mythicskill SwirlingSweep<context.level> casters:<player> <player>
    - foreach <player.location.find_entities.within[<element[2].mul[<context.level>]>]> as:entity:
      - if <list[player|dropped_item|armor_stand|item_frame|arrow|trident|shulker_bullet|experience_orb].contains_any[<[entity].entity_type>]> || !<[entity].is_spawned> || <[entity].is_tamed||false>:
        - foreach next
      - playsound sound:entity_ghast_shoot <[entity].location> pitch:1.5
      - hurt <context.victim> <context.level.mul[2]>
