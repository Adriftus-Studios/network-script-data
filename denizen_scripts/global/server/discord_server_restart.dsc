discord_server_restart:
  type: task
  debug: true
  definitions: duuid|delay|log|confirmation
  script:
    - announce "<&e>Server restart in<&6>: <&2>[<&a><duration[<[delay]>].formatted><&2>]"
    - flag server queue.restart:<[duuid]>

    - wait <duration[<[delay]>]>

    - waituntil rate:1s <bungee.connected>
    - flag server queue.return_players:!|:<server.online_players>

    - foreach <server.online_players> as:Player:
      - adjust <[player]> send_to:hub1
      - bungeerun hub1 restart_player_retrieve def:<[Player]>|<bungee.server>

    - if <[Log]> || <[Confirmation]>:
      - flag server queue.startup_logger_response:!|:<bungee.server>|<[duuid]>|<[log]>|<[confirmation]>

    - execute as_server save-all
    - wait 2s
    - adjust server restart
