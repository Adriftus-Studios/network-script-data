# -- MISSIONS BOSSBAR PROGRESS NOTIFICATIONS
missions_bossbar:
  type: task
  debug: false
  definitions: path
  script:
    - stop if:<[path].exists.not>
    # Define variables from path
    - define id <player.flag[<[path]>].get[id]>
    - define name <player.flag[<[path]>].get[name]>
    - define x <player.flag[<[path]>].get[progress]>
    - define y <player.flag[<[path]>].get[max]>
    # Determine colour
    - choose <script[mission_<[id]>].data_key[category]>:
      - case PvE:
        - define color GREEN
      - case Adventure:
        - define color YELLOW
      - case PvP:
        - define color RED
      - default:
        - define color PURPLE
    # Determine type
    - choose <player.flag[<[path]>].get[timeframe]>:
      - case daily:
        - define prefix <&a>Daily
      - case weekly:
        - define prefix <&e>Weekly
      - case monthly:
        - define prefix <&6>Monthly
      - default:
        - define prefix <&b>HeroCraft
    # Set progress, color, and style
    - if <server.current_bossbars.contains[<[path]>].not>:
      - bossbar create <[path]> progress:<[x].div[<[y]>]> color:<[color]> style:SEGMENTED_10
    - else:
      - bossbar update <[path]> progress:<[x].div[<[y]>]> color:<[color]> style:SEGMENTED_10
    # Mission Completed
    - if <[x]> == <[y]>:
      - bossbar update <[path]> "title:<[prefix]><&f><&co> <[name]> <&f>(<&color[#010000]>Completed<&f>)"
    # Mission Progressed
    - else:
      - bossbar update <[path]> "title:<[prefix]><&f><&co> <[name]> <&f>(<&b><[x]><&f>/<&b><[y]><&f>)"
    # 4t * 15 = 60t = 3s
    - repeat 15:
      - bossbar update <[path]> players:<player>
      - wait 4t
    - bossbar remove <[path]> players:<player>

# Remove bossbars on logout
missions_bossbar_remove:
  type: world
  debug: false
  events:
    on player quits:
      - foreach <server.current_bossbars>:
        - bossbar remove <[value]> players:<player>

    on server start:
      - foreach <server.current_bossbars>:
        - bossbar remove <[value]>
