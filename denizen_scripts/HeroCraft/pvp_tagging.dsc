PvP_tagging:
  type: world
  debug: false
  events:
    on player damages player:
      - if !<context.entity.has_flag[pvp]>:
        - define targets:->:<context.entity
        - narrate "<&e><&l>You have entered PvP, do not log out!" targets:<context.entity>
      - if !<context.damager.has_flag[pvp]>:
        - define targets:->:<context.damager
        - narrate "<&e><&l>You have entered PvP, do not log out!" targets:<context.damager>
      - title "title:<&4>PvP Flagged" fade_in:10t stay:1s fade_out:10t targets:<[targets]>
      - flag <context.damager>|<context.entity> pvp expire:30s
      - if !<server.current_bossbars.contains[PvP_<context.damager.uuid>]>:
        - run PvP_Bossbar def:<context.damager>
      - if !<server.current_bossbars.contains[PvP_<context.entity.uuid>]>:
        - run PvP_Bossbar def:<context.entity>
    on player dies bukkit_priority:MONITOR flagged:pvp:
      - flag <player> pvp:!
    on player quits bukkit_priority:LOWEST flagged:pvp:
      - flag <player> pvp:!
      - flag <player> "custom_damage.cause:<&e><&l>PvP Log Out"
      - hurt <player> 10000

PvP_Bossbar:
  type: task
  debug: false
  definitions: player
  script:
    - bossbar create PvP_<[player].uuid> "title:<&4>PvP Timer" color:red progress:<[player].flag_expiration[pvp].from_now.in_milliseconds.div[<duration[30s].in_milliseconds>]> players:<[player]>
    - while <[player].has_flag[pvp]> && <[player].is_online>:
      - bossbar update PvP_<[player].uuid> "title:<&4>PvP<&co> <[player].flag_expiration[pvp].from_now.in_seconds.round> seconds" progress:<[player].flag_expiration[pvp].from_now.in_milliseconds.div[<duration[30s].in_milliseconds>]>
      - wait 1s
    - bossbar remove PvP_<[player].uuid>