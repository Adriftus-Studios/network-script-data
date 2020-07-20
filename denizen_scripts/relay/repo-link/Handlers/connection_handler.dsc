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
    - debug debug "# ██ [ Discord Connections start in: 15s ] ██"
    - wait 15s
    - yaml load:data/token.yml id:AdriftusBot_temp
    - ~discord id:AdriftusBot connect code:<yaml[AdriftusBot_temp].read[AdriftusBotToken]>
    
# % ██ [ Server Shutdown      ] ██
    on shutdown:
      - discord id:AdriftusBot disconnect
