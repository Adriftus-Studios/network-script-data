location_based_sit_full_block:
  type: task
  debug: false
  script:
    - define direction <context.location.flag[direction]>
    - spawn armor_stand[visible=false;gravity=false] <context.location.center.below[1.2].with_pose[0,<[direction]>].forward[0.25]> save:as
    - flag <entry[as].spawned_entity> on_dismount:sit_entity_remove
    - mount <player>|<entry[as].spawned_entity> <context.location.center.below[1.2].with_pose[0,<[direction]>].forward[0.25]>

sit_entity_remove:
  type: task
  debug: false
  script:
    - wait 1t
    - remove <context.vehicle>