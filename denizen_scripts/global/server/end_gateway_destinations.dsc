gateway_teleport:
  type: world
  debug: false
  events:
    on player teleports cause:END_GATEWAY:
      - if <context.origin.has_flag[destination.location]>:
        - if <bungee.connected> && <context.origin.has_flag[destination.server]||null> != <bungee.server>:
          - determine passively cancelled
          - ratelimit <player> 5t
          - bungeerun <context.origin.has_flag[destination.server]> gateway_teleport_bungee def:<player.uuid>|<context.origin.has_flag[destination.location]>
          - wait 1t
          - adjust <player> send_to:<context.origin.has_flag[destination.server]>
        - adjust <player> fall_distance:0
        - determine passively cancelled
        - teleport <context.origin.flag[destination.location].parsed>

gateway_teleport_bungee:
  type: task
  debug: false
  definitions: uuid|location
  script:
    - flag server join_location.<[uuid]>:<[location]>