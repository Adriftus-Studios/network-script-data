global_data_handler:
  type: world
  servers:
    - survival
    - BehrCraft
  events:
    on server starts:
      - yaml id:data_handler create
    on bungee player joins network:
      - if !<server.has_file[data/globalData/players/<context.uuid>.yml]>:
        - yaml id:global.player.<context.uuid> create
        - yaml id:global.player.<context.uuid> savefile:data/globalData/players/<context.uuid>.yml
  #^    - yaml id:data_handler set players.<context.uuid>.server:survival
  #^    - yaml id:data_handler set players.<context.uuid>.name:<context.name>
  #^    - yaml id:data_handler set players.<context.uuid>.data_loaded:false
  #^    - ~bungeerun survival global_player_data_load def:<context.uuid>

  #@  on bungee player leaves network:
  #^    - if <script[global_data_handler].data_key[servers].contains[<yaml[data_handler].read[players.<context.uuid>.server]>]>:
  #^      - ~bungeerun <yaml[data_handler].read[players.<context.uuid>.server]> global_player_data_unload def:<context.uuid>
  #^    - yaml id:data_handler set players.<context.uuid>:!

  #@  on bungee player switches to server:
  #^    - ratelimit <player> 2t
  #^    - waituntil rate:5t <yaml[data_handler].read[players].contains[<context.uuid>]>
  #^    - if <script[global_data_handler].data_key[servers].contains[<yaml[data_handler].read[players.<context.uuid>.server]>]>:
  #^      - if <yaml[data_handler].read[players.<context.uuid>.server]> != <context.server>:
  #^        - ~bungeerun <yaml[data_handler].read[players.<context.uuid>.server]> global_player_data_unload def:<context.uuid>
  #^    - yaml id:data_handler set players.<context.uuid>.server:<context.server>
  #^    - if <script[global_data_handler].data_key[servers].contains[<context.server>]>:
  #^      - waituntil rate:5t <yaml[data_handler].read[players.<context.uuid>.data_loaded].not||true>
  #^      - ~bungeerun <context.server> global_player_data_load def:<context.uuid>


Player_Data_Loading:
  type: task
  debug: false
  definitions: UUID
  script:
    - yaml id:data_handler set player.<[UUID]>