player_joins_server:
  type: world
  debug: false
  events:
    on player joins:
      - if !<player.has_flag[first_joined]>:
        - teleport spawn
        - flag player first_joined
        - wait 2s
        - narrate "<&2>- - - - - - - - - - - - - - - - - - - -<&nl><&nl>       <&6>Welcome to <&2><&l>Adriftus MC<&r><&6> <player.display_name>!<&nl><&nl><&2>- - - - - - - - - - - - - - - - - - - -"
      - else:
        - wait 2s
        - narrate "<&2>- - - - - - - - - - - - - - - - - - - -<&nl><&nl>       <&6>Welcome back to <&2><&l>Adriftus MC<&r><&6> <player.display_name>!<&nl><&nl><&2>- - - - - - - - - - - - - - - - - - - -"
