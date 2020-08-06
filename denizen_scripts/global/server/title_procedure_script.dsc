get_player_title:
  type: procedure
  debug: false
  script:
    - determine <yaml[global.player.<player.uuid>].parsed_key[titles.current_tag]||<&7>No<&sp>Title>
