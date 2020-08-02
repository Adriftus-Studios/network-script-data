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
        - ~yaml id:player.<[Player].uuid> savefile:data/globalData/players/<[Player].uuid>.yml

Player_Data_Join_Event:
  type: task
  debug: true
  definitions: UUID
  script:
  # % ██ [ Cache Player Info ] ██
    - define Timeout <util.time_now.add[5m]>
    - define GlobalYaml global.player.<[UUID]>
    
  # % ██ [ Verify Player ] ██
    - waituntil rate:2t <player[<[UUID]>].is_online||false> || <[Timeout].duration_since[<util.time_now>].in_seconds> == 0
    - if !<player[<[UUID]>].is_online>:
      - stop
    
  # % ██ [ Load Global Player Data ] ██
    - yaml id:<[GlobalYaml]> load:data/global/players/<[UUID]>.yml

    # % ██ [ Load and Set Display_Name ] ██
    - if !<yaml[<[GlobalYaml]>].contains[Display_Name]>:
      - yaml id:<[GlobalYaml]> set Display_Name:<player.name>
    - adjust <player> Display_Name:<yaml[<[GlobalYaml]>].read[Display_Name]>

  # % ██ [ Load Tab_Display_Name ] ██
    - if !<yaml[<[GlobalYaml]>].contains[Tab_Display_name]>:
      - yaml id:<[GlobalYaml]> set Tab_Display_name:<player.name>

    # % ██ [ Fire Player Login Tasks ] ██
    - bungeerun Relay Player_Join_Message def:<list_single[<[PlayerMap].with[Server].as[<[Server]>]>]>

Player_Data_Quit_Event:
  type: task
  debug: true
  definitions: UUID
  script:
    - Run Unload_Player_Data def:<[UUID]>

Player_Data_Switch_Event:
  type: task
  debug: true
  definitions: UUID
  script:
    - Run Unload_Player_Data def:<[UUID]>

Unload_Player_Data:
  type: task
  debug: false
  definitions: UUID
  # % ██ [ Cache Player Info ] ██
    - define Player <player[<[UUID]>]>
    - define UUID <[Player].uuid>

  # % ██ [ Unload Server Player Data ] ██
    - ~yaml id:player.<[UUID]> savefile:data/players/<[UUID]>.yml
    - yaml id:player.<[UUID]> unload

  # % ██ [ Unload Global Player Data ] ██
    - ~yaml id:global.player.<[UUID]> savefile:data/global/players/<[UUID]>.yml
    - yaml id:global.player.<[UUID]> unload
