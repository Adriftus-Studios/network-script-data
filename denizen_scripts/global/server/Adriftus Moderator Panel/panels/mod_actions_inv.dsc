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
    b1: <item[light_blue_stained_glass_pane].with[display_name=<&sp>]>
    b2: <item[cyan_stained_glass_pane].with[display_name=<&sp>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Player<&sp>list].with_flag[to:online]>
    head: <item[mod_player_item]>
  slots:
    - [b1] [b2] [b1] [b2] [head] [b2] [b1] [b2] [b1]
    - [b2] [] [] [] [b2] [] [] [] [b2]
    - [back] [b2] [b1] [b2] [b1] [b2] [b1] [b2] [b1]

mod_actions_inv_events:
  type: world
  debug: false
  events:
    on player right clicks mod_send_item in mod_actions_inv:
      - inject mod_send_inv_open

    on player right clicks mod_teleport_item in mod_actions_inv:
      - teleport <player> <player.flag[amp_map].as_map.get[uuid].as_player.location>
      - run mod_message_discord_command def:<player.uuid>|tp<&sp><player.flag[amp_map].as_map.get[name]>
      - inventory close

    on player right clicks mod_spectate_item in mod_actions_inv:
      - if <player.gamemode> != SPECTATOR:
        - flag player spectateEnabled
        - flag player lastGM:<player.gamemode>
        - flag player lastLocation:<player.location.with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]>
      - adjust <player> gamemode:spectator
      - adjust <player> spectator_target:<player.flag[amp_map].as_map.get[uuid].as_player>
      - narrate "<&7>[<&b>ModSpec<&7>] <&a>You are now spectating <player.flag[amp_map].as_map.get[name]>." targets:<player>
      - narrate "<&7>[<&b>ModSpec<&7>] <&a>Use <&b>/spectate to return to your last position." targets:<player>
      - run mod_message_discord_command def:<player.uuid>|spectate<&sp><player.flag[amp_map].as_map.get[name]>
      - inventory close

    on player left clicks mod_inventorylog_item in mod_actions_inv:
      - inject mod_inventory_inv_open

    on player right clicks mod_inventorylog_item in mod_actions_inv:
      - run inventory_logger_list def:<player.flag[amp_map].as_map.get[uuid].as_player>

    on player right clicks mod_kick_item in mod_actions_inv:
      - inject mod_kick_inv_open

    on player right clicks mod_ban_item in mod_actions_inv:
      - inject mod_ban_inv_open

mod_actions_inv_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[mod_actions_inv]>
    - adjust def:inventory "title:<&6>A<&e>MP <&f>· <&5>Actions on <&d><player.flag[amp_map].as_map.get[name]>."
    - define sendItem <tern[<player.flag[amp_map].as_map.get[uuid].as_player.is_online>].pass[<item[mod_send_item]>].fail[<item[air]>]>
    - define teleportItem <tern[<player.flag[amp_map].as_map.get[uuid].as_player.is_online>].pass[<item[mod_teleport_item]>].fail[<item[air]>]>
    - define spectateItem <tern[<player.flag[amp_map].as_map.get[uuid].as_player.is_online>].pass[<item[mod_spectate_item]>].fail[<item[air]>]>
    - define inventorylogItem <item[mod_inventorylog_item]>
    - define kickItem <tern[<player.flag[amp_map].as_map.get[uuid].as_player.is_online>].pass[<item[mod_kick_item]>].fail[<item[air]>]>
    - define banItem <item[mod_ban_item]>
    - give <[sendItem]>|<[teleportItem]>|<[spectateItem]>|<[inventorylogItem]>|<[kickItem]>|<[banItem]> to:<[inventory]>
    - inventory open d:<[inventory]>
