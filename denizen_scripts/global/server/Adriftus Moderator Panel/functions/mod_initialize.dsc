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
    - definemap map:
      uuid: <[uuid]>
      name: <player[<[uuid]>].name>
      display_name: <yaml[<[id]>].read[Display_Name]||None>
      rank: <yaml[<[id]>].read[Rank]||None>
      current: <yaml[<[id]>].read[chat.channels.current]||Server>
      active: <yaml[<[id]>].read[chat.channels.active]||Server>
    # Unload offline player's global data
    - if <yaml.list.contains[amp.target.<[uuid]>]>:
      - yaml unload id:amp.target.<[uuid]>
    # Flag moderator with map of target player's information
    - narrate <[map]>
    - flag <player> amp_map:<[map]>


