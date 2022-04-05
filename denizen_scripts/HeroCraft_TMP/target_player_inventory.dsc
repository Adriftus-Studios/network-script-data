target_players_inventory:
  type: inventory
  inventory: chest
  title: <&b>Choose a Player
  gui: true
  size: 54

target_players_open:
  type: task
  debug: false
  definitions: callback|filter
  script:
    - define callback <context.item.flag[callback]> if:<[callback].exists.not>
    - define inv <inventory[target_players_inventory]>
    - if !<[filter].exists>:
      - foreach <server.online_players.exclude[<player>]>:
        - give to:<[inv]> player_head[skull_skin=<[value].skull_skin>;custom_model_data=1;display=<[value].proc[get_player_display_name]>;flag=run_script:target_players_open_callback;flag=script:<[callback]>;flag=player:<[value]>]
    - else:
      - foreach <server.online_players.filter[<[filter]>]>:
        - give to:<[inv]> player_head[skull_skin=<[value].skull_skin>;custom_model_data=1;display=<[value].proc[get_player_display_name]>;flag=run_script:target_players_open_callback;flag=script:<[callback]>;flag=player:<[value]>]
    - inventory open d:<[inv]>

target_players_open_callback:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - run <context.item.flag[script]> def:<context.item.flag[player]>