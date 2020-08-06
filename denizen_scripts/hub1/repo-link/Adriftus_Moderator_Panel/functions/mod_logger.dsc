# -- Log Actions
mod_log_action:
  type: task
  debug: false
  definitions: moderator|uuid|level|infraction|action|length
  script:
    # -- Logs moderator actions into date-named log files.
    # Define directory and YAML ID
    - define dir data/globalData/players/<[uuid]>.yml
    - define id global.player.<[uuid]>
    # Load yaml data
    - if !<yaml.list.contains[<[id]>]>:
      - ~yaml id:<[id]> load:<[dir]>
    - define incidents <yaml[<[id]>].read[incidents]||0>
    - yaml id:<[id]> set incidents:<[incidents].add[1]>
    # Save yaml data
    - ~yaml id:<[id]> savefile:<[dir]>
    # Define new log entry.
    - define time <util.time_now>
    - define border ----------------------------------------<&nl>
    - if <[moderator]> != Server:
      - define logModerator MODERATOR<&co><&sp><[moderator].as_player.name>/<[moderator]><&nl>
    - else:
      - define logModerator MODERATOR<&co><&sp><[moderator]><&nl>
    - define logPlayer PLAYER<&co><&sp><[uuid].as_player.name>/<[uuid]><&nl>
    - define logLevel LEVEL<&co><&sp><[level]><&nl>
    - define logInfraction INFRACTION<&co><&sp><[infraction]><&nl>
    - define logAction ACTION<&co><&sp><[action]><&nl>
    - if <[length].exists>:
      - define logLength LENGTH<&co><&sp><[length]><&nl>
    - else:
      - define logLength LENGTH<&co><&sp>Not<&sp>Applied<&nl>
    - define logTime TIME<&co><&sp><[time].format[yyyy-MM-dd<&sp>HH:mm:ss]><&nl>
    # Construct logged contents and log the information.
    - define log:<&nl><[logModerator]><[logPlayer]><[logLevel]><[logInfraction]><[logAction]><[logLength]><[logTime]><[border]>
    - log <[log]> type:info file:plugins/Denizen/data/globalData/admin/moderation/<[time].format[yyyy-MM-dd]>.log

mod_log_ban:
  type: task
  debug: false
  definitions: moderator|uuid|level|infraction|length
  script:
    # -- Logs bans into Player UUID log files.
    # Define new log entry.
    - define time <util.time_now>
    - define border ----------------------------------------<&nl>
    - if <[moderator]> != Server:
      - define logModerator MODERATOR<&co><&sp><[moderator].as_player.name>/<[moderator]><&nl>
    - else:
      - define logModerator MODERATOR<&co><&sp><[moderator]><&nl>
    - define logPlayer PLAYER<&co><&sp><[uuid].as_player.name>/<[uuid]><&nl>
    - define logLevel LEVEL<&co><&sp><[level]><&nl>
    - define logInfraction INFRACTION<&co><&sp><[infraction]><&nl>
    - define logLength LENGTH<&co><&sp><[length]><&nl>
    - define logTime TIME<&co><&sp><[time].format[yyyy-MM-dd<&sp>HH:mm:ss]><&nl>
    # Construct logged contents and log the information.
    - define log:<&nl><[logModerator]><[logPlayer]><[logLevel]><[logInfraction]><[logLength]><[logTime]><[border]>
    - log <[log]> type:info file:plugins/Denizen/data/globalData/bans/<[uuid]>.log
