# -- KICK PANEL
mod_kick_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f>› <&d>Kick
  inventory: CHEST
  size: 54
  definitions:
    x: <item[air]>
    b1: <item[lime_stained_glass_pane].with[display_name=<&r>]>
    b2: <item[green_stained_glass_pane].with[display_name=<&r>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel;nbt=<list[to/actions]>]>
    head: <item[mod_player_item]>
  slots:
    - [x] [x] [x] [x] [x] [x] [x] [x] [x]
    - [x] [x] [] [x] [] [x] [] [x] [x]
    - [x] [] [x] [x] [] [x] [x] [] [x]
    - [x] [] [] [] [x] [] [] [] [x]
    - [] [] [] [] [] [] [] [] []
    - [back] [b1] [b2] [b1] [head] [b1] [b2] [b1] [back]

mod_kick_inv_events:
  type: world
  debug: false
  events:
    on player right clicks mod_level*_item in mod_kick_inv:
      - run mod_log_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>|Kick
      - run mod_notify_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.nbt[INFRACTION]>|Kick
      - run mod_message_discord def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid].as_player.name>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>|Kick
      - kick <player.flag[amp_map].as_map.get[uuid].as_player> reason:<proc[mod_kick_message].context[<player.uuid>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>]>

mod_kick_inv_open:
  type: task
  debug: false
  script:
    - define items <list>
    - define inventory <inventory[mod_kick_inv]>
    - adjust def:inventory "title:<&6>A<&e>MP <&f>› <&d>Kick <&e><player.flag[amp_map].as_map.get[uuid].as_player.name>."
    - foreach <list[1|2|3]> as:level:
      - foreach <script[mod_kick_infractions].list_keys[<[level]>]> as:infraction:
        - define item <item[mod_level<[level]>_item]>
        - define name <[item].script.parsed_key[tag]><&sp><[infraction]>
        - define lore <list[<&b>Level<&co><&sp><[item].script.parsed_key[colour]><[level]>]>
        - define lore:->:<&e>Right<&sp>Click<&sp>to<&sp>kick<&co>
        - define lore:->:<player.flag[amp_map].as_map.get[uuid].as_player.name>
        - define lore:->:<&e>Clic<&sp>Droit<&sp>pour<&sp>un<&sp>coup<&co>
        - define nbt <list[LEVEL/<[level]>|INFRACTION/<[infraction]>]>
        - define item <[item].with[display_name=<[name]>;lore=<[lore]>;nbt=<[nbt]>]>
        - define items:->:<[item]>
    - give <[items]> to:<[inventory]>
    - inventory open d:<[inventory]>
