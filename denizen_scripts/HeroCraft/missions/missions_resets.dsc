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
        - flag server next_reset_daily:<util.time_now.next_hour_of_day[11]>
        - run missions_reset def:daily
        # Weekly reset
        - if <util.time_now.day_of_week_name> == TUESDAY:
          - flag server next_reset_weekly:<util.time_now.next_day_of_week[TUESDAY].add[11h]>
          - run missions_reset def:weekly
        # Monthly reset
        - if <util.time_now.day> == 1:
          - flag server next_reset_monthly:<util.time_now.next_day_of_month[1].add[11h]>
          - run missions_reset def:monthly
