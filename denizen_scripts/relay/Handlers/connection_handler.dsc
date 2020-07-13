# $ ███████████████████████████████████████████████████████████
# - ██    Server Start | Stop Events
# ^ ██
# - ██  [ Discord Handlers ] ██
Connection_Handler:
  type: world
  debug: false
  events:
# - ███ [ Server Startup       ] ███
    on server start:
    - debug debug "# ███ [ Discord Connections start in: 15s ] ███"
    - wait 15s
    - yaml load:data/token.yml id:AuroraBot_temp
    - ~discord id:AuroraBot connect code:<yaml[AuroraBot_temp].read[AdriftusBotToken]>
    - yaml unload id:AuroraBot_temp
# - ███ [ Server Shutdown      ] ███
    on shutdown:
      - discord id:AuroraBot disconnect