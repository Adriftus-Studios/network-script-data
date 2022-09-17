fake_wall_entity:
  type: entity
  debug: false
  entity_type: falling_block
  mechanisms:
    fallingblock_drop_item: false
    gravity: false
    time_lived: -2147483647
  flags:
    on_entity_added: fake_wall_set_lived

fake_wall_set_lived:
  type: task
  debug: false
  script:
    - adjust <context.entity> time_lived:-2147483647
