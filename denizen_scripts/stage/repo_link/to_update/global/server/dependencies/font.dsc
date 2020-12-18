Colorize:
  type: procedure
  debug: false
  definitions: string|color
  script:
    - choose <[Color]>:
      - case Blue:
        ## color tone,  60%  |  main accent, 67%  |  symbols etc, 33%
        - define 1 <&color[#33ffff]>
        - define 2 <&b>
        - define 3 <&3>
      - case Green:
        - define 1 <&color[#33ff33]>
        - define 2 <&a>
        - define 3 <&2>
      - case Very_Red Deep_Red Dark_Red:
        - define 1 <&color[#cc0000]>
        - define 2 <&4>
        - define 3 <&color[#ff0000]>
      - case Red:
        - define 1 <&color[#ff3333]>
        - define 2 <&c>
        - define 3 <&4>
      - case Red_Bold:
        - define 1 <&color[#ff3333]><&l>
        - define 2 <&c><&l>
        - define 3 <&4><&l>
      - case Orange:
        - define 1 <&color[#ff9933]>
        - define 2 <&color[#ffb366]>
        - define 3 <&color[#b35900]>
      - case Purple:
        - define 1 <&color[#ff33ff]>
        - define 2 <&d>
        - define 3 <&5>
      - case Yellow:
        ## color tone,  70%  |  main accent, 85%  |  symbols etc, 60%
        - define 1 <&color[#ffe066]>
        - define 2 <&color[#f4ffb3]>
        - define 3 <&color[#ffcc00]>
      - case Gray:
        - define 1 <&color[#999999]>
        - define 2 <&7>
        - define 3 <&8>
    - define text <list>
    - foreach <[string].to_list> as:character:
      - if "<[character].matches_character_set[ <n>]>":
        - define text <[text].include_single[<[character]>]>
      - else if <[character].matches_character_set[ABCDEFGHIJKLMNOPQRSTUVWXYZ]>:
        - define text <[text].include_single[<[1]><[character]>]>
      - else if <[character].matches_character_set[abcdefghijklmnopqrstuvwxyz]>:
        - define text <[text].include_single[<[2]><[character]>]>
      - else:
        - define text <[text].include_single[<[3]><[character]>]>
    - determine <[text].unseparated>

Colorize_Green:
  type: format
  debug: false
  format: <proc[Colorize].context[<text>|green]>
Colorize_Yellow:
  type: format
  debug: false
  format: <proc[Colorize].context[<text>|yellow]>
Colorize_Very_Red:
  type: format
  debug: false
  format: <proc[Colorize].context[<text>|very_red]>
Colorize_Red:
  type: format
  debug: false
  format: <proc[Colorize].context[<text>|red]>
Colorize_Orange:
  type: format
  debug: false
  format: <proc[Colorize].context[<text>|orange]>
Colorize_Blue:
  type: format
  debug: false
  format: <proc[Colorize].context[<text>|blue]>

Accept_Cmd:
  type: format
  debug: false
  format: <&color[#C1F2F7]>| <proc[msg_cmd].context[<[hover]>|<&a><&lb><&2><&l><&chr[2714]><&r><&a><&rb>|<[command]>]> <&color[#C1F2F7]>| <text>

Decline_Cmd:
  type: format
  debug: false
  format: <&color[#C1F2F7]>| <proc[msg_cmd].context[<[hover]>|<&c><&lb><&4><&chr[2716]><&c><&rb>|<[command]>]> <&color[#C1F2F7]>| <text>

Accept_Script:
  type: format
  debug: false
  format: <&color[#C1F2F7]>| <proc[msg_script].context[<[hover]>|<&a><&lb><&2><&l><&chr[2714]><&r><&a><&rb>|<[script]>]> <&color[#C1F2F7]>| <text>

Decline_Script:
  type: format
  debug: false
  format: <&color[#C1F2F7]>| <proc[msg_script].context[<[hover]>|<&c><&lb><&4><&chr[2716]><&c><&rb>|<[script]>]> <&color[#C1F2F7]>| <text>
