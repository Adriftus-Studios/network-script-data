report_lag:
  type: command
  name: report_lag
  debug: false
  script:
    - if <player.has_flag[lag_reported]>:
      - narrate <&1>------------------------------------------------
      - narrate "<&c>You have recently filed a lag report."
      - narrate "<&e>You may file another report in <&a><player.flag[lag_reported].expiration.formatted>."
      - narrate <&1>------------------------------------------------
      - stop
    - define name <player.name>
    - define ping <player.ping>
    - define location <player.location.simple>
    - define entity_map:<map[PLAYER/1]>
    - foreach <player.location.find.entities.within[32].exclude[<player>]>:
      - if <[value].is_npc>:
        - define type NPC
      - else:
        - define type <[value].entity_type>
      - define count <[entity_map].get[<[type]>]||0>
      - define entity_map:<[entity_map].with[<[type]>].as[<[count].+[1]>]>
    - foreach <server.worlds>:
      - define world_entity_count:+:<[value].entities.size>
    - define entity_map:<map[PLAYER/1]>
    - define queues_map:<map[REPORT_LAG/1]>
    - foreach <server.scripts.exclude[<script[report_lag]>]>:
      - define queues_map:<[queues_map].with[<[value].name>].as[<[value].list_queues.size>]>
    - bungeerun relay discord_sendMessage "def:AGDev|alerts|```yaml<&nl>- - - - - - - - - - - - -<&nl> - - - LAG REPORT - - - <&nl>- - - - - - - - - - - - -<&nl><&nl>Player: <[name]><&nl>Ping<&co> <[ping]><&nl>Region<&co> <player.locale><&nl>Location<&co> <[location]><&nl><&nl>#########################################<&nl><&nl>Server<&co> <bungee.server><&nl>Player Count<&co> <server.online_players.size><&nl>Average Ping: <server.online_players.parse[ping].average.round_to[2]><&nl>Player Regions<&co> <server.online_players.parse[locale].deduplicate.separated_by[, ]><&nl>Recent TPS<&co> <server.recent_tps.parse[round_to[2]].separated_by[, ]><&nl>Entity Count<&co> <[world_entity_count]><&nl>RAM Utilization<&co> <server.ram_usage./[1073741824].round_to[2]>GB / <server.ram_max./[1073741824].round_to[2]>GB<&nl><&nl>#########################################<&nl><&nl>Entities Nearby<&co><&nl><[entity_map].to_list.parse[replace[/].with[<&co><&sp>]].separated_by[<&nl>]>```"
    - narrate <&1>------------------------------------------------
    - narrate "<&e>Your lag report has been submitted!"
    - narrate "<&b>Thank you for helping us maintain a quality experience."
    - narrate "<&a> - Adriftus Staff"
    - narrate <&1>------------------------------------------------
    - flag player lag_reported:true duration:5m
