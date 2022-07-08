no_join:
  type: world
  debug: false
  events:
    on player logs in:
      - if !<player.has_permission[adriftus.admin]>:
        - determine "KICKED:Development Lockdown - Please wait."