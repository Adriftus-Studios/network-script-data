spawn_set_adventure_mode:
  type: world
  events:
    on player changes world from spawn:
      #- if !<player.has_permission[spawn.gamemode.keep]>:
      - if <player.gamemode> != CREATIVE:
        - adjust <player> gamemode:survival
    on player changes world to spawn:
      #- if !<player.has_permission[spawn.gamemode.keep]>:
      - if <player.gamemode> != CREATIVE:
        - adjust <player> gamemode:adventure
