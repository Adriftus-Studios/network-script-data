companion_web_launch:
  type: world
  events:
    on server start:
      - web start port:25581

companion_web_show:
  type: world
  events:
    on GET request priority:-100:
      - define vars <context.query_map>
      - debug debug <[vars]>
      - if <context.request.equals[/companion]>:
        #IP from the web server filtered to show just the numbers
        - define ip <context.address.replace_text[/].with[].split[:]>
        #Ip that was sent from the server to the relay
        - define relayIp <proc[companion_get_ip_using_hash].context[<[vars].get[hash]>]>
        - if !<[relayIp].equals[null]>:
          - if <[relayIp].equals[<[ip].first>]>:
            - define uuid <proc[companion_get_uuid_using_hash].context[<[vars].get[hash]>]>
            - if !<[uuid].equals[null]>:
              - if <[vars].contains[request]> && <[vars].get[request].equals[data]>:
                - determine passively code:200
                - determine <proc[companion_get_data_using_hash].context[<[vars].get[hash]>]>
              - determine passively code:200
              - determine parsed_file:scripts/relay/repo_link/web/main.html
            - else:
              - determine "Youre data is missing, please contact administration"
          - else:
            - determine "You must use the same ip address, as the one you used to login to minecraft!"
        - else:
            - determine "You dont have an active session. Please use /companion in game to create one"
      - else if <context.request.equals[/AdriftusMCHalf.png]>:
        - determine file:scripts/relay/repo_link/web/AdriftusMCHalf.png

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
  debug: true
  definitions: data
  script:
    - foreach <[data].unescaped> as:playerData:
      - flag server Hashes.<[playerData].get[uuid]>.data:<[playerData]>