get_player_display_name:
  type: procedure
  debug: false
  definitions: player
  script:
    - define player <player> if:<[player].exists.not>
    - if <server.has_flag[player_map.uuids.<[player].uuid.if_null[invalid]>.display_name].if_null[invalid]>:
        - determine <&translate[adriftus.user.display_name].with[<server.flag[player_map.uuids.<[player].uuid.if_null[invalid]>.display_name].if_null[invalid]>|<&7>(<&f><player.name><&7>)<&f>]>
    - else if <server.has_flag[player_map.uuids.<[player].uuid.if_null[invalid]>.display_color].if_null[invalid]>:
      - determine <&translate[adriftus.user.display_name].with[<server.flag[player_map.uuids.<[player].uuid.if_null[invalid]>.display_color]><player.name.if_null[invalid]>|<&7>(<&f><player.name><&7>)<&f>]>
    - else:
      - determine <[player].name.if_null[invalid]>
