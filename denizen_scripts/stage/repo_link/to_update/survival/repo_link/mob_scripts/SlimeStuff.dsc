slime_damage_handler:
  # $ [ converted until MythicMobs is added ]
  type: data
  debug: false
  events:
    on player damaged by slime:
    # % Check for Mythicmob
      - if !<context.damager.is_mythicmob> || <context.damager.MythicMob.level> < 5:
        - stop
    # % Generate random equipment slot
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
    # % Check for empty slot or invalid item
      - if !<player.equipment_map.contains[<[equipment]>]> || !<player.equipment_map.get[<[equipment]>].material.name.ends_with[_<[equipment]>]>:
        - actionbar "<&e>Acid splashes on you, burning your <[body_part]>."
        # % Damage player without armor
        - determine <context.damager.mythicmob.level.mul[5]>
    # % Define variables
      - define item <player.equipment_map.get[<[equipment]>]>
      - define durability <[item].durability.add[<context.damager.mythicmob.level.sub[6].mul[<context.damager.size.div[2].round_up>]>]>
    # % Item break check
      - if !<[item].repairable>:
        - stop
      - if <[durability]> >= <[item].max_durability>:
        - playeffect effect:ITEM_CRACK at:<player.location.above[0.5].forward[0.4]> special_data:<[item]> offset:0.2 quantity:15
        - playsound <context.location> sound:ENTITY_ITEM_BREAK
        - take slot:<[slot]>
        - narrate "Your armor has melted from the acid!"
    # % Item Durability Damage
      - else:
        - inventory adjust slot:<[slot]> durability:<[durability]>
      # % Damage player with armor
        - determine <context.damager.mythicmob.level.mul[3]>

slime_puddle_creator:
  type: task
  debug: false
  script:
  - if <context.entity.is_mythicmob> && <context.entity.mythicmob.internal_name> == slime1:
    - if <context.entity.size> == 1:
      - showfake slime_block <context.entity.location.sub[0,1,0]> d:10 players:<context.entity.location.find.players.within[20]>
      - playeffect effect:block_crack at:<context.entity.location.add[0,1,0]> quantity:2  offset:0.5 special_data:SLIME_BLOCK
      - stop
    - if <context.entity.size> == 4:
      - define Puddlesize 2
    - if <context.entity.size> == 2:
      - define Puddlesize 1
    - define Puddle_Location <context.entity.location.find.surface_blocks.within[<[Puddlesize]>].filter[material.is_solid]>
    - showfake slime_block <[Puddle_Location]> d:10 players:<context.entity.location.find.players.within[20]>
    - playeffect effect:block_crack at:<context.entity.location.add[0,1,0]> quantity:<[Puddlesize].mul[5]>  offset:<[Puddle_Location].div[4]> special_data:SLIME_BLOCK
