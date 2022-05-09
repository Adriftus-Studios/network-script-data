deactive_spawner:
  type: task
  debug: false
  script:
    - if <context.location.spawner_player_range> != 16:
      - stop
    - adjust <context.location> spawner_player_range:0
    - runlater reactivate_spawner delay:30m def:<context.location>

reactivate_spawner:
  type: task
  debug: false
  definitions: location
  script:
    - if !<[location].chunk.is_loaded>:
      - chunkload <[location].chunk> duration:15s
    - adjust <[location]> spawner_player_range:16