# -- SEND PANEL
mod_send_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f>› <&5>Send <&e><player.flag[amp_map].as_map.get[uuid].as_player.name> <&5>to Server.
  inventory: CHEST
  size: 27
  definitions:
    x: <item[air]>
    b1: <item[magenta_stained_glass_pane].with[display_name=<&r>]>
    b2: <item[purple_stained_glass_pane].with[display_name=<&r>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel;nbt=<list[to/actions]>]>
    head: <item[mod_player_item]>
  slots:
    - [b2] [b1] [b1] [b2] [b1] [b2] [b1] [b1] [b2]
    - [x] [] [] [] [] [] [] [] [x]
    - [back] [b2] [b1] [b2] [head] [b2] [b1] [b2] [back]

mod_send_inv_events:
  type: world
  debug: false
  events:
    on player right clicks in mod_send_inv:
      - if <context.item.has_nbt[SERVER]>:
        - define origintodest <bungee.server><&sp>to<&sp><context.item.nbt[SERVER]>
        - run mod_log_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|0|<[origintodest]>|Send
        - run mod_notify_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<[origintodest]>|Send
        - adjust <player.flag[amp_map].as_map.get[uuid].as_player> send_to:<context.item.nbt[SERVER]>

mod_send_inv_open:
  type: task
  debug: false
  script:
    - define items <list>
    - define inventory <inventory[mod_send_inv]>
    - foreach <yaml[bungee_config].list_keys[servers]> as:server:
      - if <yaml[bungee_config].read[servers.<[server]>.show_in_play_menu]>:
        - define lore <list.include[<yaml[bungee_config].parsed_key[servers.<[server]>.description]>]>
        - define lore:->:<&d>Right<&sp>Click<&sp>to<&sp>transfer<&co>
        - define lore:->:<player.flag[amp_map].as_map.get[uuid].as_player.name>
        - define lore:->:<&d>Clic<&sp>Droit<&sp>pour<&sp>envoyer<&co>
        - define nbt <list[SERVER/<[server]>]>
        - define item <yaml[bungee_config].read[servers.<[server]>.material].as_item.with[display_name=<[server]>;lore=<[lore]>;nbt=<[nbt]>]>
        - define items:->:<[item]>
    - give <[items]> to:<[inventory]>
    - inventory open d:<[inventory]>
