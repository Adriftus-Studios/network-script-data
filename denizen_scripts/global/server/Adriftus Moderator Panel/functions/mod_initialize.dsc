# -- Adriftus Moderator Panel flag initialization
mod_initialize:
  type: task
  debug: false
  definitions: uuid
  script:
    - flag <player> amp_map:!
    # Check if target player is offline
    - if <player[<[uuid]>].is_online>:
      # Define YAML ID
      - define id global.player.<[uuid]>
    - else:
      # Define directory and YAML ID
      - define dir data/global/players/<[uuid]>.yml
      - define id amp.target.<[uuid]>
      # Load yaml data
      - ~yaml id:<[id]> load:<[dir]>
    # Define map
    - define map <map.with[uuid].as[<[uuid]>]>
    - define map <[map].with[name].as[<player[<[uuid]>].name>]>
    - define map <[map].with[display_name].as[<yaml[<[id]>].read[Display_Name]||None>]>
    - define map <[map].with[rank].as[<yaml[<[id]>].read[Rank]||None>]>
    - define map <[map].with[current].as[<yaml[<[id]>].read[chat.channels.current]||Server>]>
    - define map <[map].with[active].as[<yaml[<[id]>].read[chat.channels.active]||Server>]>
    # Check if target player is banned
    - if <yaml[<[id]>].contains[banned]>:
      - define map <[map].with[banned.level].as[<yaml[<[id]>].read[banned.level]>]>
      - define map <[map].with[banned.infraction].as[<yaml[<[id]>].read[banned.infraction]>]>
      - define map <[map].with[banned.length].as[<yaml[<[id]>].read[banned.length]>]>
      - define map <[map].with[banned.date].as[<yaml[<[id]>].read[banned.date]>]>
      - define map <[map].with[banned.moderator].as[<yaml[<[id]>].read[banned.moderator]>]>
    # Unload offline player's global data
    - if <yaml.list.contains[amp.target.<[uuid]>]>:
      - yaml unload id:amp.target.<[uuid]>
    # Flag moderator with map of target player's information
    - flag <player> amp_map:<[map]>


