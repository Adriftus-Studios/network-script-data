gateway_teleport:
  type: world
  debug: false
  events:
    on player teleports cause:END_GATEWAY:
      - narrate <context.origin.simple>
      - narrate <player.location.simple>
      - if <context.origin.has_flag[destination.location]>:
        - if <bungee.connected> && <context.origin.flag[destination.server]||null> != <bungee.server>:
          - determine passively cancelled
          - ratelimit <player> 5t
          - bungeerun <context.origin.flag[destination.server]> gateway_teleport_bungee def:<player.uuid>|<context.origin.flag[destination.location]>
          - wait 1t
          - adjust <player> send_to:<context.origin.flag[destination.server]>
          - stop
        - adjust <player> fall_distance:0
        - determine passively cancelled
        - teleport <context.origin.flag[destination.location].parsed>

gateway_teleport_bungee:
  type: task
  debug: false
  definitions: uuid|location
  script:
    - flag server join_location.<[uuid]>:<[location]>