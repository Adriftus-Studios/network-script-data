# -- Teleportation Crystal
teleportation_crystal:
  type: item
  debug: false
  material: firework_star
  display name: <&b><&o>Teleportation Crystal
  lore:
    - <&3>Right Click to open up the teleportation menu.
  mechanisms:
    hides: ALL

# -- Teleportation Crystal Menu
teleportation_crystal_menu:
  type: inventory
  debug: true
  title: <&b>Teleportation Crystal
  inventory: CHEST
  size: 54
  definitions:
    x: <item[air]>
    b1: <item[light_blue_stained_glass_pane].with[display_name=<&r>]>
    b2: <item[cyan_stained_glass_pane].with[display_name=<&r>]>
    close: <item[red_stained_glass_pane].with[display_name=<&c>Cancel]>
  procedural items:
    - define inventory <list>
    - foreach <server.online_players> as:player:
      - define lore <list[<&b>Left<&sp>Click<&sp>to<&sp>teleport<&sp>to<&co><&sp><&e><[player].name>]>
      - define lore:->:<&3>Right<&sp>Click<&sp>to<&sp>request<&sp>to<&sp>teleport<&sp>here
      - define item <item[player_head].with[display_name=<&e><[player].name>;lore=<[lore]>;skull_skin=<[player].name>;nbt=<list[name/<[player].name>]>]>
      - define inventory:->:<[item]>
    - determine <[inventory]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [b2] [b1] [b1] [b2] [close] [b2] [b1] [b1] [b2]

# -- Teleportation Crystal Menu Events
# -> Left Click to request to teleport to player.
# -> Right Click to request to teleport player here.
teleportation_crystal_menu_events:
  type: world
  debug: true
  events:
    on player clicks in teleportation_crystal_menu priority:10:
      - determine cancelled
    
    on player left clicks player_head in teleportation_crystal_menu:
      - define other_player <server.match_offline_player[<context.item.nbt[name]>]>
      # Check if the other player has a map with your player tag.
      - if <[other_player].has_flag[teleportation_crystal]> && <[other_player].is_online>:
        - foreach <[other_player].flag[teleportation_crystal]> as:map:
          - if <[map].contains[<player>]>:
            - define inner_map <[map].get[<player>].as_map>
            - if <[inner_map].get[request_type]> == teleport_here:
              - teleport <player> <[inner_map].get[location].as_location>
              - flag <[other_player]> teleportation_crystal:<-:<[map]>
              - flag <player> teleportation_crystal:<-:<[map].with[<[other_player]>].as[<[inner_map].with[request_type].as[teleport_to]>]>
              - take scriptname:teleportation_crystal from:<[other_player].inventory>
              - take scriptname:teleportation_crystal from:<player.inventory>
              - stop
      # Request to teleport to another player.
      - define teleport_map <map.with[<player>].as[<map.with[request_type].as[teleport_to].with[location].as[<player.location>]>]>
      - flag <[other_player]> teleportation_crystal:->:<[teleport_map]> duration:3m
      - flag <player> teleportation_crystal:->:<map.with[<[other_player]>].as[<[teleport_map].with[request_type].as[teleport_here]>]> duration:3m
      - narrate targets:<[other_player]> "<&3><player.name> <&b>requests to teleport to you!"
      - narrate targets:<[other_player]> "<&b>Use a teleportation crystal to confirm their request. <&3>(Teleport here: <player.name>)"
      - narrate "<&b>You requested to teleport to <&3><[other_player].name>."
    
    on player right clicks player_head in teleportation_crystal_menu:
      - define other_player <server.match_offline_player[<context.item.nbt[name]>]>
      # Check if the other player has a map with your player tag.
      - if <[other_player].has_flag[teleportation_crystal]> && <[other_player].is_online>:
        - foreach <[other_player].flag[teleportation_crystal]> as:map:
          - if <[map].contains[<player>]>:
            - define inner_map <[map].get[<player>].as_map>
            - if <[inner_map].get[request_type]> == teleport_to:
              - teleport <[other_player]> <[inner_map].get[location].as_location>
              - flag <[other_player]> teleportation_crystal:<-:<[map]>
              - flag <player> teleportation_crystal:<-:<[map].with[<[other_player]>].as[<[inner_map].with[request_type].as[teleport_here]>]>
              - take scriptname:teleportation_crystal from:<[other_player].inventory>
              - take scriptname:teleportation_crystal from:<player.inventory>
              - stop
      # Request to teleport a player to you.
      - define teleport_map <map.with[<player>].as[<map.with[request_type].as[teleport_here].with[location].as[<player.location>]>]>
      - flag <[other_player]> teleportation_crystal:->:<[teleport_nap]> duration:3m
      - flag <player> teleportation_crystal:->:<map.with[<[other_player]>].as[<[teleport_map].with[request_type].as[teleport_to]>]> duration:3m
      - narrate targets:<[other_player]> "<&3><player.name> <&b>requests you to teleport to them!"
      - narrate targets:<[other_player]> "<&b>Use a teleportation crystal to confirm their request. <&3>(Teleport to: <player.name>)"
      - narrate "<&b>You requested <&3><[other_player].name> <&b>teleport to you."

