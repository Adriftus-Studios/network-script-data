only_target_players:
  type: task
  debug: false
  script:
    - if <context.target.entity_type> != PLAYER:
      - determine cancelled