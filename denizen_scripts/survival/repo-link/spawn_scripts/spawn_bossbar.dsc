spawn_bossbar:
  type: world
  debug: true
  events:
    on server starts:
      - bossbar spawn_bossbar title:<&2>Adriftus<&sp>Spawn color:green flags:create_fog players:<cuboid[spawn_cuboid].players>
    on script reload:
      - if <server.current_bossbars.contains[spawn_bossbar]>:
        - bossbar remove spawn_bossbar
      - bossbar spawn_bossbar title:<&2>Adriftus<&sp>Spawn color:green flags:create_fog players:<cuboid[spawn_cuboid].players>
    on player enters spawn_cuboid:
      - wait 1t
      - if !<server.current_bossbars.contains[spawn_bossbar]>:
        - bossbar spawn_bossbar title:<&2>Adriftus<&sp>Spawn color:green flags:create_fog players:<cuboid[spawn_cuboid].players>
      - else:
        - bossbar update spawn_bossbar players:<cuboid[spawn_cuboid].players>
    on player exits spawn_cuboid:
      - wait 1t
      - if <server.current_bossbars.contains[spawn_bossbar]>:
        - bossbar remove spawn_bossbar
      - if !<cuboid[spawn_cuboid].players.is_empty>:
        - bossbar spawn_bossbar title:<&2>Adriftus<&sp>Spawn color:green flags:create_fog players:<cuboid[spawn_cuboid].players>
