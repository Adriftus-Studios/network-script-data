random_text_announcer:
  type: world
  debug: false
  events:
    on system time minutely every:30:
      - choose <util.random.int[1].to[10]>:
        - case 1:
          - announce "<&e>When was the last time you had a glass of delicious, delicious water?"
        - case 2:
          - define URL https://discord.adriftus.com
          - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
          - define Text "<&e>Have you joined our community on <&3>D<&b>iscord?"
          - announce <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
        - case 3:
          - define URL https://github.com/Adriftus-Studios/network-script-data/issues
          - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
          - define Text "<&e>Got a feature request? Open an issue on our <&3>G<&b>it<&3>H<&b>ub!!"
          - announce <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
        - case 4:
          - define URL https://github.com/Adriftus-Studios/network-script-data/issues
          - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
          - define Text "<&e>Got a feature request? Open an issue on our <&3>G<&b>it<&3>H<&b>ub!!"
          - announce <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
        - case 5:
          - define URL https://www.adriftus.com/
          - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
          - define Text "<&e>Check out our community forums for all the latest information!"
          - announce <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
        - case 6:
          - announce "<&e>Did you know you could store books in a bookshelf using <&b>right click while sneaking?"
        - case 7:
          - define Hover "<proc[Colorize].context[I've heard 3 potatoes and an onion make a delicious soup|green]>"
          - define Text "<&c>Have you found any <&b>Custom Recipes<&c>?"
          - narrate <proc[Msg_Hover].context[<[Hover]>|<[Text]>]>
        - case 8:
          - narrate targets:<server.online_players> per_player "<&e>You have been online for <&b><util.time_now.duration_since[<player.flag[LoginTime]>].formatted><&b>. Time for a posture check!"
        - case 9:
          - announce "<&e>Did you just hear a <&c>creeper <&e>behind you?"
        - case 10:
          - announce "<&e>Did you know you can vote while offline, and still get rewards?"
