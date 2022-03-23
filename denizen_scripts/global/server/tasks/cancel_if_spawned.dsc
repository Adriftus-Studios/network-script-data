cancel_if_spawned:
  type: task
  debug: false
  script:
    - announce <context.entity.is_spawned>
    - determine cancelled if:<context.entity.is_spawned>