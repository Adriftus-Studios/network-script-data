dungeon_skeleton_1:
  type: entity
  debug: false
  entity_type: skeleton
  flags:
    on_combust: cancel
    on_damaged: dungeon_skeleton_murder_dog
    on_entity_added: remove_entity_1_tick
  mechanisms:
    custom_name: <&f>Thorny Skeleton
    custom_name_visible: true

dungeon_skeleton_murder_dog:
  type: task
  debug: false
  script:
    - if <context.attacker.entity_type> == wolf:
      - hurt <context.attacker> 5