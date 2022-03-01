gateway_teleport:
  type: world
  debug: false
  events:
    on player teleports cause:END_GATEWAY:
      - define gateway <player.location.find_blocks[end_gateway].within[2].get[1]>
      - if <[gateway].has_flag[destination.location]>:
        - if <bungee.connected> && <[gateway].flag[destination.server]||null> != <bungee.server>:
          - determine passively cancelled
          - ratelimit <player> 5t
          - bungeerun <[gateway].flag[destination.server]> gateway_teleport_bungee def:<player.uuid>|<[gateway].flag[destination.location]>
          - wait 1t
          - adjust <player> send_to:<[gateway].flag[destination.server]>
          - stop
        - adjust <player> fall_distance:0
        - determine passively cancelled
        - teleport <[gateway].flag[destination.location].parsed>

gateway_teleport_bungee:
  type: task
  debug: false
  definitions: uuid|location
  script:
    - flag server join_location.<[uuid]>:<[location]>