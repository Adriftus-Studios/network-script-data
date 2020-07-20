get_player_title:
  type: procedure
  debug: false
  script:
    - determine <yaml[global.player.<player.uuid>].read[titles.current_tag].parsed||<&7>No<&sp>Title>