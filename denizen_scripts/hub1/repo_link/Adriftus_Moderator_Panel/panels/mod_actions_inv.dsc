# -- ACTIONS PANEL --
mod_actions_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f>· <&5>Actions
  inventory: CHEST
  size: 27
  definitions:
    x: <item[air]>
    b1: <item[light_blue_stained_glass_pane].with[display_name=<&r>]>
    b2: <item[cyan_stained_glass_pane].with[display_name=<&r>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Player<&sp>list;nbt=<list[to/online]>]>
    head: <item[mod_player_item]>
  slots:
    - [b1] [b2] [b1] [b2] [head] [b2] [b1] [b2] [b1]
    - [b2] [] [x] [] [x] [] [x] [] [b2]
    - [b1] [b2] [b1] [b2] [back] [b2] [b1] [b2] [b1]

mod_actions_inv_events:
  type: world
  debug: false
  events:
    on player clicks mod_ban_item in mod_actions_inv:
      - flag <player> amp_map:<player.flag[amp_map].as_map.with[from].as[<tern[<context.click.is[==].to[right]>].pass[network].fail[server]>]>
      - inject mod_ban_inv_open

    on player clicks mod_send_item in mod_actions_inv:
      - inject mod_send_inv_open

    on player clicks mod_kick_item in mod_actions_inv:
      - inject mod_kick_inv_open

    on player right clicks mod_*mute_item in mod_actions_inv:
      # - Check if target player is muted from somewhere?
      - if <player.flag[amp_map].as_map.get[uuid].as_player.has_flag[muted]>:
        - flag <player.flag[amp_map].as_map.get[uuid].as_player> muted:!
        - run mod_notify_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|Unmuted<&sp>by<&sp><player.name>|Unmute
      - else:
        - flag <player.flag[amp_map].as_map.get[uuid].as_player> muted
        - run mod_notify_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|Muted<&sp>by<&sp><player.name>|Mute
      - inject mod_actions_inv_open

mod_actions_inv_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[mod_actions_inv]>
    - adjust def:inventory "title:<&6>A<&e>MP <&f>· <&5>Actions on <&d><player.flag[amp_map].as_map.get[uuid].as_player.name>."
    - define muteItem <tern[<player.flag[amp_map].as_map.get[uuid].as_player.has_flag[muted]>].pass[<item[mod_unmute_item]>].fail[<item[mod_mute_item]>]>
    - define sendItem <tern[<player.flag[amp_map].as_map.get[uuid].as_player.is_online>].pass[<item[mod_send_item]>].fail[<item[air]>]>
    - define kickItem <tern[<player.has_permission[mod.moderator].and[<player.flag[amp_map].as_map.get[uuid].as_player.is_online>]>].pass[<item[mod_kick_item]>].fail[<item[air]>]>
    - define banItem <tern[<player.has_permission[mod.moderator]>].pass[<item[mod_ban_item]>].fail[<item[air]>]>
    - give <[muteItem]>|<[sendItem]>|<[kickItem]>|<[banItem]> to:<[inventory]>
    - inventory open d:<[inventory]>
