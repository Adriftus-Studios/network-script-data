server_restart_handler_survival-plus:
  type: world
  debug: false
  events:
    on restart command:
      - if <context.source_type> == server || <player.has_permission[adriftus.admin]>:
        - inject survival_restart_timer
      - determine fulfilled
    on system time 02:55:
      - inject survival_restart_timer


survival_restart_timer:
    type: task
    debug: false
    script:
      - announce "<&b>The server will be performing a scheduled restart in 5 minutes. Please reach a safe location."
      - flag server restart_in_process duration:5m
      - wait 4.5m
      - announce "<&b>The server will be performing a scheduled restart in 30 seconds. Please reach a safe location."
      - repeat 29:
        - actionbar "<&e>The server will be restarting in <&c><element[31].-[<[value]>]> <&e>seconds." targets:<server.online_players>
        - wait 1s
      - define duuid <util.random.duuid.after[_]>
      - run Discord_Server_Restart def:<[duuid]>|0|false|false
