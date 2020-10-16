Restart_Player_Retrieve:
  type: task
  debug: true
  definitions: Player|Server
  script:
  # % ██ [ Verify Player by Timeout         ] ██
    - define Timeout <util.time_now.add[1m]>
    - waituntil <[Player].is_online> || <[Timeout].duration_since[<util.time_now>].in_seconds> == 0:
    - if !<[Player].is_online>:
      - stop

    - wait 1s
    - flag <[Player]> Server_Return:<map.with[Server].as[<[Server]>].with[Queue].as[<Queue.ID>]>

  # % ██ [ Message Player with Option       ] ██
    - clickable Cancel_Player_Return def:<[Player]>|<[Server]> usages:1 until:10s save:Cancel_Player_Return
    - define Hover "<proc[Colorize].context[Cancel Server Return.|Red]>"
    - define Text <&c>[<&4><&chr[2716]><&c>]
    - define Decline <proc[msg_hover].context[<[Hover]>|<[Text]>].on_click[<entry[Cancel_Player_Return].command>]>

    - narrate targets:<[Player]> "<[Decline]> <&b>| <&6>[<&e><[Server]><&6>] <&a>is restarting! You've been transferred to the Hub and will be sent back when the server is online."

Restart_Player_Return:
  type: task
  debug: true
  definitions: Player|Server
  script:
    - clickable Cancel_Player_Return def:<[Player]>|<[Server]> usages:1 until:10s save:Cancel_Player_Return
    - define Hover "<proc[Colorize].context[Cancel Server Return.|Red]>"
    - define Text <&c>[<&4><&chr[2716]><&c>]
    - define Decline <proc[msg_hover].context[<[Hover]>|<[Text]>].on_click[<entry[Cancel_Player_Return].command>]>
    - narrate targets:<[Player]> "<[Decline]> <&b>| <&6>[<&e><[Server]><&6>] <&a>is back online! Sending you back in <&e>10 seconds<&a>."

  # % ██ [ Delay & Return Player to Server  ] ██
    - wait 10s
    - if <[Player].has_flag[Server_Return]>:
      - flag <[Player]> Server_Return:!
      - ~bungeetag server:<[Server]> <bungee.connected> save:Response
      - if <entry[Response].result>:
        - adjust <[Player]> send_to:<[Server]>
      - else:
        - narrate "<&e>Nothing interesting happened - could not send you back to <[Server].to_titlecase><&e>."

Cancel_Player_Return:
  type: task
  debug: true
  definitions: Player|Server
  script:
  # % ██ [ Verify if marked for return      ] ██
    - if !<[Player].has_flag[Server_Return]>:
      - narrate "<&c>There is no pending restart request available."
      - stop

  # % ██ [ Cache Data                       ] ██
    - define Data_Map <[Player].flag[Server_Return].as_map>

  # % ██ [ Check for Timed Queues           ] ██
    - if <queue.exists[<[Data_Map].get[Queue]>]>:
      - queue <[Data_Map].get[Queue]> clear

  # % ██ [ Verify Queue                     ] ██
    - flag <[Player]> Server_Return:!
    - narrate "<&e>Cancelled server return."
