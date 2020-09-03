player_data_handler:
  type: world
  debug: false
  events:
    on player logs in:
    # % ██ [ Load Server player Data ] ██
      - define server_yaml data/players/<player.uuid>.yml
      - if <server.has_file[<[server_yaml]>]>:
        - ~yaml id:player.<player.uuid> load:<[server_yaml]>
      - else:
        - yaml id:player.<player.uuid> create
        - ~yaml id:player.<player.uuid> savefile:<[server_yaml]>

    on delta time minutely every:5:
      - define list <yaml.list>
      - foreach <server.online_players> as:player:
        - if !<[list].contains[player.<[player].uuid>]>:
          - ~yaml id:player.<[player].uuid> load:data/players/<[player].uuid>.yml
        - else:
          - ~yaml id:player.<[player].uuid> savefile:data/players/<[player].uuid>.yml
        - if !<[list].contains[pglobal.player.<[player].uuid>]>:
          - ~yaml id:player.<[player].uuid> load:data/global/players/<[player].uuid>.yml
        - else:
          - ~yaml id:global.player.<[player].uuid> savefile:data/global/players/<[player].uuid>.yml

player_Data_Join_Event:
  type: task
  debug: false
  definitions: uuid|Event
  script:
  # % ██ [ Cache player Info ] ██
    - define timeout <util.time_now.add[5m]>
    - define global_yaml global.player.<[uuid]>

  # % ██ [ Verify player ] ██
    - waituntil rate:2t <player[<[uuid]>].is_online> || <[timeout].duration_since[<util.time_now>].in_seconds> == 0
    - if !<player[<[uuid]>].is_online||false>:
      - stop

  # % ██ [ Load Global player Data ] ██
    - yaml id:<[global_yaml]> load:data/global/players/<[uuid]>.yml

    # % ██ [ Load and Set display_name ] ██
    - define name <player[<[uuid]>].name>
    - if !<yaml[<[global_yaml]>].contains[display_name]>:
      - yaml id:<[global_yaml]> set display_name:<[name]>
    - adjust <player[<[uuid]>]> display_name:<yaml[<[global_yaml]>].read[display_name]>

  # % ██ [ Load Tab_display_name ] ██
    - if !<yaml[<[global_yaml]>].contains[Tab_display_name]>:
      - yaml id:<[global_yaml]> set Tab_display_name:<[name]>

    # % ██ [ Fire player Login Tasks ] ██
    - define player_map <map.with[name].as[<[name]>].with[Server].as[<bungee.server>]>
    - if <yaml[<[global_yaml]>].contains[rank]>:
      - define player_map <[player_map].with[rank].as[<yaml[global.player.<[uuid]>].read[rank].strip_color>]>
      
    - waituntil rate:1s <bungee.connected>
    - if <[Event]> == Joined:
      - bungeerun relay player_Join_Message def:<list_single[<[player_map]>]>
    - else:
      - bungeerun relay player_Switch_Message def:<list_single[<[player_map]>]>

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

player_data_safe_modify:
  type: task
  definitions: uuid|node|value
  script:
    - yaml id:global.player.<[uuid]> set <[node]>:<[value]>
