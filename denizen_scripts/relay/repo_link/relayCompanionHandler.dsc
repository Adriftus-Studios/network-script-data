companion_get_uuid_using_hash:
  type: procedure
  definitions: hash
  script:
    - foreach <server.flag[Hashes].keys> as:value:
      - if <[hash].equals[<server.flag[Hashes.<[value]>.companionHash]>]>:
        - determine <[value]>
    - determine null

companion_get_ip_using_hash:
  type: procedure
  definitions: hash
  script:
    - foreach <server.flag[Hashes].keys> as:value:
      - if <[hash].equals[<server.flag[Hashes.<[value]>.companionHash]>]>:
        - determine <server.flag[Hashes.<[value]>.ipAddress]>
    - determine null

companion_get_data_using_hash:
  type: procedure
  definitions: hash
  script:
    - foreach <server.flag[Hashes].keys> as:value:
      - if <[hash].equals[<server.flag[Hashes.<[value]>.companionHash]>]>:
        - determine <server.flag[Hashes.<[value]>.data].to_json>
    - determine null

companion_generate_hash:
  type: task
  definitions: player|server|ipAddress
  script:
    - if !<server.has_flag[Hashes.<[player].uuid>.companionHash]> :
      - flag server Hashes.<[player].uuid>.companionHash:<util.random.duuid>
      - flag server Hashes.<[player].uuid>.ipAddress:<[ipAddress]>
      - debug debug <server.flag[Hashes.<[player].uuid>.ipAddress]>
      - debug debug <server.flag[Hashes.<[player].uuid>.companionHash]>
    - bungeerun <[server]> companion_hash_set def:<[player].uuid>|<server.flag[Hashes.<[player].uuid>.companionHash]>
    - bungeerun <[server]> companion_hash_return_print def:<[player].uuid>

companion_hash_expire:
    type: task
    definitions: uuid
    script:
        - debug debug "Expire hash"
        - flag server Hashes.<[uuid]>.companionHash:!
        - flag server Hashes.<[uuid]>.ipAddress:!
        - flag server Hashes.<[uuid]>.data:!
        - flag server Hashes.<[uuid]>:!
        - ~bungeetag server:hub <server.flag[<[uuid]>.currentServer]> save:currentServer
        - bungeerun <entry[currentServer].result> companion_hash_expire def:<[uuid]>

companion_hash_handler:
    type: world
    events:
        on bungee player switches to server:
            #Uses mock server details
            - define uuid <context.uuid>
            - if <server.has_flag[Hashes.<[uuid]>.companionHash]> :
              - ~bungeetag server:hub <server.flag[<[uuid]>.oldServer]> save:oldServer
              - bungeerun <entry[oldServer].result> companion_hash_expire def:<[uuid]>
              - bungeerun <context.server> companion_hash_set def:<[uuid]>|<server.flag[Hashes.<[uuid]>.companionHash]>
        on bungee player leaves network:
            - define uuid <context.uuid>
            - if <server.has_flag[Hashes.<[uuid]>.companionHash]> :
              - run companion_hash_expire def:<context.uuid>

companion_data_receive_handler:
  type: task
  debug: false
  definitions: data
  script:
    - foreach <[data].unescaped> as:playerData:
      - flag server Hashes.<[playerData].get[uuid]>.data:<[playerData]>