location_based_sit_full_block:
  type: task
  debug: false
  script:
    - stop if:<context.location.has_flag[occupied]>
    - define direction <context.location.flag[direction]>
    - spawn armor_stand[visible=false;gravity=false] <context.location.center.below[1.2].with_pose[0,<[direction]>].forward[0.25]> save:as
    - flag <entry[as].spawned_entity> on_dismounted:sit_entity_remove
    - mount <player>|<entry[as].spawned_entity> <context.location.center.below[1.2].with_pose[0,<[direction]>].forward[0.25]>
    - flag <context.location> occupied:<player>
    - flag <entry[as].spawned_entity> location:<context.location>

sit_entity_remove:
  type: task
  debug: false
  script:
    - wait 1t
    - flag <context.vehicle.flag[location]> occupied:!
    - remove <context.vehicle>
