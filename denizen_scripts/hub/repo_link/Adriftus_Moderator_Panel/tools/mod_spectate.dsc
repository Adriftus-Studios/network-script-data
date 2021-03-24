# -- /spec - Moderator spectate command
mod_spectate_command:
  type: command
  debug: true
  name: spec
  aliases:
    - spectate
  description: Moderator spectate
  usage: /spec (username)
  tab complete:
    - define blacklist <player||null>
    - inject online_player_tabcomplete
    # 1: <server.online_players.parse[name].exclude[<player.name>]>
  script:
    - if <player.has_flag[spectateEnabled]> && <context.args.is_empty>:
      - flag player spectateEnabled:!
      - adjust <player> gamemode:<player.flag[lastGM]>
      - adjust <player> flying:false
      - teleport <player> <player.flag[lastLocation]>
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
        - teleport <player> <server.match_player[<context.args.first>].location>
        - narrate "<&7>[<&b>ModSpec<&7>] <&a>You are now spectating <context.args.first>." targets:<player>
      - else:
        - narrate "<&c>That player is not online!"

mod_spectate_events:
  type: world
  debug: false
  events:
    on player joins:
      - flag player spectateEnabled:!
      - flag player lastGM:!
      - flag player lastLocation:!
      - adjust <player> gamemode:SURVIVAL
      - adjust <player> flying:false
