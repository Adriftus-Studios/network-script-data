location_remove_flags:
  type: task
  debug: false
  script:
    - foreach <context.location.flag[remove_flags]>:
      - flag <context.location> <[value]>:!
    - flag <context.location> remove_flags:!

entity_remove_flags:
  type: task
  debug: false
  script:
    - foreach <context.entity.flag[remove_flags]>:
      - flag <context.entity> <[value]>:!
    - flag <context.entity> remove_flags:!