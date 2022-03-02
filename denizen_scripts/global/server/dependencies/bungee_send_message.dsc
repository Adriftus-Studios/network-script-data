bungee_send_message:
  type: task
  debug: false
  definitions: uuid|message
  script:
    - if <server.has_flag[player_map.uuids.<[uuid]>.server]> && <server.flag[player_map.uuids.<[uuid]>.server]> == <bungee.server>:
      - narrate <[message]> targets:<player[<[uuid]>]>
    - else:
      - bungeerun <server.flag[player_map.uuids.<[uuid]>.server]> bungee_send_message def:<[uuid]>|<[message]>
