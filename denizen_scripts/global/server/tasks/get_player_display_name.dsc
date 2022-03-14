get_player_display_name:
  type: procedure
  debug: false
  script:
    - if <yaml.list.contains[global.player.<player.uuid>]>:
      - if <yaml[global.player.<player.uuid>].contains[masks.current]>:
        - determine <yaml[global.player.<player.uuid>].read[masks.current.display_name]>
      - else:
        - determine <player.name>
    - else:
      - determine <player.name>