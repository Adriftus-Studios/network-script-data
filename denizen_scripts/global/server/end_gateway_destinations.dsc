gateway_teleport:
  type: world
  debug: false
  events:
    on player teleports cause:END_GATEWAY:
      - define gateway <player.location.find_blocks[end_gateway].within[2].get[1]>
      - if <[gateway].has_flag[destination.location]>:
        - if <bungee.connected> && <[gateway].has_flag[destination.server]> && <[gateway].flag[destination.server]> != <bungee.server>:
          - ratelimit <player> 5t
          - bungeerun <[gateway].flag[destination.server]> gateway_teleport_bungee def:<player.uuid>|<[gateway].flag[destination.location]>
          - wait 1t
          - adjust <player> send_to:<[gateway].flag[destination.server]>
          - stop
        - adjust <player> fall_distance:0
        - teleport <[gateway].flag[destination.location].parsed>

gateway_teleport_bungee:
  type: task
  debug: false
  definitions: uuid|location
  script:
    - flag server join_location.<[uuid]>:<[location]>