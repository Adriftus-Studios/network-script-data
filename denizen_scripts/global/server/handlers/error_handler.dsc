error_handler:
  type: world
  debug: false
  events:
    on server start:
      - yaml id:error_handler create
    on script generates error:
    # % ██ [ disable /ex error handling     ] ██
      - if <context.queue.id.starts_with[excommand]||false>:
        - announce to_console "<context.queue.id||false> not pursuing error handler."
        - stop

      #- determine passively cancelled

    # % ██ [ verify connection             ] ██
      - define timeout <util.time_now.add[1m]>
      - waituntil <bungee.connected> || <[timeout].duration_since[<util.time_now>]> != 0
      - if !<bungee.connected> || <context.queue.id||invalid> == invalid || !<list[hub1|behrcraft|survival|relay|xeane|gielinor].contains[<bungee.server>]>:
        - stop

    # % ██ [ track errors                  ] ██
      - if <context.script||invalid> != invalid:
        - if <yaml[error_handler].contains[<context.script.name>]>:
          - define rate_limit <util.time_now.duration_since[<yaml[error_handler].read[<context.script.name>].highest[epoch_millis]>].in_seconds>
        - yaml id:error_handler set <context.script.name>:->:<util.time_now>
        - if <[rate_limit]||invalid> != invalid && <[rate_limit]> < 5:
          - stop
        - define error_count <yaml[error_handler].read[<context.script.name>].size>

    # % ██ [ cache the information needed  ] ██
      - define data <map.with[server].as[<bungee.server>]>
      - if <context.queue.player||invalid> != invalid:
        - define player_map <map.with[name].as[<queue.player.name>].with[uuid].as[<queue.player.uuid>]>
        - define data <[data].with[player].as[<[player_map]>]>
      - if <context.script.name||invalid> != invalid:
        - define script_map <map.with[name].as[<context.script.name>].with[line].as[<context.line||invalid>].with[file_location].as[<context.script.filename||invalid>].with[error_count].as[<[error_count]>]>
        - define data <[data].with[script].as[<[script_map]>]>
      - define data <[data].with[message].as[<context.message>]>
      - define data <[data].with[definition_map].as[<context.queue.definition_map>]>

    # % ██ [ send to relay                 ] ██
      - bungeerun relay error_response_webhook def:<[data]>
