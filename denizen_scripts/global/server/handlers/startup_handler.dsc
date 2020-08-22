Restart_Handler:
  type: world
  debug: true
  events:
    on server start:
      - if !<server.has_flag[Queue.Return_Players]>:
        - stop

      - waituntil rate:1s <bungee.connected>
      - ~bungeetag server:Hub1 <server.online_players> save:Players
      - define Players <server.flag[Queue.Return_Players].shared_contents[<entry[Players].result>]>
      - if <[Players].is_empty>:
        - stop

      - foreach <[Players]> as:Player:
        - bungeerun Hub1 Restart_Player_Return def:<[Player]>|<bungee.server>

      - if <server.has_flag[Queue.Startup_Logger_Response]>:
        - bungeerun Relay Restart_Confirmation_Response def:<server.flag[Queue.Startup_Logger_Response]>
