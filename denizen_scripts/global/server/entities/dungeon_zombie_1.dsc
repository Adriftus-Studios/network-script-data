dungeon_zombie_1:
  type: entity
  debug: false
  entity_type: zombie
  flags:
    on_combust: cancel
    on_damaged: dungeon_zombie_murder_dog
    on_entity_added: remove_entity_1_tick
  mechanisms:
    custom_name: <&f>Thorny Zombie
    custom_name_visible: true

dungeon_zombie_murder_dog:
  type: task
  debug: false
  script:
    - if <context.damager.entity_type> == wolf:
      - hurt <context.damager> 5