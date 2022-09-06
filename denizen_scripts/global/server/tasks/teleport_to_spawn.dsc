teleport_to_spawn:
  type: task
  debug: false
  script:
    - if <player.has_flag[pvp]>:
      - narrate "<&c>You cannot teleport when in PvP."
      - stop
    - if <player.location.town.exists> && <player.location.towny_type> == jail:
      - narrate "<&c>You cannot return to spawn from a Jail plot."
      - stop
    - teleport <player> <server.worlds.first.spawn_location>

respawn_handler:
  type: world
  debug: false
  events:
    on player respawns elsewhere:
      - if !<context.is_bed_spawn>:
        - determine <world[HeroCraft].spawn_location>