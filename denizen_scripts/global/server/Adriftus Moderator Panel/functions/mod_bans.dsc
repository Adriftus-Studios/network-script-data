# -- Handle network bans. (Implement IP bans!)
mod_ban_player:
  type: task
  debug: false
  definitions: moderator|uuid|level|infraction|length
  script:
    - define map <map[banned.level=<[level]>;banned.infraction=<[infraction]>;banned.length=<[length]>;banned.date=<util.time_now>;banned.moderator=<[moderator]>]>
    - run global_player_data_modify_multiple def:<[uuid]>|<[map]>
    - if <player[<[uuid]>].is_online>:
      - kick <player[<[uuid]>]> reason:<proc[mod_kick_message].context[<[moderator]>|<[level]>|<[infraction]>|<[length]>|<util.time_now>]>

# -- Handle unbans.
mod_unban_player:
  type: task
  debug: false
  definitions: uuid
  script:
    - define moderator <player.uuid.if_null[Server]>
    - define reason Unbanned
    # Define directory and YAML ID
    - define dir data/global/players/<[uuid]>.yml
    - define id amp.target.<[uuid]>
    # Load YAML data and remove banned key
    - ~yaml id:<[id]> load:<[dir]>
    - yaml id:<[id]> set banned:!
    # Send Discord message to #action-log
    - define level <yaml[<[id]>].read[banned.level]||3>
    - define infraction <yaml[<[id]>].read[banned.infraction]||Banned>
    - run mod_message_discord def:<[moderator]>|<[uuid]>|<[level]>|<[infraction]>|Unban
    # Save YAML and unload
    - ~yaml id:<[id]> savefile:<[dir]>
    - yaml id:<[id]> unload

# -- Handle on login ban checking.
mod_ban_check:
  type: world
  debug: false
  events:
    after resource pack status:
      - if <server.has_flag[resourcepackurl]>:
        - choose <context.status>:
          - case FAILED_DOWNLOAD DECLINED ACCEPTED:
            - stop
          - case SUCCESSFULLY_LOADED:
            # -- Check if player's global YAML data contains an ongoing-ban.
            - wait 3s
            - if <yaml[global.player.<player.uuid>].contains[banned]>:
              - define id global.player.<player.uuid>
            - else:
              - stop
            # If duration since ban date/time is greater than the set duration, remove the banned key from player data.
            - if <util.time_now.duration_since[<yaml[<[id]>].read[banned.date]>].in_seconds> > <yaml[<[id]>].read[banned.length].as_duration.in_seconds>:
              - yaml id:<[id]> set banned:!
              - narrate "<&6>You were banned for <&e><yaml[<[id]>].read[banned.infraction]> <&6>for <&6><yaml[<[id]>].read[banned.length]>."
              - narrate "<&6>Your temporary ban is up. Please review the rules to prevent future incidents."
            # Else, kick 'em.
            - else:
              - kick <player> reason:<proc[mod_kick_message].context[<yaml[<[id]>].read[banned.moderator]>|<yaml[<[id]>].read[banned.level]>|<yaml[<[id]>].read[banned.infraction]>|<yaml[<[id]>].read[banned.length]>|<yaml[<[id]>].read[banned.date]>]>
