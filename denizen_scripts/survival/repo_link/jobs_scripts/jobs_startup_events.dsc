server_double_xp_setting:
  type: world
  debug: false
  events:
    on server start:
      - if <util.time_now.day_of_week> == 6:
        - flag server jobs.weekend_boost:2 duration:48h
        - wait 10t
      - inject server_jobs_reward_multiplier
