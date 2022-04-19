command_vanish:
  type: command
  name: vanish
  debug: false
  script:
  - stop if:<player.has_permission[admin].not>
  - if <player.has_flag[vanish]>:
    - flag <player> vanish:!
    - adjust <player> show_to_players
  - else:
    - flag <player> vanish
    - adjust <player> hide_from_players