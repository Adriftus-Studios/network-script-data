player_joins_server:
  type: world
  events:
    on player logs in for the first:
      - flag player first_joined:true
    on player joins:
      - if <player.has_flag[first_joined]>:
        - teleport spawn
        - flag player first_joined:!
        - narrate "<&2>- - - - - - - - - - - - - - - - - - - -<&nl><&nl>       <&6>Welcome to <&2><&l>Adriftus MC<&r><&6> <player.display_name>!<&nl><&nl><&2>- - - - - - - - - - - - - - - - - - - -"
      - else:
        - narrate "<&2>- - - - - - - - - - - - - - - - - - - -<&nl><&nl>       <&6>Welcome back to <&2><&l>Adriftus MC<&r><&6> <player.display_name>!<&nl><&nl><&2>- - - - - - - - - - - - - - - - - - - -"