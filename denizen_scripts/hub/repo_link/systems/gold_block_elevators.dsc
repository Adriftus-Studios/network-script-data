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
    - define y_loc:<player.location.to_cuboid[<player.location.above[26]>].blocks[gold_block].parse[y].lowest||null>
    - if <[y_loc]> != null && <list[air|white_carpet|orange_carpet|magenta_carpet|light_blue_carpet|yellow_carpet|lime_carpet|pink_carpet|gray_carpet|light_gray_carpet|cyan_carpet|purple_carpet|blue_carpet|brown_carpet|green_carpet|red_carpet|black_carpet|oak_trapdoor|spruce_trapdoor|birch_trapdoor|jungle_trapdoor|acacia_trapdoor|dark_oak_trapdoor|crimson_trapdoor|warped_trapdoor].contains_any[<player.location.with_y[<[y_loc].add[1]>].material.name>]>:
      - playeffect effect:dragon_breath at:<player.location> quantity:30
#      - event "player uses elevator" context:from|<player.location>|to|<context.location.with_y[<[y_loc].add[1]>].center.with_yaw[<player.location.yaw>]>
      - teleport <context.location.with_y[<[y_loc].add[1]>].center.with_yaw[<player.location.yaw>]>
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
    - define y_loc:<player.location.sub[0,2,0].to_cuboid[<player.location.below[26]>].blocks[gold_block].parse[y].highest||null>
    - if <[y_loc]> != null && <list[air|white_carpet|orange_carpet|magenta_carpet|light_blue_carpet|yellow_carpet|lime_carpet|pink_carpet|gray_carpet|light_gray_carpet|cyan_carpet|purple_carpet|blue_carpet|brown_carpet|green_carpet|red_carpet|black_carpet|oak_trapdoor|spruce_trapdoor|birch_trapdoor|jungle_trapdoor|acacia_trapdoor|dark_oak_trapdoor|crimson_trapdoor|warped_trapdoor].contains_any[<player.location.with_y[<[y_loc].add[1]>].material.name>]>:
      - playeffect effect:dragon_breath at:<player.location> quantity:30
      - event "player uses elevator" context:from|<player.location>|to|<player.location.with_y[<[y_loc].add[1]>].center.with_yaw[<player.location.yaw>]>
      - teleport <player.location.with_y[<[y_loc].add[1]>].center.with_yaw[<player.location.yaw>]>
      - playeffect effect:dragon_breath at:<player.location> quantity:30
      - playsound <player.location> sound:entity_ender_eye_launch volume:2
      - flag player teleported_block duration:1s
    - else:
      - narrate "<&c>There is no destination block within range below you! <&4>(25 Blocks)"
      - playeffect effect:smoke at:<player.location> quantity:30
      - playsound <player.location> sound:entity_villager_no volume:2
      - flag player teleported_block duration:1s
