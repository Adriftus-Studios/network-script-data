admin_mode_spectator:
  type: command
  name: dmsp
  usage: /dmsp
  description: spectator mode, with particles!
  permission: adriftus.admin
  script:
    - if !<player.has_flag[dwisp.data.color1]> || !<player.has_flag[dwisp.data.color2]>:
      - narrate "<&c>You must first set up your dWisp colors with <&b>/dwisp edit"
      - stop
    - if <player.gamemode> != SPECTATOR:
      - flag player dmsp.gamemode:<player.gamemode>
      - adjust <player> gamemode:spectator
      - inject admin_mode_spectator_loop
    - else:
      - adjust <player> gamemode:<player.flag[dmsp.gamemode]>
      - flag player dmsp.gamemode:!

admin_mode_spectator_loop:
  type: task
  debug: false
  script:
    - while <player.is_online> && <player.gamemode> == SPECTATOR:
      - define targets <player.location.find_players_within[100]> if:<[loop_index].mod[10].equals[0]>
      - playeffect at:<player.location> quantity:20 effect:REDSTONE offset:0.5 special_data:5|<player.flag[dwisp.data.color1]> targets:<[targets]>
      - playeffect at:<player.location> quantity:20 effect:REDSTONE offset:0.5 special_data:1|<player.flag[dwisp.data.color2]> targets:<[targets]>
      - wait 2t
