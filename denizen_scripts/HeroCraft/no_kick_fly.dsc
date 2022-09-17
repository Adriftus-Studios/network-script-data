no_kick_flying:
  type: world
  debug: false
  events:
    on player kicked for flying:
      - determine passively cancelled
      - determine FLY_COOLDOWN:1m