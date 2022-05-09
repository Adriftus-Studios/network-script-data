error_handler:
  type: world
  debug: false
  data:
    enabled_servers:
      - b
      - hub
      - test
      - herocraft
      - zanzabar
  events:
    on server start:
      - yaml id:error_handler create

    on script generates error:
      - announce to_console "ERROR CAPTURED"
    # % ██ [ disable headless queues   ] ██
      - define queue <context.queue.if_null[invalid]>
      - if <[queue]> == invalid:
        - stop

      # % ██ [ disable /ex reporting   ] ██
      - stop if:<[queue].id.starts_with[excommand]>

      # % ██ [ verify connection       ] ██
      - define timeout <util.time_now.add[1m]>
      - waituntil <bungee.connected> || <util.time_now.is_after[<[timeout]>]>
      - stop if:!<bungee.connected>

      # % ██ [ verify enabled          ] ██
      - stop if:!<bungee.server.advanced_matches[<script.data_key[data.enabled_servers]>]>

      # % ██ [ collect queue context   ] ██
      - if <[queue].exists>:
        - define data.queue <[queue].id>
        - define data.definition_map <[queue].definition_map> if:!<[queue].definition_map.is_empty.if_null[true]>

      # % ██ [ collect player context  ] ██
        - if <[queue].player.exists>:
          - define data.player_data.uuid <[queue].player.uuid>
          - define data.player_data.name <[queue].player.name>

      # % ██ [ collect npc context     ] ██
        - if <[queue].npc.exists>:
          - define data.npc_data.name <[queue].npc.name>
          - define data.npc_data.id <[queue].npc.id>
          - define data.npc_data.scripts <[queue].npc.scripts> if:<[queue].npc.scripts.exists>

      # % ██ [ collect script context  ] ██
      - if <context.script.exists>:
        - define data.script_data.script <context.script.name.if_null[invalid]>
        - define data.script_data.line <context.line.if_null[(unknown)]>
        - define data.script_data.file_path <context.script.filename> if:<context.script.filename.exists>
      - else:
        - stop

      # % ██ [ provide other context   ] ██
      - define data.server <bungee.server>

      # % ██ [ track errors            ] ██
      - flag server error_listening.<[queue].id>.<[data.script_data.script]>.<[data.script_data.line]>:->:<context.message.if_null[invalid]> expire:15s
      - if <server.has_flag[error_listening.<[queue].id>.<[data.script_data.script]>.runtime]>:
        - stop
      - yaml id:error_handler set <[data.script_data.script]>:->:<util.time_now>
      - flag server error_listening.<[queue].id>.<[data.script_data.script]>.runtime expire:15s

      - define timeout <util.time_now.add[3s]>
      - wait 1s
      - waituntil <[queue].state> != running || <util.time_now.is_after[<[timeout]>]> rate:1s
      - flag server error_listening.<[queue].id>.<[data.script_data.script]>.runtime:!

      # % ██ [ provide ratelimit       ] ██
      - define error_rate <yaml[error_handler].read[<[data.script_data.script]>].filter[is_after[<util.time_now.sub[1h]>]].size>
      - if <[error_rate]> > 60:
        - define data.rate_limited true
        - if <server.has_flag[error_listening.ratelimited_scripts.<[data.script_data.script]>]>:
          - stop
        - flag server error_listening.ratelimited_scripts.<[data.script_data.script]> expiration:5m
      - define data.error_rate <[error_rate]>

      # % ██ [ collect error context   ] ██
      - define data.content <server.flag[error_listening.<[queue].id>]>

      - bungeerun server:relay error_response def:<[data]>
