# -- ACTIONS PANEL --
mod_actions_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f>· <&5>Actions
  inventory: CHEST
  gui: true
  size: 27
  definitions:
    x: <item[feather].with[display_name=<&sp>;custom_model_data=3]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Player<&sp>list].with_flag[to:online]>
    head: <item[mod_player_item]>
  slots:
    - [x] [x] [x] [x] [head] [x] [x] [x] [x]
    - [x] [] [] [] [x] [] [] [] [x]
    - [back] [x] [x] [x] [x] [x] [x] [x] [x]

mod_actions_inv_events:
  type: world
  debug: false
  events:
    on player right clicks mod_send_item in mod_actions_inv:
      - inject mod_send_inv_open

    on player right clicks mod_teleport_item in mod_actions_inv:
      - teleport <player> <player.flag[amp].get[player].location>
      - run mod_message_discord_command def:<player.uuid>|tp<&sp><player.flag[amp].get[name]>
      - inventory close

    on player right clicks mod_spectate_item in mod_actions_inv:
      - adjust <player> gamemode:spectator
      - teleport <player> <server.match_player[<context.args.first>].location>
      - wait 1t
      - adjust <player> spectator_target:<server.match_player[<context.args.first>]>
      - narrate "<&7>[<&b>ModSpec<&7>] <&a>You are now spectating <player.flag[amp].get[name]>." targets:<player>
      - narrate "<&7>[<&b>ModSpec<&7>] <&a>Use <&hover[<&a>Click to toggle spectator mode.].type[SHOW_TEXT]><&click[/spectate]><&b>/spectate<&end_click><&end_hover> <&a>to return to your last position." targets:<player>
      - run mod_message_discord_command def:<player.uuid>|spectate<&sp><player.flag[amp].get[name]>
      - inventory close

    on player left clicks mod_inventory_item in mod_actions_inv:
      - inject mod_inventory_inv_open

    on player right clicks mod_inventory_item in mod_actions_inv:
      - run inventory_logger_list def:<player.flag[amp].get[player]>

    on player right clicks mod_kick_item in mod_actions_inv:
      - inject mod_kick_inv_open

    on player right clicks mod_ban_item in mod_actions_inv:
      - inject mod_ban_inv_open

    on player right clicks mod_unban_item in mod_actions_inv:
      - define uuid <player.flag[amp].get[uuid]>
      - inject mod_unban_player
      - run mod_chat_notifier def:<player.uuid>|<player.flag[amp].get[uuid]>|<player.flag[amp].get[banned.level]>|<player.flag[amp].get[banned.infraction]>|Unban
      - inventory close

mod_actions_inv_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[mod_actions_inv]>
    - adjust def:inventory "title:<&6>A<&e>MP <&f>· <&5>Actions on <&d><player.flag[amp].get[name]>."
    - define sendItem <tern[<player.flag[amp].get[player].is_online>].pass[<item[mod_send_item]>].fail[<item[air]>]>
    - define teleportItem <tern[<player.flag[amp].get[player].is_online>].pass[<item[mod_teleport_item]>].fail[<item[air]>]>
    - define spectateItem <tern[<player.flag[amp].get[player].is_online>].pass[<item[mod_spectate_item]>].fail[<item[air]>]>
    - define inventoryItem <item[mod_inventory_item]>
    - define kickItem <tern[<player.flag[amp].get[player].is_online>].pass[<item[mod_kick_item]>].fail[<item[air]>]>
    # Check if target player is banned
    - if <player.flag[amp].contains[banned]>:
      - define banItem <item[mod_unban_item]>
    - else:
      - define banItem <item[mod_ban_item]>
    # Give items
    - give <[sendItem]>|<[teleportItem]>|<[spectateItem]>|<[inventoryItem]>|<[kickItem]>|<[banItem]> to:<[inventory]>
    - inventory open d:<[inventory]>
