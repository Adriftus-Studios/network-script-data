set_xp:
  type: task
  debug: false
  definitions: target|amount
  script:
    - flag server transferred_inventories.<[target].uuid>.xp:<[amount]>

set_xp_fix:
  type: world
  debug: false
  events:
    after player joins:
      - if <server.has_flag[transferred_inventories.<player.uuid>.xp]>:
        - experience set <server.flag[transferred_inventories.<player.uuid>.xp]>
        - flag server transferred_inventories.<player.uuid>.xp:!