get_player_title:
  type: procedure
  debug: false
  definitions: player
  script:
  - define player <[player].if_null[<player>]>
  - determine <yaml[global.player.<[player].uuid>].parsed_key[titles.current_tag]||<yaml[global.player.<[player].uuid>].parsed_key[titles.current_tag]||<&7>>>
