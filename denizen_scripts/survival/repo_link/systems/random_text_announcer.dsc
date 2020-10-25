random_text_announcer:
  type: world
  debug: false
  events:
  on system time minutely every 30:
  - choose <util.random.8>:
    - case 1:
      - narrate "<&c>When was the last time you had a glass of delicious, delicious water?"
    - case 2:
      - define URL https://discord.adriftus.com
      - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
      - define Text "<&c>Have you joined our community on <&b>Discord?"
      - narrate <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
    - case 3:
      - define URL https://github.com/Adriftus-Studios/network-script-data/issues
      - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
      - define Text "Got a feature request? Open an issue on our GitHub!"
      - narrate <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
    - case 4:
      - define URL https://github.com/Adriftus-Studios/network-script-data/issues
      - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
      - define Text "Got a feature request? Open an issue on our GitHub!"
      - narrate <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
    - case 5:
      - define URL https://www.adriftus.com/
      - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
      - define Text "<&c>Check out our community forums for all the latest information!"
      - narrate <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
    - case 6:
      - narrate "<&c>Did you know you could store books in a bookshelf using <&b>right click while sneaking?"
    - case 7:
      - define Hover "<proc[Colorize].context[I've heard 3 potatoes and an onion make a delicious soup|green]>"
      - define Text "<&c>Have you found any <&b>Custom Recipes<&c>?"
      - narrate <proc[MsgHover].context[<[Hover]>|<[Text]>]>
    - case 8:
      - narrate "<&c>You have been online for <&b><util.time_now.duration_since[<player.flag[LoginTime]>].formatted><&b>. Time for a posture check!"
    - case 9:
      - narrate "<&c>Did you just hear a <&a>creeper <&c>behind you?"
