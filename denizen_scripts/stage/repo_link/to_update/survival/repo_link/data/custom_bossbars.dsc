custom_player_bossbar:
  type: task
  debug: false
  definitions: identifier|text|color1|color2|options
  script:
    - bossbar remove <player.uuid>_bossbar1
    - bossbar remove <player.uuid>_bossbar2
    - inject locally <[identifier]>
  test1:
    - bossbar create <player.uuid>_bossbar2 players:<player> color:white options:<[options]> title:<&color[<[color1]>]><&chr[6905]>
    - bossbar create <player.uuid>_bossbar1 players:<player> color:white options:<[options]> title:<&color[<[color2]>]><[text]>
