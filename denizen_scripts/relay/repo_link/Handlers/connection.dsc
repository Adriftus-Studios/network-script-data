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
    - ~discord id:AdriftusBot connect code:<yaml[tokens].read[discord.AdriftusBotToken]>
    - ~discord id:champagne connect code:<yaml[tokens].read[discord.champagne_token]>
    - wait 3s
  #^- ~run channel_cache

# % ██ [ Server Shutdown      ] ██
    on shutdown:
      - discord id:AdriftusBot disconnect
      - discord id:champagne disconnect
