# -- /spec - Moderator spectate command
mod_spectate_command:
  type: command
  debug: false
  name: spectate
  permission: adriftus.moderator
  aliases:
    - spec
  description: Moderator spectate
  usage: /spectate (username)
  tab complete:
    - define blacklist <player||null>
    - inject online_player_tabcomplete
    # 1: <server.online_players.parse[name].exclude[<player.name>]>
  script:
    # Disable if already spectating.
    - if ( <player.has_flag[spectateEnabled]> || <player.gamemode> == SPECTATOR ) && <context.args.is_empty>:
      - flag player spectateEnabled:!
      - teleport <player> <player.flag[lastLocation].if_null[<player.bed_spawn>]>
      - adjust <player> gamemode:<player.flag[lastGM].if_null[SURVIVAL]>
      - adjust <player> flying:false
      - narrate "<&7>[<&b>ModSpec<&7>] <&c>Toggled ModSpec." targets:<player>
      - stop
    - if <context.args.is_empty>:
    # GMs: Survival, Creative, Adventure
      - if <player.gamemode> != SPECTATOR:
        - flag player spectateEnabled:true
        - flag player lastGM:<player.gamemode>
        - flag player lastLocation:<player.location.with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]>
        - adjust <player> gamemode:spectator
        - narrate "<&7>[<&b>ModSpec<&7>] <&a>Toggled ModSpec." targets:<player>
    - else:
      - if <server.match_player[<context.args.first>]||null> != null:
        - if <player.gamemode> != SPECTATOR:
          - flag player spectateEnabled
          - flag player lastGM:<player.gamemode>
          - flag player lastLocation:<player.location.with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]>
        - adjust <player> gamemode:spectator
        - adjust <player> spectator_target:<server.match_player[<context.args.first>]>
        - narrate "<&7>[<&b>ModSpec<&7>] <&a>You are now spectating <context.args.first>." targets:<player>
      - else:
        - narrate "<&c>That player is not online!"
