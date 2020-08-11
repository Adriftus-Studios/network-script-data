no_go_zone:
  type: world
  events:
    on player enters no_go_zone:
      # $ ---- Debugging ------------------------ #
      - inject player_enters_area_debugging.wrapper
      # $ ---- ---------------------------------- #
      - if !<player.has_permission[adriftus.admin]>:
        - narrate "<&c>This area is not ready yet."
        - determine cancelled
