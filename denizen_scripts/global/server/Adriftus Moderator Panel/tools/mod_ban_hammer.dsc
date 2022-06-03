# MOD BAN HAMMER
mod_ban_hammer_events:
  type: task
  debug: false
  events:
    on player drops mod_ban_hammer_item:
      - define target <player.precise_target[10].if_null[null]>
      - if <[target]> != null && <[target].entity_type> == PLAYER:
        - define uuid <[target].uuid>
        - inject mod_initialize
        - inject mod_ban_inv_open
