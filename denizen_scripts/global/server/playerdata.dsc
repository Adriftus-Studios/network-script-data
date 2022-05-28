player_data_handler:
  type: world
  debug: false
  events:
    on bungee player joins network:
    # % ██ [ Load Server player Data ] ██
      - if <bungee.server> == hub:
        - define server_yaml data/global/players/<context.uuid>.yml
        - if <server.has_file[<[server_yaml]>]>:
          - ~yaml id:global.player.<context.uuid> load:<[server_yaml]>
          - if !<yaml.list.contains[global.player.<context.uuid>]>:
            - define uuid <context.uuid>
            - define name <context.name>
            - bungeerun relay discord_sendMessage "def:Adriftus Development and Reporting|alerts|<&lt>@565536267161567232<&gt><&nl><[uuid]> (<[name]>) global player data failed to load."
            - stop
          - wait 1t
          - customevent id:global_player_data_loaded context:<map[uuid=<context.uuid>;name=<context.name>]> player:<player[<context.uuid>]>
        - else:
          - yaml id:global.player.<context.uuid> create
          - ~yaml id:global.player.<context.uuid> savefile:<[server_yaml]>
          - customevent id:global_player_data_loaded context:<map[uuid=<context.uuid>;name=<context.name>]> player:<player[<context.uuid>]>

    on player joins:
      - if <bungee.server> != hub:
        - if <server.has_file[data/global/players/<player.uuid>.yml]>:
          - ~yaml id:global.player.<player.uuid> load:data/global/players/<player.uuid>.yml
          - if !<yaml.list.contains[global.player.<player.uuid>]>:
            - define uuid <player.uuid>
            - define name <player.name>
            - bungeerun relay discord_sendMessage "def:Adriftus Development and Reporting|alerts|<&lt>@565536267161567232<&gt><&nl><[uuid]> (<[name]>) global player data failed to load."
          - customevent id:global_player_data_loaded context:<map[uuid=<player.uuid>;name=<player.name>]>
        - else:
          - wait 1s
          - ~yaml id:global.player.<player.uuid> load:data/global/players/<player.uuid>.yml
          - customevent id:global_player_data_loaded context:<map[uuid=<player.uuid>;name=<player.name>]>
      #- else:
        #- customevent id:global_player_data_loaded context:<map[uuid=<player.uuid>;name=<player.name>]>

    on player quits:
      - if <bungee.server> != hub:
        - ~yaml id:global.player.<player.uuid> unload

    on bungee player leaves network:
      - if <bungee.server> == hub:
        - ~yaml id:global.player.<context.uuid> unload

network_map_handler:
  type: world
  debug: false
  events:
    on server start:
      - waituntil rate:1s <bungee.connected>
      - flag server server_map:!
      - flag server player_map:!
      - foreach <bungee.list_servers> as:server:
        - ~bungeetag server:<[server]> <server.online_players.parse_tag[<map[<[parse_value]>=<[parse_value].name>].if_null[null]>].exclude[null]> save:list
        - if <entry[list].result.if_null[null]> == null:
           - foreach next
        - foreach <entry[list].result> as:map:
          - define uuid <[map].keys.first>
          - define name <[map].get[<[uuid]>]>
          - flag server player_map.uuids.<[uuid]>.name:<[name]>
          - flag server player_map.uuids.<[uuid]>.server:<[server]>
          - flag server server_map.<[server]>.<[uuid]>:<[name]>
          - flag server player_map.names.<[name]>.uuid:<[uuid]>
          - flag server player_map.names.<[name]>.server:<[server]>

    on bungee player switches to server:
      - if <server.has_flag[player_map.uuids.<context.uuid>.server]>:
        - flag server server_map.<server.flag[player_map.uuids.<context.uuid>.server]>.<context.uuid>:!
      - flag server player_map.uuids.<context.uuid>.server:<context.server>
      - flag server player_map.uuids.<context.uuid>.name:<context.name>
      - flag server server_map.<context.server>.<context.uuid>:<context.name>
      - flag server player_map.names.<context.name>.uuid:<context.uuid>
      - flag server player_map.names.<context.name>.server:<context.server>

    on bungee player leaves network:
      - flag server server_map.<server.flag[player_map.uuids.<context.uuid>.server]>.<context.uuid>:!
      - flag server player_map.uuids.<context.uuid>:!
      - flag server player_map.names.<context.name>:!

