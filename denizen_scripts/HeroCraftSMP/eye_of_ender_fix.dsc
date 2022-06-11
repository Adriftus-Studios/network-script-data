eye_of_ender_fix:
  type: world
  debug: false
  events:
    on ender_signal spawns bukkit_priority:MONITOR:
      - adjust <context.entity> ender_eye_target_location:eye_of_ender_location