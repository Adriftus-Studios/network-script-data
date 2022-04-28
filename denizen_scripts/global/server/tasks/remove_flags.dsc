location_remove_flags:
  type: task
  debug: false
  script:
    - foreach <context.location.flag[remove_flags]>:
      - flag <context.location> <[value]>:!

entity_remove_flags:
  type: task
  debug: false
  script:
    - foreach <context.entity.flag[remove_flags]>:
      - flag <context.entity> <[value]>:!