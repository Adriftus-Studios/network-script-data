Radiance_enchantment:
  type: enchantment
  id: Radiance
  debug: false
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[2]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - Has a small chance to heal all nearby players for 2 per level.
    item_slots:
      - all_weapons
  category: breakable
  full_name: <&7>Radiance <context.level.to_roman_numerals>
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
      - define effect_location <player.location>
      - if <player.location.distance[<context.victim>]||5> < 4:
        - define effect_location <context.victim.location>
      - playsound sound:BLOCK_FIRE_EXTINGUISH <[effect_location]> pitch:0.5 volume:5 targets:<player.location.find.players.within[40]>
      - define light_fix <list[<context.victim.location.above[3]>|<context.victim.location.above[2]>|<context.victim.location.above[1]>]>
      - foreach <[light_fix]> as:location:
          - showfake light <[location]> duration:1s
          - playeffect effect:redstone at:<[location]> quantity:10 special_data:1|255,255,0 velocity:<[effect_location]> targets:<player.location.find.players.within[40]>
          - playeffect effect:redstone at:<[location]> quantity:2 special_data:2|255,125,0 targets:<player.location.find.players.within[40]>
          - wait 5t
      - define aoe <[effect_location].find.surface_blocks.within[3]>
      - foreach <[aoe]> as:location:
        - if <[location].y.add[1]> == <[effect_location].y>:
          - playeffect effect:redstone at:<[location].add[0,1,0]> quantity:10 special_data:1|255,255,0 targets:<player.location.find.players.within[40]>
          - playeffect effect:redstone at:<[location].add[0,1,0]> quantity:5 special_data:1|255,125,0 targets:<player.location.find.players.within[40]>
      - foreach <[effect_location].find_entities.within[3]> as:entity:
        - if !<list[player|wolf|axolotl|ocelot|cat].contains_any[<[entity].entity_type>]>:
          - foreach next
        - if <[entity].entity_type> == player && <[entity].is_npc>:
          - foreach next
        - if <list[wolf|axolotl|ocelot|cat].contains_any[<[entity].entity_type>]> && <[entity].is_tamed||false>:
          - foreach next
        - heal <[entity]> <context.level.mul[2]>
      - wait 10t
      - foreach <[light_fix]> as:location:
        - showfake light[level=10] <[location]> duration:5t players:<player.location.find.players.within[40]>
      - wait 10t
      - foreach <[light_fix]> as:location:
        - showfake light[level=5] <[location]> duration:5t players:<player.location.find.players.within[40]>
      - foreach <[light_fix]> as:location:
        - showfake air <[location]> duration:5t players:<player.location.find.players.within[40]>
