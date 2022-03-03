player_data_handler:
  type: world
  debug: false
  events:
    on bungee player joins network:
    # % ██ [ Load Server player Data ] ██
      - if <bungee.server> == hub:
        - define server_yaml data/global/players/<player.uuid>.yml
        - if <server.has_file[<[server_yaml]>]>:
          - ~yaml id:global.player.<player.uuid> load:<[server_yaml]>
        - else:
          - yaml id:global.player.<player.uuid> create
          - ~yaml id:global.player.<player.uuid> savefile:<[server_yaml]>

    on player joins:
      - if <bungee.server> != hub:
        - if <server.has_file[data/global/players/<player.uuid>.yml]>:
          - ~yaml id:global.player.<player.uuid> load:data/global/players/<player.uuid>.yml
        - else:
          - wait 10t
          - ~yaml id:global.player.<player.uuid> load:data/global/players/<player.uuid>.yml

    on player quits:
      - if <bungee.server> != hub:
        - ~yaml id:global.player.<player.uuid> unload

    on bungee player leaves network:
      - if <bungee.server> == hub:
        - ~yaml id:global.player.<player.uuid> unload

network_map_handler:
  type: world
  debug: false
  events:
    on bungee player switches to server:
      - if <server.has_flag[player_map.uuids.<context.uuid>.server]>:
        - flag server server_map.<server.flag[player_map.<context.uuid>.server]>.<context.uuid>:!
      - flag server player_map.uuids.<context.uuid>.server:<context.server>
      - flag server player_map.uuids.<context.uuid>.name:<context.name>
      - flag server server_map.<context.server>.<context.uuid>:<context.name>
      - flag server player_map.names.<context.name>.uuid:<context.uuid>
      - flag server player_map.names.<context.name>.server:<context.server>

    on bungee player leaves network:
      - flag server server_map.<server.flag[player_map.uuids.<context.uuid>.server]>.<context.uuid>:!
      - flag server player_map.uuids.<context.uuid>:!
      - flag server player_map.names.<context.name>:!

player_data_quit_event:
  type: task
  debug: false
  definitions: uuid
  script:
    - inject unload_player_data
    - bungeerun relay player_quit_message def:<list_single[<[player_map]>]>

player_data_switch_event:
  type: task
  debug: false
  definitions: uuid
  script:
    - inject unload_player_data
    - bungeerun relay player_switch_message def:<list_single[<[player_map]>]>

unload_player_data:
  type: task
  debug: false
  definitions: uuid
  script:
  # % ██ [ Cache player Info ] ██
    - waituntil rate:1s <bungee.connected>
    - define timeout <util.time_now.add[5s]>
    - define player <player[<[uuid]>]>
    - define name <[player].name>
    - define player_map <map.with[player].as[<[player]>].with[uuid].as[<[uuid]>].with[Server].as[<bungee.server>].with[name].as[<[name]>]>

  # % ██ [ Unload Server player Data ] ██
    - waituntil rate:1s <yaml.list.contains[player.<[uuid]>]> || <[timeout].duration_since[<util.time_now>].in_seconds> == 0
    - if <yaml.list.contains[player.<[uuid]>]>:
      - ~yaml id:player.<[uuid]> savefile:data/players/<[uuid]>.yml
      - yaml id:player.<[uuid]> unload

  # % ██ [ Verify Global player Data ] ██
    - if !<yaml.list.contains[global.player.<[uuid]>]>:
      - define timeout <util.time_now.add[5s]>
      - waituntil rate:1s <yaml.list.contains[global.player.<[uuid]>]> || <[timeout].duration_since[<util.time_now>].in_seconds> == 0
      - if !<yaml.list.contains[global.player.<[uuid]>]>:
        - stop

  # % ██ [ Unload Global player Data ] ██
    - if <yaml[global.player.<[uuid]>].contains[rank]>:
      - define player_map <[player_map].with[rank].as[<yaml[global.player.<[uuid]>].read[rank].strip_color>]>
    - ~yaml id:global.player.<[uuid]> savefile:data/global/players/<[uuid]>.yml
    - yaml id:global.player.<[uuid]> unload


## INTERNAL USAGE
global_player_data_modify_single:
  type: task
  debug: false
  definitions: uuid|node|value
  script:
    - yaml id:global.player.<[uuid]> set <[node]>:<[value]>

## INTERNAL USAGE
global_player_data_modify_multiple_single:
  type: task
  debug: false
  definitions: uuid|map
  script:
    - foreach <[map]> key:node as:value:
      - yaml id:global.player.<[uuid]> set <[node]>:<[value]>

## External Usage
global_player_data_modify:
  type: task
  debug: false
  definitions: uuid|node|value|forward
  script:
    - yaml id:global.player.<[uuid]> set <[node]>:<[value]>
    - if <bungee.server> != hub:
      - if !<player[<[uuid]>].is_online||false>:
        - define forward true
      - bungeerun hub global_player_data_modify def:<[uuid]>|<[node]>|<[value]>|<[forward]||false>
    - else:
      - ~yaml id:global.player.<[uuid]> savefile:data/global/players/<[uuid]>.yml
      - if <[forward]||false> && <server.has_flag[player_map.<[uuid]>.server]>:
        - bungeerun <server.flag[player_map.<[uuid]>.server]> global_player_data_modify_single def:<[uuid]>|<[node]>|<[value]>

## External Usage
global_player_data_modify_multiple:
  type: task
  debug: false
  definitions: uuid|map|forward
  script:
    - foreach <[map]> key:node as:value:
      - yaml id:global.player.<[uuid]> set <[node]>:<[value]>
    - if <bungee.server> != hub:
      - if !<player[<[uuid]>].is_online||false>:
        - define forward true
      - bungeerun hub global_player_data_modify_multiple def:<[uuid]>|<[map]>|<[forward]||false>
    - else:
      - ~yaml id:global.player.<[uuid]> savefile:data/global/players/<[uuid]>.yml
      - if <[forward]||false> && <server.has_flag[player_map.<[uuid]>.server]>:
        - bungeerun <server.flag[player_map.<[uuid]>.server]> global_player_data_modify_multiple def:<[uuid]>|<[map]>