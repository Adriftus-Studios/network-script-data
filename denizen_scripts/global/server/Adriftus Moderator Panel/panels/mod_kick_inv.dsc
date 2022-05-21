# -- KICK PANEL
mod_kick_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f><&gt> <&d>Kick
  inventory: CHEST
  gui: true
  size: 54
  definitions:
    x: <item[air]>
    b1: <item[magenta_stained_glass_pane].with[display_name=<&sp>]>
    b2: <item[purple_stained_glass_pane].with[display_name=<&sp>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel].with_flag[to:actions]>
    head: <item[mod_player_item]>
  slots:
    - [x] [x] [x] [x] [x] [x] [x] [x] [x]
    - [x] [x] [] [x] [] [x] [] [x] [x]
    - [x] [] [x] [x] [] [x] [x] [] [x]
    - [x] [] [] [] [x] [] [] [] [x]
    - [x] [x] [x] [x] [x] [x] [x] [x] [x]
    - [b2] [b1] [b2] [back] [head] [back] [b2] [b1] [b2]

mod_kick_inv_events:
  type: world
  debug: false
  events:
    on player right clicks mod_level*_item in mod_kick_inv:
      - run mod_log_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.flag[LEVEL]>|<context.item.flag[INFRACTION]>|Kick
      - run mod_message_discord def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.flag[LEVEL]>|<context.item.flag[INFRACTION]>|Kick
      - kick <player.flag[amp_map].as_map.get[uuid].as_player> reason:<proc[mod_kick_message].context[<player.uuid>|<context.item.flag[LEVEL]>|<context.item.flag[INFRACTION]>]>
      - inventory close

mod_kick_inv_open:
  type: task
  debug: false
  script:
    - define items <list>
    - define inventory <inventory[mod_kick_inv]>
    - adjust def:inventory "title:<&6>A<&e>MP <&f><&gt> <&d>Kick <&e><player.flag[amp_map].as_map.get[uuid].as_player.name>."
    - foreach <list[1|2|3]> as:level:
      - foreach <script[mod_kick_infractions].list_keys[<[level]>]> as:infraction:
        - define item <item[mod_level<[level]>_item]>
        - define name <[item].flag[tag].parsed><&sp><[infraction]>
        - define lore <list[<&b>Level<&co><&sp><[item].flag[colour].parsed><[level]>]>
        - define lore:->:<&e>Right<&sp>Click<&sp>to<&sp>kick<&co>
        - define lore:->:<player.flag[amp_map].as_map.get[uuid].as_player.name>
        - flag <[item]> LEVEL:<[level]>
        - flag <[item]> INFRACTION:<[infraction]>
        - flag <[item]> LENGTH:<script[mod_ban_infractions].data_key[<[level]>.<[infraction]>.length]>
        - define item <[item].with[display_name=<[name]>;lore=<[lore]>]>
        - define items:->:<[item]>
    - give <[items]> to:<[inventory]>
    - inventory open d:<[inventory]>
