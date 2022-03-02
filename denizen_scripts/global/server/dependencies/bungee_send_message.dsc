bungee_send_message:
  type: task
  debug: false
  definitions: uuid|message
  script:
    - announce "<server.has_flag[player_map.uuids.<[uuid]>.server]> <server.flag[player_map.uuids.<[uuid]>.server]> <bungee.server>"
    - if <server.has_flag[player_map.uuids.<[uuid]>.server]> && <server.flag[player_map.uuids.<[uuid]>.server]> == <bungee.server>:
      - announce "passed"
      - narrate <[message]> targets:<player[<[uuid]>]>
    - else:
      - announce "sending to <server.has_flag[player_map.uuids.<[uuid]>.server]>"
      - bungeerun <server.has_flag[player_map.uuids.<[uuid]>.server]> bungee_send_message def:<[uuid]>|<[message]>
