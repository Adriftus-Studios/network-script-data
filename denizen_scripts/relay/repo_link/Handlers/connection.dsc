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
    - yaml load:data/token.yml id:AdriftusBot_temp
    - ~discord id:AdriftusBot connect code:<yaml[AdriftusBot_temp].read[AdriftusBotToken]>
    - wait 3s
    - ~run channel_cache
    
# % ██ [ Server Shutdown      ] ██
    on shutdown:
      - discord id:AdriftusBot disconnect
