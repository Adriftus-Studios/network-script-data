butler_summon:
  type: task
  debug: false
  script:
    - define loc <player.location.forward_flat[3]>
    - repeat 20:
      - playeffect redstone <[loc]> visibility:40 quantity:40 special_data:3|orange offset:<[value].mul[0.05]>
      - wait 1t
    - teleport <server.flag[butler_npc].as_npc> <[loc].with_yaw[<[loc].yaw.sub[180]>]>
    - playeffect redstone <[loc]> visibility:40 quantity:40 special_data:3|orange offset:<[value].mul[0.1]>
    - wait 1t
    - narrate "<&6>Adriftus Butler<&co> <&e>How can I help you?"
    - wait 200t
    - inject butler_return_home

butler_return_home:
  type: task
  debug: false
  script:
    - teleport <server.flag[butler_npc].as_npc> <location[spawn_butler_location]>

butler_events:
  type: world
  debug: false
  events:
    on server start:
      - wait 10s
      - if <server.flag[butler_npc].as_npc.location.simple> != <location[spawn_butler_location].simple>:
        - inject butler_return_home

butler_command:
  type: assignment
  debug: false
  actions:
    on assignment:
    - trigger name:click state:true
    - trigger name:damage state:true
    on click:
    - inventory open d:<inventory[butler_menu]>
    on damage:
    - inventory open d:<inventory[butler_menu]>

butler_menu:
  type: inventory
  inventory: chest
  size: 7
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&a>]>
  slots:
  # TODO: Finish inventory (seems to not be)
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

butler_inventory_handler:
  type: world
  debug: true
  events:
    on player clicks item in butler_menu:
    - determine passively cancelled
