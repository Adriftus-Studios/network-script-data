get_player_display_name:
  type: procedure
  debug: false
  definitions: player
  script:
    - adjust <queue> linked_player:<[player]> if:<[player].exists>
    - if <server.has_flag[player_map.uuids.<player.uuid>.display_name]>:
      - determine <server.flag[player_map.uuids.<player.uuid>.display_name]>
    - else if <server.has_flag[player_map.uuids.<player.uuid>.name]>:
      - determine <server.flag[player_map.uuids.<player.uuid>.name]>
    - else:
      - determine <player.name>