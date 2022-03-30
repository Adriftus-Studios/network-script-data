chair_sit_events:
  type: world
  debug: false
  events:
    on player right clicks block:
    - stop if:<context.location.material.name.ends_with[stairs].not.if_null[true]>
    - stop if:<context.location.material.half.equals[BOTTOM].not>
    - determine passively cancelled
    - spawn arrow <context.location.center.below[0.5]> save:mount_point
    - define point <entry[mount_point].spawned_entity>
    - invisible <[point]>
    - flag <[point]> sit.offset:<[point].location.sub[<player.location>]>
    - adjust <[point]> passenger:<player>
    after player exits vehicle:
    - stop if:<context.vehicle.has_flag[sit.offset].not>
    - teleport <player> <context.vehicle.location.sub[<context.vehicle.flag[sit.offset]>].with_yaw[<player.location.yaw>].with_pitch[<player.location.pitch>]>
    - remove <context.vehicle>