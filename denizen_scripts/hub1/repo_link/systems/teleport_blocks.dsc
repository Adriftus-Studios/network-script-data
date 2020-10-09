gold_block_teleport_events:
  type: world
  debug: false
  events:
    on player jumps:
    # teleport players to first gold block within 25 blocks. If they are not standing on the block,
    - ratelimit <player> 10t
    - if <player.location.below.material.name> != gold_block:
      - stop
    - determine passively cancelled
    - wait 1t
    - define y_loc:<cuboid[<context.location.above>|<context.location.above[26]>].blocks[gold_block].parse[y].lowest||null>
    - if <[y_loc]> != null && <context.location.with_y[<[y_loc].+[1]>].material.name> == air:
      - playeffect effect:dragon_breath at:<player.location> quantity:30
      - event "player uses elevator" context:from|<player.location>|to|<context.location.with_y[<[y_loc].+[1]>].center.with_yaw[<player.location.yaw>]>
      - teleport <context.location.with_y[<[y_loc].+[1]>].center.with_yaw[<player.location.yaw>]>
      - playeffect effect:dragon_breath at:<player.location> quantity:30
      - playsound <player.location> sound:entity_ender_eye_launch volume:2
      - flag player teleported_block duration:1s
    - else:
      - narrate "<&c>There is no destination block within range above you! <&4>(25 Blocks)"
      - playeffect effect:smoke at:<player.location> quantity:30
      - playsound <player.location> sound:entity_villager_no volume:2
      - flag player teleported_block duration:1s
  on player starts sneaking:
  # teleport players to first gold block within 25 blocks. If they are not standing on the block,
  - ratelimit <player> 10t
  - if <player.location.below.material.name> == gold_block:
    - define y_loc:<cuboid[<player.location.below[2]>|<player.location.below[26]>].blocks[gold_block].parse[y].highest||null>
    - if <[y_loc]> != null && <player.location.with_y[<[y_loc].+[1]>].material.name> == air:
      - playeffect effect:dragon_breath at:<player.location> quantity:30
      - event "player uses elevator" context:from|<player.location>|to|<player.location.with_y[<[y_loc].+[1]>].center.with_yaw[<player.location.yaw>]>
      - teleport <player.location.with_y[<[y_loc].+[1]>].center.with_yaw[<player.location.yaw>]>
      - playeffect effect:dragon_breath at:<player.location> quantity:30
      - playsound <player.location> sound:entity_ender_eye_launch volume:2
      - flag player teleported_block duration:1s
    - else:
      - narrate "<&c>There is no destination block within range below you! <&4>(25 Blocks)"
      - playeffect effect:smoke at:<player.location> quantity:30
      - playsound <player.location> sound:entity_villager_no volume:2
      - flag player teleported_block duration:1s
