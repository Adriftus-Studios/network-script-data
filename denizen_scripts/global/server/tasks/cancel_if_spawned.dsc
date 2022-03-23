cancel_if_spawned:
  type: task
  debug: false
  script:
    - narrate <context.entity.is_spawned>
    - determine cancelled if:<context.entity.is_spawned>