Restart_Handler:
  type: world
  debug: true
  events:
    on server start:
      - if !<server.has_flag[Queue.Return_Players]>:
        - stop

      - waituntil rate:1s <bungee.connected>

      - define Players <server.flag[Queue.Return_Players]>
      - if !<[Players].is_empty>:
        - foreach <[Players]> as:Player:
          - bungeerun Hub1 Restart_Player_Return def:<[Player]>|<bungee.server>
      - flag server Queue.Return_Players:!

      - if <server.has_flag[Queue.Startup_Logger_Response]>:
        - bungeerun Relay Restart_Confirmation_Response def:<server.flag[Queue.Startup_Logger_Response]>
