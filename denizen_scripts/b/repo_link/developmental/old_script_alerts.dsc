old_script_reminder:
  type: world
  debug: false
  events:
    after reload scripts:
      - define old_scripts <server.scripts.filter[name.starts_with[old_]]>
      - if <[old_scripts].is_empty>:
        - stop

      - flag server old_scripts:<[old_scripts]>

    after player joins:
      - if <server.has_flag[old_scripts]> && <player.name.advanced_matches[<server.players.filter[name.contains_any_text[behr]]>]>:
        - narrate "<&4>Old scripts <&6>(<&4><server.flag[old_scripts].size><&6><&co> <&c><server.flag[old_scripts].parse[name].formatted.replace[,].with[<&6>,<&c>]>"
