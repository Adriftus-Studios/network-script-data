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

#^      - define GlobalData <yaml[<[GlobalYaml]>].list_keys[]>
#^
#%    # % ██ [ Load and Set Display_Name ] ██
#^      - if !<[GlobalData].contains[display_name]>:
#^        - yaml id:<[GlobalYaml]> set Display_Name:<player.name>
#^      - adjust <player> display_name:<yaml[<[GlobalYaml]>].read[Display_Name]>
#^
#%    # % ██ [ Load Tab_Display_Name ] ██
#^      - if !<[GlobalData].contains[Tab_Display_name]>:
#^        - yaml id:<[GlobalYaml]> set Tab_Display_name:<player.name>
#^
#%    # % ██ [ Verify Rank ] ██
#^      - if <[GlobalData].contains[Rank]>:
#^        - define Rank <yaml[<[GlobalYaml]>].read[Rank]>
#^        - bungeerun relay Player_Join_Message def:<player.name>|<bungee.server>|<player.uuid>|<[Rank]>
#^      - else:
#^        - bungeerun relay Player_Join_Message def:<player.name>|<bungee.server>|<player.uuid>
#^
#@  on player quits:
#%  # % ██ [ Unload Server Player Data ] ██
#^    - ~yaml id:player.<player.uuid> savefile:data/players/<player.uuid>.yml
#^    - yaml id:player.<player.uuid> unload
#@
#%  # % ██ [ Unload Global Player Data ] ██
#^    - ~yaml id:global.player.<player.uuid> savefile:data/globalData/players/<player.uuid>.yml
#^    - yaml id:global.player.<player.uuid> unload

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

  # % ██ [ Verify Rank ] ██
  #^- waituntil rate:1s <bungee.connected>
  #^- if <yaml[<[GlobalYaml]>].contains[Rank]>:
  #^  - define Rank <yaml[<[GlobalYaml]>].read[Rank]>
  #^  - bungeerun relay Player_Join_Message def:<player.name>|<bungee.server>|<player.uuid>|<[Rank]>
  #^- else:
  #^  - bungeerun relay Player_Join_Message def:<player.name>|<bungee.server>|<player.uuid>

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
