# MOD BAN HAMMER
mod_ban_hammer_task:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - define target <player.precise_target[20].if_null[null]>
    - if <[target]> != null && <[target].entity_type> == PLAYER:
      - define uuid <[target].uuid>
      - inject mod_initialize
      - inject mod_ban_inv_open
