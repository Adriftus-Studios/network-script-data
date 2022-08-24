chain_reaction_enchantment:
  type: enchantment
  id: chain_reaction
  debug: false
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[2]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - Has a small chance to fire arrows from the target struck.
      - <empty>
      - Increased levels increase the amount of arrows.
    item_slots:
      - bows
      - crossbows
  category: bow
  full_name: <&7>Chain Reaction <context.level.to_roman_numerals>
  min_level: 1
  max_level: 4
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[bow|crossbow]>
  is_compatible: <context.enchantment_key.advanced_matches[denizen:ricochet].not>
  after attack:
    - ratelimit <player> 12t
    - if <util.random.int[1].to[10]> < 9 || !<context.victim.is_spawned>:
      - stop
    - define eye_location <context.victim.eye_location>
    - choose <context.level>:
      - case 1:
        - choose <util.random.int[1].to[2]>:
          - case 1:
            - define directional_list <list[<[eye_location].add[0,0,1]>|<[eye_location].sub[0,0,1]>]>
          - case 2:
            - define directional_list <list[<[eye_location].add[1,0,0]>|<[eye_location].sub[1,0,0]>]>
      - case 2:
        - define directional_list <list[<[eye_location].sub[1,0,0]>|<[eye_location].sub[0,0,1]>|<[eye_location].add[0,0,1]>|<[eye_location].add[1,0,0]>]>
      - case 3:
        - choose <util.random.int[1].to[2]>:
          - case 1:
            - define directional_list <list[<[eye_location].add[0,0,1].sub[1,0,0]>|<[eye_location].sub[0,0,1].add[1,0,0]>|<[eye_location].sub[1,0,0]>|<[eye_location].sub[0,0,1]>|<[eye_location].add[0,0,1]>|<[eye_location].add[1,0,0]>]>
          - case 2:
            - define directional_list <list[<[eye_location].add[1,0,1]>|<[eye_location].sub[1,0,1]>|<[eye_location].sub[1,0,0]>|<[eye_location].sub[0,0,1]>|<[eye_location].add[0,0,1]>|<[eye_location].add[1,0,0]>]>
      - case 4:
        - define directional_list <list[<[eye_location].add[1,0,1]>|<[eye_location].sub[1,0,1]>|<[eye_location].add[0,0,1].sub[1,0,0]>|<[eye_location].sub[0,0,1].add[1,0,0]>|<[eye_location].sub[1,0,0]>|<[eye_location].sub[0,0,1]>|<[eye_location].add[0,0,1]>|<[eye_location].add[1,0,0]>]>
    - foreach <[directional_list]> as:location:
      - shoot arrow origin:<[eye_location]> destination:<[location]> speed:1.5 save:arrow
    - flag <entry[arrow].shot_entity> fake_arrow
