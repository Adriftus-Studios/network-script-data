teleport_to_spawn:
  type: task
  debug: false
  script:
    - teleport <player> <server.worlds.first.spawn_location>

respawn_handler:
  type: world
  debug: false
  events:
    on player respawns elsewhere:
      - if !<context.is_bed_spawn>:
        - determine <world[HeroCraft].spawn_location>