server_restart_handler_survival-plus:
  type: world
  debug: false
  events:
    on restart command:
      - determine passively fulfilled
      - if <context.source_type> == server:
        - inject survival_restart_timer
        - stop
      - if <player.has_permission[*]>:
        - inject survival_restart_timer
    on system time 02:55:
      - inject survival_restart_timer


survival_restart_announcer:
    type: task
    debug: false
    survival_restarter:
      - bungeeexecute "send survival behrcraft"
      - wait 3s
      - adjust server restart
    survival_restart_timer:
      - announce <&b> "The server will be performing a scheduled restart in 5 minutes. Please reach a safe location."
      - flag server restart_in_process duration:5m
      - wait 4m 30s
      - announce <&b> "The server will be performing a scheduled restart in 30 seconds. Please reach a safe location."
      - repeat 15
        - actionbar "<&c>The server will be restarting in <server.flag[restart_in_process].expiration.seconds.round_down[1]> seconds."
        - wait 1s
        - actionbar "<&a>The server will be restarting in <server.flag[restart_in_process].expiration.seconds.round_down[1]> seconds."
        - wait 1s
      - inject survival_restarter locally
