spawn_time_freezer:
  type: world
  debug: false
  events:
    on server start:
    - gamerule <world[world]> doDaylightCycle false
