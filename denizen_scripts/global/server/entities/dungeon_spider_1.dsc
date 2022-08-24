dungeon_spider_1:
  type: entity
  debug: false
  entity_type: spider
  flags:
    on_combust: cancel
    on_damaged: dungeon_spider_dog_thorns
    on_entity_added: remove_entity_1_tick
  mechanisms:
    custom_name: <&f>Thorny Spider
    custom_name_visible: true

dungeon_spider_murder_dog:
  type: task
  debug: false
  script:
    - if <context.attacker.entity_type> == wolf:
      - hurt <context.attacker> 5