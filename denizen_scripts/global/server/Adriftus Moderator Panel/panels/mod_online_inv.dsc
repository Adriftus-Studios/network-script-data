# -- ONLINE PLAYERS PANEL --
mod_online_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f>- <&a>Online Players
  inventory: CHEST
  gui: true
  size: 54
  definitions:
    mask: <item[iron_pickaxe].with[display_name=<&6>Toggle<&sp>Mask;custom_model_data=1]>
    vanish: <item[ender_eye].with[display_name=<&d>Toggle<&sp>Vanish]>
    border: <item[light_blue_stained_glass_pane].with[display_name=<&sp>]>
    close: <item[red_stained_glass_pane].with[display_name=<&c><&l>Close].with_flag[to:close]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [border] [border] [mask] [border] [close] [border] [vanish] [border] [border]

mod_online_inv_events:
  type: world
  debug: false
  events:
    on player clicks player_head in mod_online_inv:
      - flag <player> amp_map:!
      - if <server.match_player[<context.item.display.strip_color>]> == <player>:
        - narrate "<&c>You cannot perform actions on yourself."
        - stop
      - if !<player.has_permission[adriftus.admin]> && <server.match_player[<context.item.display.strip_color>].has_permission[adriftus.admin]>:
        - narrate "<&c>You cannot perform actions on administrators."
        - stop
      - define uuid <server.match_player[<context.item.display.strip_color>].uuid>
      - define map <map.with[uuid].as[<[uuid]>]>
      - define map <[map].with[display_name].as[<yaml[global.player.<[uuid]>].read[Display_Name]||None>]>
      - define map <[map].with[rank].as[<yaml[global.player.<[uuid]>].read[Rank]||None>]>
      - define map <[map].with[current].as[<yaml[global.player.<[uuid]>].read[chat.channels.current]||Server>]>
      - define map <[map].with[active].as[<yaml[global.player.<[uuid]>].read[chat.channels.active]||Server>]>
      - flag <player> amp_map:<[map]>
      - inject mod_actions_inv_open
    on player clicks iron_pickaxe in mod_online_inv:
      - define equipped <yaml[global.player.<player.uuid>].read[masks.current.id].if_null[default]>
      - if <[equipped]> != default:
        - run mask_remove def:<[equipped]>
      - else:
        - run mask_wear def:adriftus_moderator
    on player clicks ender_eye in mod_online_inv:
      - run mod_message_discord_command def:<player.uuid>|vanish<&sp>
      - if <player.has_flag[vanished]>:
        - run mod_unvanish_task
      - else:
        - run mod_vanish_task def:true

mod_online_inv_open:
  type: task
  debug: false
  script:
    # Give user permission to use the moderator mask.
    - run mask_unlock def:adriftus_moderator
    - define items <list>
    - define inventory <inventory[mod_online_inv]>
    - adjust def:inventory "title:<&6>A<&e>MP <&f>- <&a><server.online_players.size> online."
    - foreach <server.online_players> as:player:
      # Match item display name and lore to information about the online player.
      - define name <[player].name>
      - define skin <[player].name>
      - define lore <list[<&2>Nickname<&co><&sp><&r><yaml[global.player.<[player].uuid>].read[Display_Name]||<[player].name>>]>
      - define lore:->:<&2>Rank<&co><&sp><&r><yaml[global.player.<[player].uuid>].read[Rank]||None>
      - define lore:->:<&a>Current<&sp>Channel<&co><&sp><&r><yaml[global.player.<[player].uuid>].read[chat.channels.current].to_titlecase||Server>
      - define lore:->:<&a>Active<&sp>Channels<&co>
      - define lore:->:<&e><&gt><&r><&sp><yaml[global.player.<[player].uuid>].list_keys[chat.channels.active].separated_by[<&nl><&e><&gt><&r><&sp>].to_titlecase||Server>
      # Build the final item.
      - define item <item[player_head].with[display_name=<&a><[name]>;lore=<[lore]>;skull_skin=<[skin]>]>
      # Add the defined item to inventory list.
      - define items:->:<[item]>
    # Give built items to inventory and open it.
    - give <[items]> to:<[inventory]>
    - inventory open d:<[inventory]>
