last_server_tracking:
  type: world
  debug: false
  events:
    on player joins:
      - stop if:<bungee.server.equals[hub]>
      - waituntil rate:10t <yaml.list.contains[global.player.<player.uuid>].or[<player.is_online.not>]>
      - if !<player.is_online>:
        - stop
      - run global_player_data_modify def:<player.uuid>|adriftus.last_server|<bungee.server>