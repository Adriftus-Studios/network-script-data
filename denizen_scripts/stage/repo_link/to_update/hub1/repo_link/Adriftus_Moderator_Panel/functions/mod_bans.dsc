# -- Handle server & network bans.
mod_ban_player:
  type: task
  debug: false
  definitions: moderator|uuid|level|infraction|length|global
  script:
    # -- Check if player is online, set YAML ID to edit accordingly.
    - if <[uuid].as_player.is_online>:
      - if <[global]||null> != null:
        - define id global.player.<[uuid]>
      - else:
        - define id player.<[uuid]>
      - yaml id:<[id]> set banned.level:<[level]>
      - yaml id:<[id]> set banned.infraction:<[infraction]>
      - yaml id:<[id]> set banned.length:<[length]>
      - yaml id:<[id]> set banned.date:<util.time_now>
      - yaml id:<[id]> set banned.moderator:<[moderator]>
      - kick <[uuid].as_player> reason:<proc[mod_kick_message].context[<[moderator]>|<[level]>|<[infraction]>|<[length]>|<util.time_now>]>
    - else:
      - define dir data/<tern[<element[<[global]||null>].is[!=].to[null]>].pass[global/].fail[]>players/<[uuid]>.yml
      - define id amp.banned.<[uuid]>
      - ~yaml id:<[id]> load:<[dir]>
      - yaml id:<[id]> set banned.level:<[level]>
      - yaml id:<[id]> set banned.infraction:<[infraction]>
      - yaml id:<[id]> set banned.length:<[length]>
      - yaml id:<[id]> set banned.date:<util.time_now>
      - yaml id:<[id]> set banned.moderator:<[moderator]>
      - ~yaml id:<[id]> savefile:<[dir]>
      - yaml id:<[id]> unload

# -- Handle on login ban checking.
mod_ban_check:
  type: world
  debug: false
  events:
    after player joins:
      # -- Check if player's global/server YAML data contains an ongoing-ban.
      - wait 2s
      - if <yaml[global.player.<player.uuid>].contains[banned]>:
        - define id global.player.<player.uuid>
      - else if <yaml[player.<player.uuid>].contains[banned]>:
        - define id player.<player.uuid>
      - else:
        - stop
      # If duration since ban date/time is greater than the set duration, remove the banned key from player data.
      - if <util.time_now.duration_since[<yaml[<[id]>].read[banned.date]>].in_seconds> > <yaml[<[id]>].read[banned.length].as_duration.in_seconds>:
        - narrate "<&6>You were banned for <&e><yaml[<[id]>].read[banned.infraction]> <&6>for <&6><yaml[<[id]>].read[banned.length]>."
        - narrate "<&6>Your temporary ban is up. Please review the rules to prevent future incidents."
        - yaml id:<[id]> set banned:!
      # Else, kick 'em.
      - else:
        - kick <player> reason:<proc[mod_kick_message].context[<yaml[<[id]>].read[banned.moderator]>|<yaml[<[id]>].read[banned.level]>|<yaml[<[id]>].read[banned.infraction]>|<yaml[<[id]>].read[banned.length]>|<yaml[<[id]>].read[banned.date]>]>
