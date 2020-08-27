Discord_Server_Restart:
  type: task
  debug: true
  definitions: DUUID|Delay|Log|Confirmation
  script:
    - announce "<&e>Server restart in<&6>: <&2>[<&a><duration[<[Delay]>].formatted><&2>]"
    - flag server Queue.Restart:<[DUUID]>

    - wait <duration[<[Delay]>]>

    - waituntil rate:1s <bungee.connected>
    - flag server Queue.Return_Players:!|:<server.online_players>

    - foreach <server.online_players> as:Player:
      - adjust <[Player]> send_to:hub1
      - bungeerun Restart_Player_Retrieve def:<[Player]>|<bungee.server>

    - if <[Log]> || <[Confirmation]>:
      - flag server Queue.Startup_Logger_Response:<bungee.server>|<[DUUID]>|<[Log]>|<[Confirmation]>

    - adjust server restart