network_map_update_name:
  type: task
  debug: false
  definitions: uuid|name|forward
  script:
    - waituntil <server.has_flag[player_map.uuids.<[uuid]>]>
    - define forward true if:<[forward].exists.not>
    - define old_name <server.flag[player_map.uuids.<[uuid]>.name]>
    - define server <server.flag[player_map.uuids.<[uuid]>.server]>
    - define stripped_name <[name].strip_color.replace[<&sp>].with[_]>
    - define color <server.flag[player_map.uuids.<[uuid]>.name_color]> if:<server.has_flag[player_map.uuids.<[uuid]>.name_color]>
    - flag server player_map.names.<[old_name]>:!
    - flag server player_map.uuids.<[uuid]>.name:<[stripped_name]>
    - flag server player_map.uuids.<[uuid]>.display_name:<[name]>
    - flag server server_map.<[server]>.<[uuid]>:<[stripped_name]>
    - flag server player_map.names.<[stripped_name]>.uuid:<[uuid]>
    - flag server player_map.names.<[stripped_name]>.server:<[server]>
    - flag server player_map.names.<[stripped_name]>.display_name:<[name]>
    - flag server player_map.names.<[stripped_name]>.name_color:<[color]> if:<[color].exists>
    - if <[forward]>:
      - bungeerun <bungee.list_servers.exclude[relay]> network_map_update_name def:<[uuid]>|<[name]>|false

network_map_update_name_color:
  type: task
  debug: false
  definitions: uuid|color|forward
  script:
    - define forward true if:<[forward].exists.not>
    - flag server player_map.uuids.<[uuid]>.name_color:<[color]>
    - define name <server.flag[player_map.uuids.<[uuid]>.name]>
    - flag server player_map.names.<[name]>.name_color:<[color]>
    - if <[forward]>:
      - bungeerun <bungee.list_servers.exclude[relay]> network_map_update_name_color def:<[uuid]>|<[color]>|false

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

## Specific Usage - USE "bungee_send_message" INSTEAD
global_player_data_message_history:
  type: task
  debug: false
  definitions: uuid|message_map
  script:
    - yaml id:global.player.<[uuid]> set chat.message.history:|:<[message_map]> if:<yaml.list.contains[global.player.<[uuid]>]>
    - if <yaml[global.player.<[uuid]>].read[chat.message.history].size> > 30:
      - yaml id:global.player.<[uuid]> set chat.message.history:!|:<yaml[global.player.<[uuid]>].read[chat.message.history].remove[first]>
    - if <bungee.server> != hub:
      - bungeerun hub global_player_data_message_history def:<[uuid]>|<[message_map]>
    - else:
      - ~yaml id:global.player.<[uuid]> savefile:data/global/players/<[uuid]>.yml

## External Usage
global_player_data_modify:
  type: task
  debug: false
  definitions: uuid|node|value|forward
  script:
    - yaml id:global.player.<[uuid]> set <[node]>:<[value]> if:<yaml.list.contains[global.player.<[uuid]>]>
    - if <bungee.server> != hub:
      - if !<player[<[uuid]>].is_online||false>:
        - define forward true
      - bungeerun hub global_player_data_modify def:<[uuid]>|<[node]>|<[value]>|<[forward]||false>
    - else if !<server.has_flag[player_map.uuids.<[uuid]>.server]>:
      - ~yaml id:global.player.<[uuid]> load:data/global/players/<[uuid]>.yml
      - yaml id:global.player.<[uuid]> set <[node]>:<[value]>
      - ~yaml id:global.player.<[uuid]> savefile:data/global/players/<[uuid]>.yml
      - if !<server.has_flag[player_map.uuids.<[uuid]>.server]>:
        - yaml id:global.player.<[uuid]> unload
    - else:
      - ~yaml id:global.player.<[uuid]> savefile:data/global/players/<[uuid]>.yml
      - if <[forward]||false> && <server.has_flag[player_map.uuids.<[uuid]>.server]>:
        - bungeerun <server.flag[player_map.uuids.<[uuid]>.server]> global_player_data_modify_single def:<[uuid]>|<[node]>|<[value]>

## External Usage
global_player_data_modify_multiple:
  type: task
  debug: false
  definitions: uuid|map|forward
  script:
    - if <yaml.list.contains[global.player.<[uuid]>]>:
      - foreach <[map]> key:node as:value:
        - yaml id:global.player.<[uuid]> set <[node]>:<[value]>
    - if <bungee.server> != hub:
      - if !<player[<[uuid]>].is_online||false>:
        - define forward true
      - bungeerun hub global_player_data_modify_multiple def:<[uuid]>|<[map]>|<[forward]||false>
    - else if !<server.has_flag[player_map.uuids.<[uuid]>.server]>:
      - ~yaml id:global.player.<[uuid]> load:data/global/players/<[uuid]>.yml
      - foreach <[map]> key:node as:value:
        - yaml id:global.player.<[uuid]> set <[node]>:<[value]>
      - ~yaml id:global.player.<[uuid]> savefile:data/global/players/<[uuid]>.yml
      - if !<server.has_flag[player_map.uuids.<[uuid]>.server]>:
        - yaml id:global.player.<[uuid]> unload
    - else:
      - ~yaml id:global.player.<[uuid]> savefile:data/global/players/<[uuid]>.yml
      - if <[forward]||false> && <server.has_flag[player_map.uuids.<[uuid]>.server]>:
        - bungeerun <server.flag[player_map.uuids.<[uuid]>.server]> global_player_data_modify_multiple_single def:<[uuid]>|<[map]>
