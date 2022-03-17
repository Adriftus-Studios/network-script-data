player_display_color_events:
  type: world
  debug: false
  events:
    on player joins:
      - waituntil rate:10t <yaml.list.contains[global.player.<player.uuid>].or[<player.is_online.not>]>
      - if !<player.is_online>:
        - stop
      - if <yaml[global.player.<player.uuid>].contains[display.color]> && <server.flag[player_map.uuids.<player.uuid>.name_color]> != <yaml[global.player.<player.uuid>].read[display.color]>:
        - run network_map_update_name_color def:<player.uuid>|<yaml[global.player.<player.uuid>].read[display.color]>

get_player_display_color:
  type: procedure
  debug: false
  script:
    - determine <server.flag[player_map.uuids.<player.uuid>.name_color].if_null[<&r>]>