custom_mob_prefix_corrosive:
  Type: world
  debug: false
  events:
    on player damages entity_flagged:corrosive:
      - if !<list[entity_attack|entity_sweep_attack].contains_any[<context.cause>]>:
        - stop
      - define acid_strength <util.random.int[5].to[20]>
      - if <player.item_in_hand.max_durability||0> <1:
        - stop
      - if <player.item_in_hand.durability.add[<[acid_strength]>]||9000> > <player.item_in_hand.max_durability>:
        - take iteminhand
        - playsound sound:item_shield_break <player.location>
        - stop
      - inventory adjust slot:<player.held_item_slot> durability:<player.item_in_hand.durability.add[<[acid_strength]>]>

Corrosive_prefix_armor_task:
  Type: world
  debug: false
  events:
    on player damaged by entity_flagged:corrosive:
    - define acid_strength <util.random.int[5].to[20]>
    - choose <util.random.int[1].to[4]>:
      - case 1:
        - define equipment helmet
        - define slot 40
        - define body_part face
      - case 2:
        - define equipment chestplate
        - define slot 39
        - define body_part chest
      - case 3:
        - define equipment leggings
        - define slot 38
        - define body_part legs
      - case 4:
        - define equipment boots
        - define slot 37
        - define body_part feet
    - if !<player.equipment_map.contains[<[equipment]>]> || !<player.equipment_map.get[<[equipment]>].material.name.ends_with[_<[equipment]>]>:
      - actionbar "<&e>Acid splashes on you, burning your <[body_part]>."
      # % Damage player without armor
      - determine <[acid_strength].div[5]>
  # % Define variables
    - define item <player.equipment_map.get[<[equipment]>]>
    - define durability <[item].durability.add[<[acid_strength]>]>
  # % Item break check
    - if !<[item].repairable>:
      - stop
    - if <[durability]> >= <[item].max_durability>:
      - playeffect effect:ITEM_CRACK at:<player.location.above[0.5].forward[0.4]> special_data:<[item]> offset:0.2 quantity:15
      - playsound <player.location> sound:ENTITY_ITEM_BREAK
      - take slot:<[slot]>
      - actionbar "<&e>Your armor has melted from the acid!"
  # % Item Durability Damage
    - else:
      - inventory adjust slot:<[slot]> durability:<[durability]>
    # % Damage player with armor
      - determine <[acid_strength].div[5]>
