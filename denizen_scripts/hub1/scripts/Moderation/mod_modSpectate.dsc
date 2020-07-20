#### UPDATE PERMISSIONS ####
# / SPEC
command_modSpectate:
  type: command
  debug: false
  permission: mod.moderator
  name: spec
  tab complete:
    - define arguments:<server.list_online_players.parse[name].exclude[<player.name>]>
    - if <context.args.size> == 0:
      - determine <[arguments]>
    - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
      - determine <[arguments].filter[starts_with[<context.args.get[1]>]]>
  script:
    - if <player.has_flag[MSenabled]> && <context.args.get[1]||null> == null:
      - flag player MSenabled:!
      - run command_modSpectate_task def:<player>
      - stop
    - if <context.args.get[1]||null> == null:
    # GMs: Survival, Creative, Adventure
      - if <player.gamemode> != SPECTATOR:
        - flag player MSenabled:true
        - flag player lastGM:<player.gamemode>
        - flag player lastLocation:<location[<player.location.x>,<player.location.y>,<player.location.z>,<player.location.world.name>].with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]>
        - adjust <player> gamemode:spectator
        - narrate "<&7>[<&b>ModSpec<&7>] <&a>Toggled ModSpec." targets:<player>
    - else:
      - if <server.list_online_players.parse[name.to_lowercase].contains[<context.args.get[1].to_lowercase>]>:
        - if <player.gamemode> != SPECTATOR:
          - flag player MSenabled:true
          - flag player lastGM:<player.gamemode>
          - flag player lastLocation:<location[<player.location.x>,<player.location.y>,<player.location.z>,<player.location.world.name>].with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]>
        - adjust <player> gamemode:spectator
        - teleport <player> <server.match_player[<context.args.get[1]>].location>
        - narrate "<&7>[<&b>ModSpec<&7>] <&a>You are now spectating <context.args.get[1]>." targets:<player>
      - else:
        - narrate "<&c>That player is not online!"

command_modSpectate_task:
  type: task
  debug: false
  definitions: player
  script:
    - adjust <player> gamemode:<player.flag[lastGM]>
    - teleport <player> <player.flag[lastLocation]>
    - narrate "<&7>[<&b>ModSpec<&7>] <&c>Toggled ModSpec." targets:<player>