remove_entity_1_tick:
  type: task
  debug: false
  script:
    - if <context.entity.is_spawned>:
      - remove <context.entity>