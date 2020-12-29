vote_GUI_test:
  type: inventory
  debug: false
  inventory: chest
  size: 45
  custom:
    lotto_slots: 13|14|15|22|23|24|31|32|33
  definitions:
    filler: <item[black_stained_glass_pane]>
    rotating: "<item[<list[red|blue|magenta|orange|purple|yellow|lime|pink|cyan].random>_stained_glass_pane].with[display_name=<&e>Click to Select]>"
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [rotating] [rotating] [rotating] [filler] [filler] [filler]
    - [filler] [filler] [filler] [rotating] [rotating] [rotating] [filler] [filler] [filler]
    - [filler] [filler] [filler] [rotating] [rotating] [rotating] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

vote_GUI_test_open:
  type: task
  debug: false
  definitions: choices
  script:
    - flag player vote_roulette
    - define inventory <inventory[vote_GUI_test]>
    - note <inventory[vote_GUI_test]> as:lotto_<player.uuid>
    - inventory open d:lotto_<player.uuid>
    - repeat 40:
      - narrate <[value]>
      - foreach <script[vote_GUI_test].data_key[custom.lotto_slots]> as:slot:
        - inventory set slot:<[slot]> d:<inventory[lotto_<player.uuid>]> o:<list[red|blue|magenta|orange|purple|yellow|lime|pink|cyan].random>_stained_glass_pane
      - wait 1t
    - repeat 20:
      - narrate <[value]>
      - foreach <script[vote_GUI_test].data_key[custom.lotto_slots]> as:slot:
        - inventory set slot:<[slot]> d:<inventory[lotto_<player.uuid>]> o:<list[red|blue|magenta|orange|purple|yellow|lime|pink|cyan].random>_stained_glass_pane
      - wait 2t
    - repeat 20:
      - narrate <[value]>
      - foreach <script[vote_GUI_test].data_key[custom.lotto_slots]> as:slot:
        - inventory set slot:<[slot]> d:<inventory[lotto_<player.uuid>]> o:<list[red|blue|magenta|orange|purple|yellow|lime|pink|cyan].random>_stained_glass_pane
      - wait 3t
    - repeat 20:
      - narrate <[value]>
      - foreach <script[vote_GUI_test].data_key[custom.lotto_slots]> as:slot:
        - inventory set slot:<[slot]> d:<inventory[lotto_<player.uuid>]> o:<list[red|blue|magenta|orange|purple|yellow|lime|pink|cyan].random>_stained_glass_pane
      - wait 4t
    - flag player vote_roulette:!
    - repeat <[choices]||1>:
      - define list:|:<yaml[daily_reward].read[items_to_win.items].random>
    - flag player vote_win:!|:<[list]>

vote_GUI_test_events:
  type: world
  events:
    on player clicks item in vote_GUI_test priority:100:
      - determine passively cancelled
    on player clicks *glass_pane in vote_GUI_test flagged:vote_win:
      - ratelimit <player> 2t
      - if <player.has_flag[vote_roulette]>:
        - stop
      - wait 1t
      - if !<context.item.material.name.starts_with[black]>:
        - define win <player.flag[vote_win].first.as_item>
        - inventory set d:lotto_<player.uuid> slot:<context.slot> "o:<[win].with[display_name=<&e>You won <&b><[win].material.name.replace[_].with[<&sp>].to_titlecase><&e>!]>"
        - flag player vote_win:<-:<player.flag[vote_win].first>
        - narrate "<&e>You won <&b><[win].material.name.replace[_].with[<&sp>].to_titlecase><&e>!"
        - give <[win]>
        - if !<player.has_flag[vote_win]>:
          - wait 3s
          - note remove as:lotto_<player.uuid>
          - inventory close
    on player closes vote_GUI_test flagged:vote_win:
      - inventory open d:lotto_<player.uuid>
      - narrate "<&c>You have <&b><player.flag[vote_win].size> <&c> reward remaining!"
    on player closes vote_GUI_test flagged:vote_roulette:
      - inventory open d:lotto_<player.uuid>
