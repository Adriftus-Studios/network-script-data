teleport_to_spawn:
  type: task
  debug: false
  script:
    - if <player.has_flag[pvp]>:
      - narrate "<&c>You cannot teleport when in PvP."
      - stop
    - if <player.is_jailed>:
      - narrate "<&c>You cannot return to spawn while Jailed."
      - stop
    - if <player.location.below.material.name.advanced_matches[*air]>:
      - narrate "<&c>You cannot use this mid-air"
      - stop
    - teleport <player> <server.worlds.first.spawn_location>

respawn_handler:
  type: world
  debug: false
  events:
    on player respawns elsewhere:
      - if !<context.is_bed_spawn>:
        - determine <world[HeroCraft].spawn_location>
