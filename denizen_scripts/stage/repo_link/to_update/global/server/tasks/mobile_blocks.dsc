#- usage: - ~run mobile_block def:<[location]>|<[material]> save:save_name
#-        <entry[save_name].created_queue.determination> is the mobile block
#-        <[material]> is optional unless the location is air.
#$        blocks below this location cannot be solid
#^    ex: - ~run mobile_block def:<player.location.forward_flat[3]>|stone save:my_block
mobile_block:
  type: task
  debug: false
  definitions: location|material
  script:
    - define location <[location].add[0.5,0,0.5]>
    - if <[material]||invalid> != invalid:
      - if <[location].material.name> != air:
        - define material <[location].material>
      - else:
        - define material stone

    - mount mobile_block_entity_shulker|mobile_block_entity_stand <[location]> save:entities
    - invisible <entry[entities].mounted_entities.first>
  #^- disguise <entry[entities].mounted_entities.first> as:falling_block[fallingblock_type=<[material]>]
    - mount mobile_block_entity_block[fallingblock_type=<[material]>]|<entry[entities].mounted_entities.last> <[location]>
    - modifyblock <[location]> air
    - determine <entry[entities].mounted_entities.last>

#- usage: - ~run move_block def:<[block]>|<[location_from]>|<[location_to]>|<[speed]>
#-        <[speed]> is optional; moves 0.1 blocks per tick by default
#^    ex: - ~run mobile_block def:<player.location.forward_flat[3]>|stone save:my_block
#^        - define my_block def:<entry[saveName].created_queue.determination>
#^        - ~run move_block def:<[my_block]>|<location[10,10,10,world]>|<location[20,10,10,world]>
move_block:
  type: task
  debug: false
  definitions: block|location_from|location_to|speed
  script:
    - if <[speed]||invalid>:
      - define speed 0.1
    - define distance <[location_from].distance[<[location_to]>].div[<[speed]>]>
    - define direction <[location_to].sub[<[location_from]>]>
    - repeat <[distance]>:
      - adjust <[block]> move:<[direction].div[<[distance]>]>
      - wait 1t
    - wait 1s
    - teleport <[block]> <player.flag[loc1].as_location>

mobile_block_entity_shulker:
  type: entity
  debug: false
  entity_type: shulker
  has_ai: false

mobile_block_entity_block:
  type: entity
  debug: false
  entity_type: falling_block
  velocity: 0,0,0
  time_lived: <duration[-1y]>
  invulnerable: true

mobile_block_entity_stand:
  type: entity
  debug: false
  entity_type: armor_stand
  velocity: 0,0,0
  invulnerable: true
  visible: false
  marker: true
