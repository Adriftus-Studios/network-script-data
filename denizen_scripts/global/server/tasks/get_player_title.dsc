get_player_title:
  type: procedure
  debug: false
  definitions: player
  script:
    - if <yaml.list.contains[global.player.<player.uuid>]> && <yaml[global.player.<player.uuid>].contains[masks.current]>:
      - determine <&d>DISGUISED
    - define player <[player].if_null[<player>]>
    - determine <yaml[global.player.<[player].uuid>].parsed_key[titles.current_tag]||<yaml[global.player.<[player].uuid>].parsed_key[titles.current_tag]||<&7>>><&r>
