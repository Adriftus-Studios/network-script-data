player_joins_server:
  type: world
  debug: false
  events:
    on player joins:
      #flag used in random_text_announcer.dsc
      - flag player LoginTime:<util.time_now>
      - if !<player.has_flag[first_joined]>:
        - teleport spawn
        - flag player first_joined
        - wait 2s
        - narrate "<&2>- - - - - - - - - - - - - - - - - - - -<&nl><&nl>       <&6>Welcome to <&2><&l>Adriftus MC<&r><&6> <player.display_name>!<&nl><&nl><&2>- - - - - - - - - - - - - - - - - - - -"
      - else:
        - wait 2s
        - choose <util.random.int[1].to[3]>:
          - case 1:
            - narrate "<&c>Welcome back to the Adriftus survival server! See our other servers with <&6>/<&e>play!"
          - case 2:
            - define URL https://discord.adriftus.com
            - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
            - define Text "<&c>Welcome back to the Adriftus survival server! Have you joined our <&3><&n>D<&b><&n>iscord?"
            - narrate <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
          - case 3:
            - define URL https://github.com/Adriftus-Studios/network-script-data/issues
            - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
            - define Text "<&c>Welcome back to the Adriftus survival server! Got any feedback, or feature requests? Open an issue on our GitHub!"
            - narrate <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
