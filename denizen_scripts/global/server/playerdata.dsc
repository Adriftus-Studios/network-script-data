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
        - ~yaml id:global.player.<[Player].uuid> savefile:data/players/<[Player].uuid>.yml

Player_Data_Join_Event:
  type: task
  debug: false
  definitions: UUID|Event
  script:
  # % ██ [ Cache Player Info ] ██
    - define Timeout <util.time_now.add[5m]>
    - define GlobalYaml global.player.<[UUID]>

  # % ██ [ Verify Player ] ██
    - waituntil rate:2t <player[<[UUID]>].is_online||false> || <[Timeout].duration_since[<util.time_now>].in_seconds> == 0
    - if !<player[<[UUID]>].is_online>:
      - stop

  # % ██ [ Load Global Player Data ] ██
    - if !<server.has_flag[data/players/<[UUID]>.yml]>:
      - yaml id:<[GlobalYaml]> create
    - yaml id:<[GlobalYaml]> load:data/players/<[UUID]>.yml

    # % ██ [ Load and Set Display_Name ] ██
    - define Name <player[<[UUID]>].name>
    - if !<yaml[<[GlobalYaml]>].contains[Display_Name]>:
      - yaml id:<[GlobalYaml]> set Display_Name:<[Name]>
    - adjust  <player[<[UUID]>]> Display_Name:<yaml[<[GlobalYaml]>].read[Display_Name]>

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
    - define Player <player[<[UUID]>]>
    - define Name <[Player].name>
    - define PlayerMap <map.with[Player].as[<[Player]>].with[UUID].as[<[UUID]>].with[Server].as[<bungee.server>].with[Name].as[<[Name]>]>
    - if <yaml[global.player.<[UUID]>].contains[Rank]>:
      - define PlayerMap <[PlayerMap].with[Rank].as[<yaml[global.player.<[UUID]>].read[rank].strip_color>]>

  # % ██ [ Unload Server Player Data ] ██
    - ~yaml id:player.<[UUID]> savefile:data/players/<[UUID]>.yml
    - yaml id:player.<[UUID]> unload

  # % ██ [ Unload Global Player Data ] ██
    - ~yaml id:global.player.<[UUID]> savefile:data/players/<[UUID]>.yml
    - yaml id:global.player.<[UUID]> unload
