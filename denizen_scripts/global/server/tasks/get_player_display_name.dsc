get_player_display_name:
  type: procedure
  debug: false
  definitions: player
  script:
    - define player <player> if:<[player].exists.not>
    - stop if:<[player].equals[player]>
    - if <server.has_flag[player_map.uuids.<[player].uuid>.display_name]>:
      - determine <&translate[adriftus.user.display_name].with[<server.flag[player_map.uuids.<[player].uuid>.display_name]>|<&7>(<&f><[player].name><&7>)<&f>]>
    - else if <yaml[global.player.<[player]>].contains[display.color]>:
      - determine <yaml[global.player.<[player]>].parsed_key[display.color]><[player].name>
    - else:
      - determine <[player].name>
