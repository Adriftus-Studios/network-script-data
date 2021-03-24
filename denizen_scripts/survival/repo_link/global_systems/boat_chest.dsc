boat_chests:
  type: world
  debug: false
  events:
    on player right clicks boat with:chest:
    - if <context.entity.has_passenger> || <context.item.script.name||null> != null:
      - stop
    - else:
      - determine passively cancelled
      - ratelimit <player> 2t
      - spawn chest_head_chicken persistent save:chicken_for_boat
      - flag <entry[chicken_for_boat].spawned_entity.passenger> boat_chest_armorstand:<entry[chicken_for_boat].spawned_entity.passenger>
      - wait 1t
      - adjust <context.entity> passenger:<entry[chicken_for_boat].spawned_entity>
      - define inventory <inventory[boat_chest_inventory]>
      - note <[inventory]> as:<entry[chicken_for_boat].spawned_entity.passenger>_inventory
      - flag <context.entity> chest:<entry[chicken_for_boat].spawned_entity.passenger>
      - take iteminhand
    on player right clicks armor_stand:
      - if !<context.entity.has_flag[boat_chest_armorstand]>:
        - stop
      - else:
        - inventory open d:<context.entity>_inventory

boat_chest_inventory:
  type: inventory
  debug: false
  inventory: chest
  size: 27

chest_head_chicken:
  type: entity
  entity_type: chicken
  hide_from_players: true
  has_ai: false
  gravity: false
  silent: true
  passenger: chest_head_armor_stand

chest_head_armor_stand:
  type: entity
  entity_type: armor_stand
  equipment: air|air|air|boat_chest_item
  has_ai: false
  gravity: false
  visible: false


boat_chest_item:
  type: item
  debug: false
  material: paper
  mechanisms:
    custom_model_data: 3

