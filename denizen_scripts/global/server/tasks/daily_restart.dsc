daily_restart_server:
  type: task
  debug: false
  script:
    - announce "<&c>Server is Restarting...."
    - wait 5s
    - kick <server.online_players> "reason:<&c>Network is Restarting...<&nl><&e>Expected Downtime<&co> <&b>Less Than 5 Minutes"
    - wait 1s
    - adjust server shutdown

protect_server:
  type: task
  debug: false
  script:
    - flag server protected