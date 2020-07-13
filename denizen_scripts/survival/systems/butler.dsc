butler_summon:
  type: task
  script:
    - define loc <player.location.forward_flat[3]>
    - repeat 20:
      - playeffect redstone <[loc]> visibility:40 quantity:40 special_data:3|orange offset:<[value].*[0.05]>
      - wait 1t
    - teleport <server.flag[butler_npc]> <[loc].with_yaw[<[loc].yaw.-[180]>]>
    - playeffect redstone <[loc]> visibility:40 quantity:40 special_data:3|orange offset:<[value].*[0.1]>
    - wait 1t
    - narrate "<&6>Adriftus Butler<&co> <&e>How can I help you?"
    - wait 200t
    - inject butler_return_home

butler_return_home:
  type: task
  script:
    - teleport <server.flag[butler_npc]> <location[spawn_butler_location]>

butler_events:
  type: world
  events:
    on server start:
      - wait 10s
      - if <server.flag[butler_npc].as_npc.location.simple> != <location[spawn_butler_location].simple>:
        - inject butler_return_home

butler_command:
  type: command
  name: open_butler_menu
  permission: not.a.perm
  script:
    - inventory open d:<inventory[butler_menu]> player:<server.match_player[<context.args.get[1]>]>

butler_menu:
  type: inventory
  inventory: chest
  size: 45
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&a>]>
  slots:
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"
    