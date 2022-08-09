dungeon_skeleton_1:
  type: entity
  debug: false
  entity_type: skeleton
  flags:
    on_combust: cancel
    on_damaged: dungeon_skeleton_dog_thorns
  mechanisms:
    custom_name: <&f>Thorny Skeleton
    custom_name_visible: true
    on_entity_added: cancel

dungeon_skeleton_murder_dog:
  type: task
  debug: false
  script:
    - if <context.attacker.entity_type> == wolf:
      - hurt <context.attacker> 5