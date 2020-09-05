global_data_handler:
  type: world
  debug: true
  events:
    on server start:
      - yaml id:data_handler create

    on bungee player joins network:
    # % ██ [ Cache Player Info ] ██
      - define Name <context.name>
      - define UUID <context.uuid>
      - define GlobalYaml global.player.<[UUID]>

    # % ██ [ Verify Global Player Data Exists ] ██
      - define Directory data/global/players/<[UUID]>.yml
      - if !<server.has_file[<[Directory]>]>:
        # $ ██ [ Temporary for resolving current playerdata prior to transition ] ██
        - if <server.has_file[data/globalData/players/<[UUID]>.yml]>:
          - yaml id:<[GlobalYaml]> load:data/globalData/players/<[UUID]>.yml
          - yaml id:<[GlobalYaml]> savefile:<[Directory]>
          - yaml id:<[GlobalYaml]> unload
          - stop
        # $ ██ [ -------------------------------------------------------------- ] ██

        - yaml id:<[GlobalYaml]> create
        - yaml id:<[GlobalYaml]> savefile:<[Directory]>
    on bungee player switches to server:
    # % ██ [ Cache Player Info ] ██
      - define Name <context.name>
      - define UUID <context.uuid>
      - define Server <context.server>
      - if <yaml[data_handler].contains[players.<[UUID]>.server]>:
        - define Old_Server <yaml[data_handler].read[players.<[UUID]>.server]>
      - define PlayerMap <map.with[Name].as[<[Name]>].with[UUID].as[<[UUID]>].with[Server].as[<[Server]>]>
      - define LocalServers <yaml[bungee.config].list_keys[servers].filter_tag[<yaml[bungee.config].read[servers.<[filter_value]>.address].starts_with[localhost]>]>

    # % ██ [ Track Player ] ██
      - if <yaml[data_handler].contains[players.<[UUID]>.server]>:
        - yaml id:data_handler set servers.<[Old_Server]>:<-:<[UUID]>
      - yaml id:data_handler set players.uuids.<[UUID]>.name:<[name]>
      - yaml id:data_handler set players.uuids.<[UUID]>.server:<[server]>
      - yaml id:data_handler set servers.<[server]>:->:<[UUID]>
      - yaml id:data_handler set players.names.<[name]>.UUID:<[UUID]>
      - yaml id:data_handler set players.names.<[name]>.server:<[server]>


    # % ██ [ Fire Player Login Events ] ██
      - if <[LocalServers].contains[<[Server]>]>:
        - bungeerun <[Server]> Player_Data_Join_Event def:<[UUID]>|Switched
      - else:
        - yaml id:global.player.<[UUID]> load:data/global/players/<[UUID]>.yml
        - define PlayerData <yaml[global.player.<[UUID]>].read[]>
        - run External_Player_Data_Join_Event def:<list_single[<[PlayerMap]>].include_single[<[PlayerData]>].include[<[Server]>|Joined]>

    on bungee player leaves network:
    # % ██ [ Cache Player Info ] ██
      - define Name <context.name>
      - define UUID <context.uuid>
      - define Server <yaml[data_handler].read[players.<[uuid]>.server]>
      - define PlayerMap <map.with[name].as[<[name]>].with[uuid].as[<[uuid]>].with[server].as[<[server]>]>
      - define LocalServers <yaml[bungee.config].list_keys[servers].filter_tag[<yaml[bungee.config].read[servers.<[filter_value]>.address].starts_with[localhost]>]>

    # % ██ [ Remove Player Data ] ██
      - yaml id:data_handler set players.uuids.<[UUID]>:!
      - yaml id:data_handler set servers.<[server]>:<-:<[UUID]>
      - yaml id:data_handler set players.names.<[Name]>:!

    # % ██ [ Fire Player Quit Events ] ██
      - bungeerun <[Server]> Player_Data_Quit_Event def:<[UUID]>

