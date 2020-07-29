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
        
    # % ██ [ Process Global Data Load ] ██
      - define GlobalYaml global.player.<player.uuid>
      - if !<yaml.list.contains[<[GlobalYaml]>]>:
        - define YamlDir data/globalData/players/<player.uuid>.yml
        - if !<server.has_file[<[YamlDir]>]>:
          - yaml id:<[GlobalYaml]> create
          - yaml id:<[GlobalYaml]> savefile:<[YamlDir]>
        - else:
          - yaml id:<[GlobalYaml]> load:<[YamlDir]>
      - define GlobalData <yaml[<[GlobalYaml]>].list_keys[]>

    # % ██ [ Load and Set Display_Name ] ██
      - if !<[GlobalData].contains[display_name]>:
        - yaml id:<[GlobalYaml]> set Display_Name:<player.name>
      - adjust <player> display_name:<yaml[<[GlobalYaml]>].read[Display_Name]>
      
    # % ██ [ Load Tab_Display_Name ] ██
      - if !<[GlobalData].contains[Tab_Display_name]>:
        - yaml id:<[GlobalYaml]> set Tab_Display_name:<player.name>

    # % ██ [ Verify Rank ] ██
      - if <[GlobalData].contains[Rank]>:
        - define Rank <yaml[<[GlobalYaml]>].read[Rank]>
        - bungeerun relay Player_Join_Message def:<player.name>|<bungee.server>|<player.uuid>|<[Rank]>
      - else:
        - bungeerun relay Player_Join_Message def:<player.name>|<bungee.server>|<player.uuid>

    on player quits:
    # % ██ [ Unload Server Player Data ] ██
      - ~yaml id:player.<player.uuid> savefile:data/players/<player.uuid>.yml
      - yaml id:player.<player.uuid> unload

    # % ██ [ Unload Global Player Data ] ██
      - ~yaml id:global.player.<player.uuid> savefile:data/globalData/players/<player.uuid>.yml
      - yaml id:global.player.<player.uuid> unload

    on delta time minutely every:5:
      - foreach <server.online_players> as:Player:
        - ~yaml id:player.<[Player].uuid> savefile:data/players/<[Player].uuid>.yml
        - ~yaml id:player.<[Player].uuid> savefile:data/globalData/players/<[Player].uuid>.yml

global_player_data_unloaded:
  type: task
  debug: false
  definitions: uuid
  script:
      - yaml id:data_handler set players.<[uuid]>.data_loaded:false

global_player_data_loaded:
  type: task
  debug: false
  definitions: uuid
  script:
      - yaml id:data_handler set players.<[uuid]>.data_loaded:true

global_player_data_load:
  type: task
  debug: false
  definitions: uuid
  script:
    - if <server.has_file[data/globalData/players/<[uuid]>.yml]>:
      - ~yaml id:global.player.<[uuid]> load:data/globalData/players/<[uuid]>.yml
      - bungeerun hub1 global_player_data_loaded def:<[uuid]>
    - foreach <server.scripts.filter[name.starts_with[player_join_event]]||<list[]>>:
      - run <[value]> player:<[uuid].as_player>

global_player_data_unload:
  type: task
  debug: false
  definitions: uuid
  script:
    - ~yaml id:global.player.<[uuid]> savefile:data/globalData/players/<[uuid]>.yml
    - bungeerun hub1 global_player_data_unloaded def:<[uuid]>
    - yaml id:global.player.<[uuid]> unload