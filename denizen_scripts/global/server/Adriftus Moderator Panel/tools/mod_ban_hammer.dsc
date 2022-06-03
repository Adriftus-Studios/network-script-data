# MOD BAN HAMMER
mod_ban_hammer_events:
  type: task
  debug: false
  events:
    on player damages player with:mod_ban_hammer_item:
      - determine passively cancelled
      - define uuid <context.entity.uuid>
      - inject mod_initialize
      - inject mod_ban_inv_open
