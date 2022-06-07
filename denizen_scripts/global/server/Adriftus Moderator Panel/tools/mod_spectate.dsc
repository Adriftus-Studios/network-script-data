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
    - define blacklist <player.if_null[null]>
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
    # /spectate from Survival, Adventure, or Creative mode.
    - if <context.args.is_empty>:
      - adjust <player> gamemode:spectator
      - narrate "<&7>[<&b>ModSpec<&7>] <&a>Toggled ModSpec." targets:<player>
    # Mod provides an argument.
    - else:
      - if <server.match_player[<context.args.first>].if_null[null]> != null:
        - adjust <player> gamemode:spectator
        - adjust <player> spectator_target:<server.match_player[<context.args.first>]>
        - narrate "<&7>[<&b>ModSpec<&7>] <&a>You are now spectating <context.args.first>." targets:<player>
      - else:
        - narrate "<&c>That player is not online!"

mod_spectate_events:
  type: world
  debug: false
  events:
    on player changes gamemode to spectator:
      - flag player spectateEnabled:true
      - flag player lastGM:<player.gamemode>
      - flag player lastLocation:<player.location.with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]>
