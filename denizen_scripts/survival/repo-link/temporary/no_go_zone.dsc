no_go_zone:
  type: world
  events:
    on player enters no_go_zone:
      - if !<player.has_permission[adriftus.admin]>:
        - narrate "<&c>This area is not ready yet."
        - determine cancelled
