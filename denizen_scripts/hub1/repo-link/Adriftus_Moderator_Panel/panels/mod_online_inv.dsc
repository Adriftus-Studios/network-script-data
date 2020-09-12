# -- ONLINE PLAYERS PANEL --
mod_online_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f>– <&a><server.online_players.size> online.
  inventory: CHEST
  size: 54
  definitions:
    border: <item[light_blue_stained_glass_pane].with[display_name=<&r>]>
    close: <item[red_stained_glass_pane].with[display_name=<&c><&l>Close;nbt=<list[to/close]>]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [border] [border] [border] [border] [close] [border] [border] [border] [border]

mod_online_inv_events:
  type: world
  debug: false
  events:
    on player clicks player_head in mod_online_inv:
      - flag <player> amp_map:!
      - if <server.match_player[<context.item.display.strip_color>].has_permission[adriftus.staff]>:
        - narrate "<&c>You cannot perform actions on other staff members."
        - stop
      - define uuid <server.match_player[<context.item.display.strip_color>].uuid>
      - define map <map.with[uuid].as[<[uuid]>]>
      - define map <[map].with[display_name].as[<yaml[global.player.<[uuid]>].read[Display_Name]||None>]>
      - define map <[map].with[rank].as[<yaml[global.player.<[uuid]>].read[Rank]||None>]>
      - define map <[map].with[current].as[<yaml[global.player.<[uuid]>].read[chat.channels.current]||None>]>
      - define map <[map].with[active].as[<yaml[global.player.<[uuid]>].read[chat.channels.active]||None>]>
      - flag <player> amp_map:<[map]>
      - inject mod_actions_inv_open

mod_online_inv_open:
  type: task
  debug: false
  script:
    - define items <list>
    - define inventory <inventory[mod_online_inv]>
    - foreach <server.online_players> as:player:
      # Match item display name and lore to information about the online player.
      - define name <[player].name>
      - define skin <[player].name>
      - define lore:->:<&2>Nickname<&co><&sp><&r><yaml[global.player.<[player].uuid>].read[Display_Name]||None>
      - define lore:->:<&2>Rank<&co><&sp><&r><yaml[global.player.<[player].uuid>].read[Rank]||None>
      - define lore:->:<&a>Current<&sp>Channel<&co><&sp><&r><yaml[global.player.<[player].uuid>].read[chat.channels.current].to_titlecase||None>
      - define lore:->:<&a>Active<&sp>Channels<&co>
      - define lore:->:<&e><&gt><&r><&sp><yaml[global.player.<[player].uuid>].read[chat.channels.active].separated_by[<&nl><&e><&gt><&r><&sp>].to_titlecase||None>
      # Build the final item.
      - define item <item[player_head].with[display_name=<&a><[name]>;lore=<[lore]>;skull_skin=<[skin]>]>
      # Add the defined item to inventory list.
      - define items:->:<[item]>
    # Give built items to inventory and open it.
    - give <[items]> to:<[inventory]>
    - inventory open d:<[inventory]>
