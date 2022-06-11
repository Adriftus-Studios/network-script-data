Poison_Cloud_enchantment:
  type: enchantment
  id: Poison_Cloud
  debug: false
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[2]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - Has a small chance to create a poisonous cloud around victims location.
      - <empty>
      - Damage increases by 1 per level.
    item_slots:
      - all_weapons
  category: breakable
  full_name: <&7>Poison Cloud <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe|bow|crossbow|trident]>
  after attack:
    - ratelimit <player> 12t
    - if <util.random.int[1].to[10]> > 9 && <context.victim.is_spawned>:
      - define entity <context.victim>
      - define effect_cuboid <[entity].location.block.sub[1,1,1].to_cuboid[<[entity].location.add[1,1,1]>]>
      - repeat 3:
        - playeffect effect:redstone at:<[effect_cuboid].blocks> quantity:10 special_data:2|0,250,0
        - playeffect effect:redstone at:<[effect_cuboid].blocks> quantity:2 special_data:3|0,125,0
        - foreach <[effect_cuboid].entities> as:entity:
          - if <list[player|dropped_item|armor_stand|item_frame|arrow|trident|shulker_bullet|experience_orb].contains_any[<[entity].entity_type>]> || <[entity].is_tamed||false>:
            - foreach next
          - hurt <[entity]> <context.level> cause:POISON
        - wait 15t
