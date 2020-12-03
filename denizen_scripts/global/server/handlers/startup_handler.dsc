Restart_Handler:
  type: world
  debug: false
  events:
    on server start:
      - waituntil rate:1s <bungee.connected>

      - if <server.has_flag[Queue.Startup_Logger_Response]>:
        - bungeerun Relay Restart_Confirmation_Response def:<server.flag[Queue.Startup_Logger_Response]>

      - if !<server.has_flag[Queue.Return_Players]>:
        - stop

      - define Players <server.flag[Queue.Return_Players]>
      - if !<[Players].is_empty>:
        - foreach <[Players]> as:Player:
          - bungeerun hub Restart_Player_Return def:<[Player]>|<bungee.server>
      - flag server Queue.Return_Players:!
