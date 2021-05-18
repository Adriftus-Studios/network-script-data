server_restart_handler_hub:
  type: world
  debug: false
  events:
    on restart command bukkit_priority:highest:
      - determine passively fulfilled
      - if <context.source_type> == server || <player.has_permission[EPH.admin]>:
        - inject survival_restart_timer

    on system time 23:55:
      - inject hub_restart_timer

hub_restart_timer:
    type: task
    debug: false
    script:
      - announce "<&b>The server will be performing a scheduled restart in 5 minutes. Please reach a safe location."
      - flag server restart_in_process duration:5m
      - wait 4.5m
      - announce "<&b>The server will be performing a scheduled restart in 30 seconds. Please reach a safe location."
      - repeat 29:
        - actionbar "<&e>The server will be restarting in <&c><element[31].sub[<[value]>]> <&e>seconds." targets:<server.online_players>
        - wait 1s
