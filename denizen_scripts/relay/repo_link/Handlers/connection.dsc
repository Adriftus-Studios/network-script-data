# $ ███████████████████████████████████████████████████████████
# - ██    Server Start | Stop Events
# ^ ██
# - ██  [ Discord Handlers ] ██
Connection_Handler:
  type: world
  debug: false
  events:
# % ██ [ Server Startup       ] ██
    on server start:
      - announce to_console "<&2>██ <&a>[ <&e>Discord Connections start in<&6>: <&e>13s <&a>] <&2>██"
      - wait 13s
      - yaml load:data/tokens.yml id:tokens
      - ~discordconnect id:a_bot token:<secret[a_token]>
      - ~discordconnect id:c_bot token:<secret[c_token]>

# % ██ [ Server Shutdown      ] ██
    on shutdown:
      - discord id:a_bot disconnect
      - discord id:c_bot disconnect
