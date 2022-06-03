# MOD BAN HAMMER
mod_ban_hammer_task:
  type: task
  debug: false
  script:
    - if <context.entity.entity_type> != PLAYER:
      - stop
    - define uuid <context.entity.uuid>
    - inject mod_initialize
    - inject mod_ban_inv_open
