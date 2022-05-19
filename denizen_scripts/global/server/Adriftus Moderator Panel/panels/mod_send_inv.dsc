# -- SEND PANEL
mod_send_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f><&gt> <&5>Send
  inventory: CHEST
  gui: true
  size: 27
  definitions:
    x: <item[air]>
    b1: <item[magenta_stained_glass_pane].with[display_name=<&sp>]>
    b2: <item[purple_stained_glass_pane].with[display_name=<&sp>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel].with_flag[to:actions]>
    head: <item[mod_player_item]>
  slots:
    - [b2] [b1] [b1] [b2] [b1] [b2] [b1] [b1] [b2]
    - [x] [] [] [] [] [] [] [] [x]
    - [b1] [b2] [b1] [back] [head] [back] [b1] [b2] [b1]

mod_send_inv_events:
  type: world
  debug: false
  events:
    on player right clicks item_flagged:SERVER in mod_send_inv:
      - define origintodest <bungee.server><&sp>to<&sp><context.item.flag[SERVER]>
      - run mod_log_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|0|<[origintodest]>|Send
      - run mod_message_discord_command def:<player.uuid>|send<&sp><player.flag[amp_map].as_map.get[uuid].as_player.name><&sp><context.item.flag[SERVER]>
      - adjust <player.flag[amp_map].as_map.get[uuid].as_player> send_to:<context.item.flag[SERVER]>
      - inventory close

mod_send_inv_open:
  type: task
  debug: false
  script:
    - define items <list>
    - define inventory <inventory[mod_send_inv]>
    - adjust def:inventory "title:<&6>A<&e>MP <&f><&gt> <&5>Send <&e><player.flag[amp_map].as_map.get[uuid].as_player.name> <&5>to Server."
    - foreach <yaml[bungee_config].list_keys[servers]> as:server:
      - if <yaml[bungee_config].read[servers.<[server]>.show_in_play_menu]>:
        - define lore <list.include[<yaml[bungee_config].parsed_key[servers.<[server]>.description]>]>
        - define lore:->:<&d>Right<&sp>Click<&sp>to<&sp>transfer<&co>
        - define lore:->:<player.flag[amp_map].as_map.get[uuid].as_player.name>
        - define item <yaml[bungee_config].read[servers.<[server]>.material].as_item.with[display_name=<&f><[server].to_titlecase>;lore=<[lore]>]>
        - flag <[item]> SERVER:<[server]>
        - define items:->:<[item]>
    - give <[items]> to:<[inventory]>
    - inventory open d:<[inventory]>
