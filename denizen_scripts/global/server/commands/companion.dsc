companion_oauth_command:
    type: command
    name: companion
    description: Command that gives you your companion link
    usage: /companion
    script:
    - if !<player.has_flag[companionHash]>:
        - bungeerun relay companion_generate_hash def:<player>|<bungee.server>|<player.ip_address.replace_text[/].with[]>
    - else:
        - narrate "Heres ur generated link http://50.35.235.151:81/companion?hash=<player.flag[companionHash]>"

companion_reset_hash_if_exists:
    type: world
    events:
        on player joins:
            - define uuid <player.uuid>
            - ~bungeetag server:relay <server.has_flag[Hashes.<[uuid]>.companionHash]> save:hasFlag
            - if <player.has_flag[companionHash]> && !<entry[hasFlag].result>:
                - run companion_hash_expire def:<player.uuid>

companion_hash_return_print:
    type: task
    definitions: uuid
    script:
        - narrate "Heres ur generated link http://50.35.235.151:81/companion?hash=<player[<[uuid]>].flag[companionHash]>"

companion_hash_set:
    type: task
    definitions: uuid|hash
    script:
        - debug debug "Hash has been received for <player[<[uuid]>].name> and set as <[hash]>"
        - flag <player[<[uuid]>]> companionHash:<[hash]>
        - if <script[companion_data_send_loop].queues.size> = 0:
            - run companion_data_send_loop

companion_hash_expire:
    type: task
    definitions: uuid
    script:
        - debug debug "Hash <player[<[uuid]>].flag[companionHash]> has been marked as expired"
        - flag <player[<[uuid]>]> companionHash:!

companion_data_send_loop:
    type: task
    debug: false
    data:
        send_map:
            name: <[target].name>
            uuid: <[target].uuid>
            location: <[target].location.round_to[2].proc[companion_location_to_json_proc]>
            server: <bungee.server>
    script:
        - while <server.online_players_flagged[companionHash].size> > 0:
            - define list <list>
            - foreach <server.online_players_flagged[companionHash]> as:target:
                - define list:->:<script.parsed_key[data.send_map]>
            - debug debug <[list]>
            - bungeerun relay companion_data_receive_handler def:<[list].escaped>
            - wait 5s

companion_location_to_json_proc:
  type: procedure
  definitions: location
  script:
    - determine <map[x=<[location].x>;y=<[location].y>;z=<[location].z>;world=<[location].world.name>].to_json>