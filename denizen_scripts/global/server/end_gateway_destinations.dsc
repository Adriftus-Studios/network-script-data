gateway_teleport:
  type: world
  debug: false
  events:
    on player teleports cause:END_GATEWAY:
      - define gateway <player.location.find_blocks[end_gateway].within[2].get[1]>
      - if <[gateway].has_flag[destination.location]>:
        - playsound sound:ENTITY_ENDERMAN_TELEPORT <[gateway]> pitch:0.1
        - title title:<&color[#000000]><&font[adriftus:overlay]><&chr[0004]><&chr[F801]><&chr[0004]> fade_in:10t fade_out:10t stay:10t
        - determine passively <player.location.forward[0.1]>
        - flag <player> force_tp duration:1s
        - ratelimit <player> 5t
        - if <bungee.connected> && <[gateway].has_flag[destination.server]> && <[gateway].flag[destination.server]> != <bungee.server>:
          - bungeerun <[gateway].flag[destination.server]> gateway_teleport_bungee def:<player.uuid>|<[gateway].flag[destination.location]>
          - wait 1t
          - adjust <player> send_to:<[gateway].flag[destination.server]>
          - wait 1t
          - adjust <player> location:<player.location.backward>
          - stop
        - wait 1t
        - adjust <player> fall_distance:0
        - teleport <[gateway].flag[destination.location].parsed>

gateway_teleport_bungee:
  type: task
  debug: false
  definitions: uuid|location
  script:
    - flag server join_location.<[uuid]>:<[location]>

gateway_teleport_force:
  type: world
  debug: false
  events:
    on player teleports flagged:force_tp bukkit_priority:HIGHEST:
      - determine cancelled:false