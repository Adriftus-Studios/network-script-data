mod_report_command:
  type: command
  debug: true
  name: report
  description: Report a player for chat & in-game behaviour.
  usage: /report [username] [reason]
  tab completions:
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
          - run mod_notify_report def:<list[<player>|<[target]>].include_single[<[reason]>].include[<bungee.server||Server>]>
          - narrate "<&e>You have successfully reported <[target].name> for <[reason]>."
        - else:
          - narrate "<&c>A reason must be provided in order to report this player."
      - else:
        - narrate "<&c>You may not report yourself."
    - else:
      - narrate "<&c>Invalid player name entered."
      - narrate "<&c>Use /report [username] [reason]."
