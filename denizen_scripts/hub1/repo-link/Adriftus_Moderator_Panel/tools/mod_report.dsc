# -- /report - Player Reporter
mod_report_command:
  type: command
  debug: true
  name: report
  description: Report a player for chat & in-game behaviour.
  usage: /report [username] [reason]
  tab complete:
    - define players <server.online_players.parse[name].exclude[<player.name>]>
    - if <context.args.is_empty>:
      - determine <[players]>
    - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
      - determine <[players].filter[starts_with[<context.args.first>]]>
  script:
    - if <context.args.is_empty>:
      - narrate "<&c>Adriftus Reporter"
      - narrate "<&6>/report [username] [reason]"
    - else if <server.match_offline_player[<context.args.first>]||null> != null:
      - define target <server.match_offline_player[<context.args.first>]>
      - if <[target]> != <player>:
        - if <context.args.get[2]||null> != null:
          - define reason <context.args.get[2].to[<context.args.size>].space_separated>
          - run mod_notify_report def:<list[<player>|<[target].uuid>].include_single[<[reason]>].include[<bungee.server||Server>]>
          - run mod_message_discord_report def:<list[<player>].include_single[<[reason]>].include[<bungee.server||Server>|<[target]>]>
          - narrate "<&e>You have successfully reported <[target].name> for <[reason]>."
        - else:
          - narrate "<&c>A reason must be provided in order to report this player."
      - else:
        - narrate "<&c>You may not report yourself."
    - else:
      - narrate "<&c>Invalid player name entered."
      - narrate "<&c>Use /report [username] [reason]."

# -- /bugreport - Bug Reporter
mod_bugreport_command:
  type: command
  debug: true
  name: bugreport
  description: Report a bug to staff members.
  usage: /bugreport [username] [reason]
  script:
    - if <context.args.is_empty>:
      - narrate "<&c>Adriftus Bug Reporter"
      - narrate "<&6>/bugreport [reason]"
    - else:
      - define reason <context.args.get[1].to[<context.args.size>].space_separated>
      - run mod_notify_bugreport def:<list[<player>].include_single[<[reason]>].include[<bungee.server||Server>]>
      - run mod_message_discord_report def:<list[<player>].include_single[<[reason]>].include[<bungee.server||Server>]>
      - narrate "<&e>You have successfully reported a bug: <[reason]>."

mod_message_discord_report:
  type: task
  debug: false
  definitions: reporter|reason|server|player
  script:
    - define reporter <[reporter].as_player.name>

    - if <[player]||null> == null:
      # -- Messages #🐛bug-reports on the Adriftus server. (601677205445279744/697206135421141152).
      - define channel 697206135421141152
      - define webhook_username <&lb><[server]><&rb><&sp>Bug<&sp>Report
      - define title User<&co><&sp><[reporter]>
      - define title_icon_url https://minotar.net/helm/<[reporter]>
      - define author <map.with[name].as[<[title]>].with[icon_url].as[<[title_icon_url]>]>
    - else:
      - define player <[player].as_player.name>
      # -- Messages #action-log on the Adriftus Staff server. (626078288556851230/715731482978812014).
      - define channel 715731482978812014
      - define webhook_username <&lb><[server]><&rb><&sp>Player<&sp>Report
      - define title User<&co><&sp><[player]>
      - define title_icon_url https://minotar.net/helm/<[player]>
      - define author <map.with[name].as[<[title]>].with[icon_url].as[<[title_icon_url]>]>

    - define webhook_icon_url https://img.icons8.com/nolan/64/inspection.png
    - define embeds <list>

    - define fields <list>
    - define color 8781824

    - define field_name Reason<&co>
    - define field_value <[reason]>
    - define field_inline false
    - define fields:|:<map.with[name].as[<[field_name]>].with[value].as[<[field_value]>].with[inline].as[<[field_inline]>]>

    - define footer_text Reported<&sp>by<&co><&sp><[reporter]>
    - define footer_icon_url https://minotar.net/helm/<[reporter]>
    - define footer <map.with[text].as[<[footer_text]>].with[icon_url].as[<[footer_icon_url]>]>

    - define timestamp <util.time_now.format[yyyy-MM-dd]>T<util.time_now.format[HH:mm:ss.SS]>Z

    - define embeds <[embeds].include[<map.with[color].as[<[color]>].with[fields].as[<[fields]>].with[author].as[<[author]>].with[footer].as[<[footer]>].with[timestamp].as[<[timestamp]>]>]>

    - define data <map.with[username].as[<[webhook_username]>].with[avatar_url].as[<[webhook_icon_url]>].with[embeds].as[<[embeds]>].to_json>
    - define context <list[<[channel]>].include[<[data]>]>
    - bungeerun relay embedded_discord_message_new def:<[context]>
