admin_mode_spectator:
  type: command
  name: amsp
  usage: /amsp
  description: spectator mode, with particles!
  permission: adriftus.admin
  script:
    - if <player.gamemode> != SPECTATOR:
      - adjust <player> gamemode:spectator
      - inject admin_mode_spectator_loop
    - else:
      - adjust <player> gamemode:creative

admin_mode_spectator_loop:
  type: task
  debug: false
  script:
    - while <player.is_online> && <player.gamemode> == SPECTATOR:
      - playeffect at:<player.location> quantity:20 effect:REDSTONE offset:0.5 special_data:5|black visibility:50
      - wait 2t