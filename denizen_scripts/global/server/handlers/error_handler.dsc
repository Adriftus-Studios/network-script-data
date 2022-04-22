##IgnoreWarning todo_comment
error_handler:
  type: world
  debug: true
  data:
    enabled_servers:
      - hub
  events:
    on server start:
      - yaml id:error_handler create

    on script generates error:
    # % ██ [ verify incapable halts              ] ██
      - define queue <context.queue.if_null[invalid]>
      - if <context.script.starts_with[error_handler].if_null[false]>:
        - announce to_console "<&4>Warning: Terrible Error"
        - stop
      - if <bungee.server.if_null[relay]> == relay:
        - determine passively cancelled
        - announce to_console <context.message.if_null[invalid]>
        - announce to_console <context.queue.if_null[invalid]>
        - announce to_console <context.script.if_null[invalid]>
        - announce to_console <context.line.if_null[invalid]>
        - stop

    # % ██ [ verify connection                   ] ██
      - define timeout <util.time_now.add[1m]>
      - waituntil <bungee.connected> || <[timeout].duration_since[<util.time_now>]> != 0
      - if !<bungee.connected> || !<context.queue.id.exists> || !<script.data_key[data.enabled_servers].contains[<bungee.server>]>:
        - stop

    # % ██ [ disable /ex error handling          ] ██
      - if <context.queue.id.starts_with[excommand].if_null[false]>:
        - announce to_console "<context.queue.id.if_null[Invalid queue reference]> - not pursuing error handler."
        - stop

    # % ██ [ track errors                        ] ██
      - flag server "error_listening.<[queue].id>.<context.script.if_null[invalid]>.errors.line <context.line.if_null[(unknown)]>:->:<context.message.if_null[null]>" expire:6s
      - yaml id:error_handler set <context.script.name.if_null[invalid]>:<util.time_now>
      - if <server.has_flag[error_listening.<[queue].id>.<context.script.if_null[invalid]>.runtime]>:
        - stop
      # todo ██ [ check if script is a timed queue, add to timer    ] ██
      - flag server error_listening.<[queue].id>.<context.script.if_null[invalid]>.runtime duration:5s

      - define error_count <yaml[error_handler].read[<context.script.if_null[invalid].name>].size.if_null[0]>

    # % ██ [ check ratelimits                    ] ██

      - define timeout <util.time_now.add[2s]>
      - wait 1s

      # todo ██ [ verify if <[queue].state> != running              ] ██
      # | potentially: || <yaml[error_handler].read[<[script].name>].filter[epoch_millis.is_more_than[<util.time_now.sub[5s]>]]>
      - waituntil <util.time_now.is_after[<[timeout]>]>
      # && ( <util.time_now.duration_since[<yaml[error_handler].read[<context.script.name.if_null[invalid]>].highest[epoch_millis]>].in_seconds> < 2 || !<server.has_flag[error_listening.<[queue].id>.<context.script.if_null[invalid]>.runtime]> ) rate:1s
      - flag server error_listening.<[queue].id>.<context.script.if_null[invalid]>.runtime:!

    # % ██ [ cache the information needed  ] ██
      - definemap data:
          queue: <[queue]>
          script: <context.script.if_null[invalid]>
          errors: <server.flag[error_listening.<[queue].id>.<[script].if_null[invalid]>]>
          definition_map: <[queue].definition_map>
          error_count: <[error_count]>
          rate_limited: <[error_count].is_more_than[50]>
          server: <bungee.server>
          message: <context.message.strip_color>

      - define data <[data].with[player].as[<map[name=<queue.player.name>;uuid=<queue.player.uuid>]>]> if:<[queue].player.exists>
      - define data <[data].with[script].as[<map[name=<context.script.name>;file=<context.script.filename>]>]> if:<context.script.exists>

      - stop
    # % ██ [ send to relay                 ] ██
      - bungeerun relay error_response_webhook def:<[data]>
