get_player_title:
  type: procedure
  debug: false
  definitions: player
  script:
    - determine <yaml[global.player.<player.uuid>].parsed_key[titles.current_tag]||<yaml[global.player.<[player].uuid>].parsed_key[titles.current_tag]||<&7>>>
