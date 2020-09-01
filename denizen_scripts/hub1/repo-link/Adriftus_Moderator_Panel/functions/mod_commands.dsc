# -- /kick listener
mod_kick_command_listener:
  type: world
  debug: false
  events:
    on kick command:
      - determine passively fulfilled
      - inject mod_server_kick_task

mod_server_kick_task:
  type: task
  debug: false
  script:
    - define moderator <tern[<context.source_type.is[==].to[PLAYER]>].pass[<player.uuid>].fail[Server]>
    - define player <server.match_offline_player[<context.args.first>]>
    - define reason <context.args.get[2].to[<context.args.size>].space_separated||1.Kicked>
    - define level <tern[<[reason].char_at[2].is[==].to[.]>].pass[<[reason].before[.]>].fail[1]>
    - define reason <tern[<[reason].char_at[2].is[==].to[.]>].pass[<[reason].after[.]>].fail[<[reason]>]>
    - run mod_log_action def:<[moderator]>|<[player].uuid>|<[level]>|<[reason]>|Kick
    - run mod_notify_action def:<[moderator]>|<[player].uuid>|<[reason]>|Kick
    - run mod_message_discord def:<[moderator]>|<[player].name>|<[level]>|<[reason]>|Kick
    - kick <server.match_player[<context.args.first>]> reason:<proc[mod_kick_message].context[<[moderator]>|<[level]>|<[reason]>]>


# -- /ban listener
mod_ban_command_listener:
  type: world
  debug: false
  events:
    on ban command:
      - determine passively fulfilled
      - inject mod_server_ban_task

mod_server_ban_task:
  type: task
  debug: false
  script:
    - if <context.args.is_empty>:
      - narrate "<&6>A<&e>MP <&6>- /ban -- Server banning."
      - narrate "<&f>/ban [username] (reason)"
    - else if <server.match_offline_player[<context.args.first>]||null> != null:
      - define moderator <tern[<context.source_type.is[==].to[PLAYER]>].pass[<player.uuid>].fail[Server]>
      - define target <server.match_offline_player[<context.args.first>]>
      - if <context.args.size> == 2:
        - define reason <context.args.remove[1].space_separated>
        - define level <context.args.get[2].before[.]>
      - else:
        - define reason Banned
        - define level 3
      - run mod_log_action def:<[moderator]>|<[target].uuid>|<[level]>|<[reason]>|Ban|60d
      - run mod_log_ban def:<[moderator]>|<[target].uuid>|<[level]>|<[reason]>|60d
      - run mod_notify_action def:<[moderator]>|<[target].uuid>|<[reason]>|Ban|60d
      - run mod_message_discord def:<[moderator]>|<[target].as_player.name>|<[level]>|<[reason]>|Ban|60d
      - run mod_ban_player def:<[moderator]>|<[target].uuid>|<[level]>|<[reason]>|60d
    - else:
      - narrate "<&c>Invalid player name entered!"


