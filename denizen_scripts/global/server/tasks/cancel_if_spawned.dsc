cancel_if_spawned:
  type: task
  debug: false
  script:
    - determine cancelled if:<context.entity.is_spawned>