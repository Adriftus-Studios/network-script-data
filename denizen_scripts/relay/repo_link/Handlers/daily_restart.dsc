daily_restart_handler:
  type: world
  debug: false
  events:
    on system time 11:00:
      - ratelimit <util.time_now.day> 1m
      - run daily_restart_execute

daily_restart_execute:
  type: task
  debug: false
  script:
    - bungeeexecute "alert Network restart begins in 5 minutes..."
    - wait 4m
    - bungeeexecute "alert Network restart begins in 1 minute..."
    - wait 50s
    - bungeeexecute "alert Network restart begins in 10 seconds..."
    - wait 10s
    - bungeerun hub protect_server
    - foreach <bungee.list_servers.exclude[relay|hub]> as:server:
      - bungeerun <[server]> daily_restart_server
      - wait 1m
    - bungeerun hub daily_restart_server
    - wait 30s
    - adjust server shutdown