# -- /sban - Server ban
# -- Potentially convert lines `68` - `82` using https://github.com/AuroraInteractive/network-script-data/blob/master/denizen_scripts/global/server/dependencies/command_dependencies.dsc#L237
mod_server_ban_command:
  type: command
  debug: false
  permission: adriftus.moderator
  name: sban
  aliases:
    - tempban
  description: Temporary server banning
  usage: /sban [username] [duration] (reason)
  tab complete:
    - define Arg1 <server.players.exclude[<player>].parse[name]>
    - define Arg2 <list[7d|14d|30d]>
    - define Arg3 <proc[mod_get_infractions].context[mod_ban_infractions]>
    - inject MultiArg_Command_Tabcomplete

    # -- Two + 1/2 Argument Tab Complete
    # - define players <server.online_players.parse[name].exclude[<player.name>]>
    # - define lengths <list[7d|14d|30d]>
    # - define reasons <proc[mod_get_infractions].context[mod_ban_infractions]>
    # - if <context.args.is_empty>:
    #   - determine <[players]>
    # - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
    #   - determine <[players].filter[starts_with[<context.args.first>]]>
    # - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
    #   - determine <[lengths]>
    # - else if <context.args.size> == 2 && <context.raw_args.ends_with[<&sp>].not>:
    #   - determine <[lengths].filter[starts_with[<context.args.get[2]>]]>
    # - else if <context.args.size> == 2 && <context.raw_args.ends_with[<&sp>]>:
    #   - determine <[reasons]>
    # - else if <context.args.size> == 3 && <context.raw_args.ends_with[<&sp>].not>:
    #   - determine <[reasons].filter[starts_with[<context.args.get[3]>]]>
  script:
    - if <context.args.is_empty>:
      - narrate "<&6>A<&e>MP <&6>- /tempban -- Server banning."
      - narrate "<&f>/tempban [username] [duration] (reason)"
    - else if <server.match_offline_player[<context.args.first>]||null> != null:
      - if <server.match_offline_player[<context.args.first>].name> == <player.name>:
        - narrate "<&c>You cannot perform actions on yourself."
        - stop
      - else if <server.match_offline_player[<context.args.first>].has_permission[adriftus.staff]>:
        - narrate "<&c>You cannot perform actions on other staff members."
        - stop
      - define moderator <tern[<context.source_type.is[==].to[PLAYER]>].pass[<player.uuid>].fail[Server]>
      - define target <server.match_offline_player[<context.args.first>]>
      # -- ? <context.args.get[2].as_duration||null>
      - if <context.args.get[2]||null> != null:
        - define length <context.args.get[2]>
        - define reason <context.args.get[3].to[<context.args.size>].space_separated||3.Banned>
        - define level <tern[<[reason].char_at[2].is[==].to[.]>].pass[<[reason].before[.]>].fail[3]>
        - define reason <tern[<[reason].char_at[2].is[==].to[.]>].pass[<[reason].after[.]>].fail[<[reason]>]>
        - run mod_log_action def:<[moderator]>|<[target].uuid>|<[level]>|<[reason]>|Ban|<[length]>
        - run mod_log_ban def:<[moderator]>|<[target].uuid>|<[level]>|<[reason]>|<[length]>
        - run mod_notify_action def:<[moderator]>|<[target].uuid>|<[reason]>|Ban|<[length]>
        - run mod_message_discord def:<[moderator]>|<[target].name>|<[level]>|<[reason]>|Ban|<[length]>
        - run mod_ban_player def:<[moderator]>|<[target].uuid>|<[level]>|<[reason]>|<[length]>
      - else:
        - narrate "<&c>No ban length entered!"
    - else:
      - narrate "<&c>Invalid player name entered!"


