# -- MISSIONS RESET SCHEDULE
# -- Daily: 7 AM EDT
# -- Weekly: Tuesday
# -- Monthly: 1st
missions_server_reset:
  type: world
  debug: false
  events:
    on server start:
      # Missions reset
      - foreach <server.players_flagged[missions.active]> as:__player:
        # Daily reset
        - run missions_reset def:daily
        # Weekly reset
        - if <util.time_now.day_of_week_name> == TUESDAY:
          - run missions_reset def:weekly
        # Monthly reset
        - if <util.time_now.day> == 1:
          - run missions_reset def:monthly
