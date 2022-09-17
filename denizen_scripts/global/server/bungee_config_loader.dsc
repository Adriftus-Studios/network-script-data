bungee_config_loader:
  type: world
  debug: false
  load:
    - if <yaml.list.contains[bungee_config]>:
      - yaml id:bungee_config unload
    - yaml id:bungee_config load:data/global/network/bungee_config.yml
  events:
    on server start:
      - inject locally path:load
    on script reload:
      - inject locally path:load