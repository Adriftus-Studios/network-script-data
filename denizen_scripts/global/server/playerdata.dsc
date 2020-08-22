player_data_handler:
  type: world
  debug: false
  events:
    on player logs in:
    # % ██ [ Load Server Player Data ] ██
      - define ServerYaml data/players/<player.uuid>.yml
      - if <server.has_file[<[ServerYaml]>]>:
        - ~yaml id:player.<player.uuid> load:<[ServerYaml]>
      - else:
        - yaml id:player.<player.uuid> create
        - ~yaml id:player.<player.uuid> savefile:<[ServerYaml]>

    on delta time minutely every:5:
      - foreach <server.online_players> as:Player:
        - ~yaml id:player.<[Player].uuid> savefile:data/players/<[Player].uuid>.yml
        - ~yaml id:global.player.<[Player].uuid> savefile:data/global/players/<[Player].uuid>.yml

Player_Data_Join_Event:
  type: task
  debug: false
  definitions: UUID|Event
  script:
  # % ██ [ Cache Player Info ] ██
    - define Timeout <util.time_now.add[5m]>
    - define GlobalYaml global.player.<[UUID]>

  # % ██ [ Verify Player ] ██
    - waituntil rate:2t <player[<[UUID]>].is_online> || <[Timeout].duration_since[<util.time_now>].in_seconds> == 0
    - if !<player[<[UUID]>].is_online||false>:
      - stop

  # % ██ [ Load Global Player Data ] ██
    - yaml id:<[GlobalYaml]> load:data/global/players/<[UUID]>.yml

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
      - define PlayerMap <[PlayerMap].with[Rank].as[<yaml[global.player.<[UUID]>].read[rank].strip_color>]>
      
    - waituntil rate:1s <bungee.connected>
    - if <[Event]> == Joined:
      - bungeerun Relay Player_Join_Message def:<list_single[<[PlayerMap]>]>
    - else:
      - bungeerun Relay Player_Switch_Message def:<list_single[<[PlayerMap]>]>

Player_Data_Quit_Event:
  type: task
  debug: false
  definitions: UUID
  script:
    - inject Unload_Player_Data
    - bungeerun Relay Player_Quit_Message def:<list_single[<[PlayerMap]>]>

Player_Data_Switch_Event:
  type: task
  debug: false
  definitions: UUID
  script:
    - inject Unload_Player_Data
    - bungeerun Relay Player_Switch_Message def:<list_single[<[PlayerMap]>]>

Unload_Player_Data:
  type: task
  debug: false
  definitions: UUID
  script:
  # % ██ [ Cache Player Info ] ██
    - waituntil rate:1s <bungee.connected>
    - define Timeout <util.time_now.add[5s]>
    - define Player <player[<[UUID]>]>
    - define Name <[Player].name>
    - define PlayerMap <map.with[Player].as[<[Player]>].with[UUID].as[<[UUID]>].with[Server].as[<bungee.server>].with[Name].as[<[Name]>]>

  # % ██ [ Unload Server Player Data ] ██
    - waituntil rate:1s <yaml.list.contains[player.<[UUID]>]> || <[Timeout].duration_since[<util.time_now>].in_seconds> == 0
    - if <yaml.list.contains[player.<[UUID]>]>:
      - ~yaml id:player.<[UUID]> savefile:data/players/<[UUID]>.yml
      - yaml id:player.<[UUID]> unload

  # % ██ [ Verify Global Player Data ] ██
    - if !<yaml.list.contains[global.player.<[UUID]>]>:
      - define timeout <util.time_now.add[5s]>
      - waituntil rate:1s <yaml.list.contains[global.player.<[UUID]>]> || <[Timeout].duration_since[<util.time_now>].in_seconds> == 0
      - if !<yaml.list.contains[global.player.<[UUID]>]>:
        - stop

  # % ██ [ Unload Global Player Data ] ██
    - if <yaml[global.player.<[UUID]>].contains[Rank]>:
      - define PlayerMap <[PlayerMap].with[Rank].as[<yaml[global.player.<[UUID]>].read[rank].strip_color>]>
    - ~yaml id:global.player.<[UUID]> savefile:data/global/players/<[UUID]>.yml
    - yaml id:global.player.<[UUID]> unload

player_data_safe_modify:
  type: task
  definitions: uuid|node|value
  script:
    - yaml id:global.player.<[uuid]> set <[node]>:<[value]>
