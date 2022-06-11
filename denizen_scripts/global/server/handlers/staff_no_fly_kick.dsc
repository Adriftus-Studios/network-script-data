staff_no_fly_kick:
  type: world
  debug: false
  events:
    on player kicked for flying permission:adriftus.staff:
      - determine passively cancelled
      - determine FLY_COOLDOWN:1m