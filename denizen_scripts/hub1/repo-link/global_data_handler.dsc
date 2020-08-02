global_data_handler:
  type: world
  debug: false
  events:
    on server starts:
      - yaml id:data_handler create

    on bungee player joins network:
    # % ██ [ Cache Player Info ] ██
      - define Name <context.name>
      - define UUID <context.uuid>
      - define GlobalYaml global.player.<[UUID]>
      - yaml id:data_handler set player.<[UUID]>:<empty>

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
      - define PlayerMap <map.with[Name].as[<[Name]>].with[UUID].as[<[UUID]>]>
      
    # % ██ [ Track Player ] ██
      - if <yaml[data_handler].contains[player.<[UUID]>.server]>:
        - yaml id:data_handler set server.<yaml[data_handler].read[player.<[UUID]>.server]>:<-:<[PlayerMap]>
      - yaml id:data_handler set player.<[UUID]>.server:<[Server]>
      - yaml id:data_handler set server.<[Server]>:->:<[PlayerMap]>

    # % ██ [ Fire Player Login Events ] ██
      - bungeerun <[Server]> Player_Data_Join_Event def:<[UUID]>
    #^- bungeerun Relay Player_Login_Message def:<list_single[<[PlayerMap].with[Server].as[<[Server]>]>]>

    on bungee player leaves network:
    # % ██ [ Cache Player Info ] ██
      - define Name <context.name>
      - define UUID <context.uuid>
      - define Server <yaml[data_handler].read[player.<[UUID]>.server]>
      - define PlayerMap <map.with[Name].as[<[Name]>].with[UUID].as[<[UUID]>]>
      
    # % ██ [ Track Player ] ██
      - yaml id:data_handler set player.<[UUID]>:!
      - yaml id:data_handler set server.<[Server]>:<-:<[PlayerMap]>

    # % ██ [ Fire Player Quit Events ] ██
      - bungeerun <[Server]> Player_Data_Quit_Event def:<[UUID]>
    #^- bungeerun Relay Player_Quit_Message def:<list_single[<[PlayerMap].with[Server].as[<[Server]>]>]>