External_Player_Data_Join_Event:
  type: task
  debug: true
  definitions: PlayerMap|PlayerData|Server|Event
  script:
    - bungee <[Server]>:

    # % ██ [ Cache Player Info ] ██
      - foreach <[PlayerMap]>:
        - define <[Key]> <[Value]>
      - define Timeout <util.time_now.add[5m]>
      - define GlobalYaml global.player.<[UUID]>

    # % ██ [ Verify Player ] ██
      - waituntil rate:2t <player[<[UUID]>].is_online||false> || <[Timeout].duration_since[<util.time_now>].in_seconds> == 0
      - if !<player[<[UUID]>].is_online>:
        - stop

    # % ██ [ Load Global Player Data ] ██
      - yaml id:<[GlobalYaml]> Create
      - foreach <[PlayerData]>:
        - yaml id:<[GlobalYaml]> Set <[Key]>:<[Value]>

      # % ██ [ Load and Set Display_Name ] ██
      - define Name <player[<[UUID]>].name>
      - if !<yaml[<[GlobalYaml]>].contains[Display_Name]>:
        - yaml id:<[GlobalYaml]> set Display_Name:<[Name]>
      - adjust <player[<[UUID]>]> Display_Name:<yaml[<[GlobalYaml]>].read[Display_Name]>

    # % ██ [ Load Tab_Display_Name ] ██
      - if !<yaml[<[GlobalYaml]>].contains[Tab_Display_name]>:
        - yaml id:<[GlobalYaml]> set Tab_Display_name:<[Name]>

      # % ██ [ Fire Player Login Tasks ] ██
      - define PlayerMap <map.with[Name].as[<[Name]>].with[Server].as[<bungee.server>]>
      - if <yaml[<[GlobalYaml]>].contains[Rank]>:
        - define PlayerMap <[PlayerMap].with[Rank].as[<yaml[<[GlobalYaml]>].read[rank].strip_color>]>
      - if <[Event]> == Joined:
        - bungeerun Relay Player_Join_Message def:<list_single[<[PlayerMap]>]>
      - else:
        - bungeerun Relay Player_Switch_Message def:<list_single[<[PlayerMap]>]>

#@modify_global_player_data_safe:
#@  type: task
#@  definitions: uuid|node|value
#@  script:
#^    - if <yaml[data_handler].contains[player.<[uuid]>]> && <yaml[data_handler].read[player.<[uuid]>.server]> != <bungee.server>:
#^      - bungeerun player_data_safe_modify def:<[uuid]>|<[node]>|<[value]>
#^    - else if <yaml.list.contains[global.player.<[uuid]>]>:
#^      - yaml id:global.player.<[uuid]> set <[node]>:<[value]>
#^    - else:
#^      - yaml id:global.player.<[uuid]> load:data/players/<[uuid]>.yml
#^      - yaml id:global.player.<[uuid]> set <[node]>:<[value]>
#^      - yaml id:global.player.<[uuid]> savefile:data/players/<[uuid]>.yml
#^      - yaml id:global.player.<[uuid]> unload

# % ██  [ Retrieves a map of the player's information, with the keys 'name, uuid, server' based on the player's name ] ██
# % ██  [ Returns 'null' if the player name is invalid (or not online) ] ██
# - ██  [ Usage ]  Retrieves the player's information (in map form) from 'hub1' and stores it in <entry[player_map].result>.
# - ██  [       ]  - ~bungeetag server:hub1 <proc[player_info_map].context[<[player_input]>]> save:player_map
# - ██  [       ]  Retrieves the player's infortmation (in map form) and stores it in the `player_map` definition. (only works on 'hub1')
# - ██  [       ]  - define player_map <proc[player_info_map].context[<[player_input]>]>

player_info_map:
    type: procedure
    definitions: input
    script:
    - if <yaml[data_handler].contains[players.<[input]>]>:
      - determine <yaml[data_handler].read[players.<[input]>].with[name].as[<[input]>]>
    - determine null
    
# % ██  [ Retrieves a map of the player's information, with the keys 'name, uuid, server' based on the player's uuid ] ██
# % ██  [ Returns 'null' if the player uuid is invalid (or not online) ] ██
# - ██  [ Usage ]  Retrieves the player's information (in map form) from 'hub1' and stores it in <entry[player_map].result>.
# - ██  [       ]  - ~bungeetag server:hub1 <proc[player_info_map_uuid].context[<[player_uuid]>]> save:player_map
# - ██  [       ]  Retrieves the player's infortmation (in map form) and stores it in the `player_map` definition. (only works on 'hub1')
# - ██  [       ]  - define player_map <proc[player_info_map_uuid].context[<[player_uuid]>]>

player_info_map_uuid:
    type: procedure
    definitions: input
    script:
    - if <yaml[data_handler].contains[players.<[input]>]>:
      - determine <yaml[data_handler].read[players.<[input]>].with[uuid].as[<[input]>]>
    - determine null
