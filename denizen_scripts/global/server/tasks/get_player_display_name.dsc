get_player_display_name:
  type: procedure
  debug: false
  definitions: player
  script:
    - adjust <queue> linked_player:<[player]> if:<[player].exists>
    - if <yaml.list.contains[global.player.<player.uuid>]>:
      - if <yaml[global.player.<player.uuid>].contains[masks.current]>:
        - determine <yaml[global.player.<player.uuid>].read[masks.current.display_name]>
      - else:
        - determine <player.name>
    - else:
      - determine <player.name>