early_join_prevention:
  type: world
  debug: false
  events:
    on server start:
      - flag server protected
      - wait 10s
      - flag server protected:!
    on player logs in server_flagged:protected:
      - determine "KICKED:<&6>Server is still booting..."