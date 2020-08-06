spawn_time_freezer:
  type: world
  debug: false
  events:
    on server start:
      - while true:
        - adjust <world[spawn]> time:1000
        - wait 1s
