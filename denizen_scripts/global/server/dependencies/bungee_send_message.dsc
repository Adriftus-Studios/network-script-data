bungee_send_message:
  type: task
  debug: false
  definitions: uuid|message|save_to_history
  script:
    - define save_to_history false if:<[save_to_history].exists.not>
    - if <server.has_flag[player_map.uuids.<[uuid]>.server]> && <server.flag[player_map.uuids.<[uuid]>.server]> == <bungee.server>:
      - narrate <[message]> targets:<player[<[uuid]>]>
      - define map <map[time=<server.current_time_millis>;message=<[message]>]>
      - run global_player_data_message_history def:<[uuid]>|<[map]>
    - else:
      - bungeerun <server.flag[player_map.uuids.<[uuid]>.server]> bungee_send_message def:<[uuid]>|<[message]>|<[save_to_history]>