spawn_set_adventure_mode:
  type: world
  debug: false
  events:
    on player changes world from spawn:
      - if !<player.has_permission[adriftus.staff]>:
        - adjust <player> gamemode:survival
    on player changes world to spawn:
      - if !<player.has_permission[adriftus.staff]>:
        - adjust <player> gamemode:adventure
