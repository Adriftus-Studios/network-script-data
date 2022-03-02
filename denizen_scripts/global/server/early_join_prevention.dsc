early_join_prevention:
  type: world
  debug: false
  events:
    on server start:
      - flag server protected duration:10s
    on player logs in server_flagged:protected:
      - determine "KICKED:&6Server is still booting."