# -- /gban - Global ban
mod_global_ban_command:
  type: command
  debug: false
  permission: adriftus.moderator
  name: gban
  description: Network-wide banning
  usage: /gban [username] [duration] (reason)
  tab complete:
    - define Arg1 <server.players.exclude[<player>].parse[name]>
    - define Arg2 <list[7d|14d|30d]>
    - define Arg3 <proc[mod_get_infractions].context[mod_ban_infractions]>
    - inject MultiArg_Command_Tabcomplete
    # -- Two + 1/2 Argument Tab Complete
    # - define players <server.online_players.parse[name].exclude[<player.name>]>
    # - define lengths <list[7d|14d|30d]>
    # - define reasons <proc[mod_get_infractions].context[mod_ban_infractions]>
    # - if <context.args.is_empty>:
    #   - determine <[players]>
    # - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
    #   - determine <[players].filter[starts_with[<context.args.first>]]>
    # - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
    #   - determine <[lengths]>
    # - else if <context.args.size> == 2 && <context.raw_args.ends_with[<&sp>].not>:
    #   - determine <[lengths].filter[starts_with[<context.args.get[2]>]]>
    # - else if <context.args.size> == 2 && <context.raw_args.ends_with[<&sp>]>:
    #   - determine <[reasons]>
    # - else if <context.args.size> == 3 && <context.raw_args.ends_with[<&sp>].not>:
    #   - determine <[reasons].filter[starts_with[<context.args.get[3]>]]>
  script:
    - if <context.args.is_empty>:
      - narrate "<&6>A<&e>MP <&6>- /gban -- Network-wide banning."
      - narrate "<&f>/gban [username] [duration] (reason)"
    - else if <server.match_offline_player[<context.args.first>]||null> != null:
      - if <server.match_offline_player[<context.args.first>].name> == <player.name>:
        - narrate "<&c>You cannot perform actions on yourself."
        - stop
      - else if <server.match_offline_player[<context.args.first>].has_permission[adriftus.staff]>:
        - narrate "<&c>You cannot perform actions on other staff members."
        - stop
      - define moderator <tern[<context.source_type.is[==].to[PLAYER]>].pass[<player.uuid>].fail[Server]>
      - define target <server.match_offline_player[<context.args.first>]>
      # -- ? <context.args.get[2].as_duration||null>
      - if <context.args.get[2]||null> != null:
        - define length <context.args.get[2]>
        - define reason <context.args.get[3].to[<context.args.size>].space_separated||3.Banned>
        - define level <tern[<[reason].char_at[2].is[==].to[.]>].pass[<[reason].before[.]>].fail[3]>
        - define reason <tern[<[reason].char_at[2].is[==].to[.]>].pass[<[reason].after[.]>].fail[<[reason]>]>
        - run mod_log_action def:<[moderator]>|<[target].uuid>|<[level]>|<[reason]>|Ban|<[length]>
        - run mod_log_ban def:<[moderator]>|<[target].uuid>|<[level]>|<[reason]>|<[length]>
        - run mod_message_discord def:<[moderator]>|<[target].name>|<[level]>|<[reason]>|Ban|<[length]>
        - run mod_ban_player def:<[moderator]>|<[target].uuid>|<[level]>|<[reason]>|<[length]>|global
      - else:
        - narrate "<&c>No ban length entered!"
    - else:
      - narrate "<&c>Invalid player name entered!"


# -- /unban listener
mod_unban_command_listener:
  type: world
  debug: false
  events:
    on unban command:
      - determine passively fulfilled
      - inject mod_server_unban_task

mod_server_unban_task:
  type: task
  debug: false
  script:
    # -- Removes `banned` YAML key from global player data.
    - if <context.args.is_empty>:
      - narrate "<&6>A<&e>MP <&6>- /unban -- Server unbanning."
      - narrate "<&f>/unban [username]"
    - else if <server.match_offline_player[<context.args.first>]||null> != null:
      - define moderator <tern[<context.source_type.is[==].to[PLAYER]>].pass[<player.uuid>].fail[Server]>
      - define uuid <server.match_offline_player[<context.args.first>].uuid>
      - define reason <context.args.get[2]||Unbanned>
      # Define directory and YAML ID
      - define dir data/players/<[uuid]>.yml
      - define id amp.target.<[uuid]>
      # Load yaml data
      - ~yaml id:<[id]> load:<[dir]>
      - define level <yaml[<[id]>].read[banned.level]||1>
      - define infraction <yaml[<[id]>].read[banned.infraction]||Banned>
      - run mod_notify_action def:<[moderator]>|<[uuid]>|<[infraction]>|Unban|<[reason]>
      - run mod_message_discord def:<[moderator]>|<[uuid].as_player.name>|<[level]>|<[infraction]>|Unban
      - yaml id:<[id]> set banned:!
      - ~yaml id:<[id]> savefile:<[dir]>
      - yaml id:<[id]> unload
    - else:
      - narrate "<&c>Invalid player name entered!"


