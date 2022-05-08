weather_command:
  type: command
  name: weather
  debug: false
  description: Adjusts the weather to sunny, clear, stormy, or thundery
  usage: /weather <&lt>weather<&gt>
  permission: behr.essentials.weather
  tab completions:
    1: sunny|storm|thunder|clear
  script:
    - if <context.args.is_empty>:
      - if <player.world.has_storm>:
        - if <player.world.thundering>:
          - define weather thunder
        - else:
          - define weather storm
      - else:
        - define weather sunny

      - narrate "<&a>The weather is currently <[weather]>"
      - stop

    - else if <context.args.size> > 1:
      - narrate "<&c>Invalid usage - /weather <&lt>weather<&gt>"

    - else if !<context.args.first.advanced_matches[sunny|storm|thunder]>:
      - narrate "<&c>Invalid usage - the only valid weathers are clear, sunny, storm, and thunder"

    - weather <context.args.first> <player.world>
    - announce "<&a>Weather changed to <context.args.first.to_titlecase>"
