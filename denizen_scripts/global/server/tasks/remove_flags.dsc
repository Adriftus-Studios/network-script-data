location_remove_flags:
  type: task
  debug: false
  script:
    - foreach <context.location.flag[flags_to_remove]>:
      - flag <context.location> <[value]>:!

entity_remove_flags:
  type: task
  debug: false
  script:
    - foreach <context.entity.flag[flags_to_remove]>:
      - flag <context.entity> <[value]>:!