# -- /unban - Server unban
mod_server_unban_command:
  type: command
  debug: false
  permission: adriftus.admin
  name: unsban
  aliases:
    - sunban
  description: Server unbanning
  usage: /unsban [username]
  tab complete:
    - define Arg1 <server.players.exclude[<player>].parse[name]>
    - define Arg2 Unbanned
    - inject MultiArg_Command_Tabcomplete

    # -- One + 1/2 Argument Tab Complete
    # - define arguments <server.online_players.parse[name].exclude[<player.name>]>
    # - if <context.args.is_empty>:
    #   - determine <[arguments]>
    # - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
    #   - determine <[arguments].filter[starts_with[<context.args.first>]]>
    # - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
    #   - determine <list[Unbanned]>
  script:
    # -- Removes `banned` YAML key from global player data.
    - if <context.args.is_empty>:
      - narrate "<&6>A<&e>MP <&6>- /unsban -- Server unbanning."
      - narrate "<&f>/unsban [username]"
    - else if <server.match_offline_player[<context.args.first>]||null> != null:
      - define moderator <tern[<context.source_type.is[==].to[PLAYER]>].pass[<player.uuid>].fail[Server]>
      - define uuid <server.match_offline_player[<context.args.first>].uuid>
      - define reason <context.args.get[2]||Unbanned>
      # Define directory and YAML ID
      - define dir data/players/<[uuid]>.yml
      - define id amp.target.<[uuid]>
      # Load yaml data
      - ~yaml id:<[id]> load:<[dir]>
      - define level <yaml[<[id]>].read[banned.level]||3>
      - define infraction <yaml[<[id]>].read[banned.infraction]||Banned>
      - run mod_notify_action def:<[moderator]>|<[uuid]>|<[infraction]>|Unban|<[reason]>
      - run mod_message_discord def:<[moderator]>|<[uuid].as_player.name>|<[level]>|<[infraction]>|Unban
      - yaml id:<[id]> set banned:!
      - ~yaml id:<[id]> savefile:<[dir]>
      - yaml id:<[id]> unload
    - else:
      - narrate "<&c>Invalid player name entered!"


# -- /ungban - Global unban
mod_global_unban_command:
  type: command
  debug: false
  permission: adriftus.admin
  name: ungban
  aliases:
    - gunban
  description: Network-wide unbanning
  usage: /ungban [username]
  tab complete:
    - define Arg1 <server.players.exclude[<player>].parse[name]>
    - define Arg2 Unbanned
    - inject MultiArg_Command_Tabcomplete
    
    # -- One + 1/2 Argument Tab Complete
    # - define arguments <server.online_players.parse[name].exclude[<player.name>]>
    # - if <context.args.is_empty>:
    #   - determine <[arguments]>
    # - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
    #   - determine <[arguments].filter[starts_with[<context.args.first>]]>
    # - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
    #   - determine <list[Unbanned]>
  script:
    # -- Removes `banned` YAML key from global player data.
    - if <context.args.is_empty>:
      - narrate "<&6>A<&e>MP <&6>- /ungban -- Network-wide unbanning."
      - narrate "<&f>/ungban [username]"
    - else if <server.match_offline_player[<context.args.first>]||null> != null:
      - define moderator <tern[<context.source_type.is[==].to[PLAYER]>].pass[<player.uuid>].fail[Server]>
      - define uuid <server.match_offline_player[<context.args.first>].uuid>
      - define reason <context.args.get[2]||Unbanned>
      # Define directory and YAML ID
      - define dir data/players/<[uuid]>.yml
      - define id amp.target.<[uuid]>
      # Load yaml data
      - ~yaml id:<[id]> load:<[dir]>
      - define level <yaml[<[id]>].read[banned.level]||3>
      - define infraction <yaml[<[id]>].read[banned.infraction]||Banned>
      - run mod_notify_action def:<[moderator]>|<[uuid]>|<[infraction]>|Unban|<[reason]>|global
      - run mod_message_discord def:<[moderator]>|<[uuid].as_player.name>|<[level]>|<[infraction]>|Unban
      - yaml id:<[id]> set banned:!
      - ~yaml id:<[id]> savefile:<[dir]>
      - yaml id:<[id]> unload
    - else:
      - narrate "<&c>Invalid player name entered!"
