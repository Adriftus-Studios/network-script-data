# -- BAN PANEL
mod_ban_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f><&gt> <&c>Ban
  inventory: CHEST
  gui: true
  size: 54
  definitions:
    x: <item[air]>
    b1: <item[yellow_stained_glass_pane].with[display_name=<&r>]>
    b2: <item[orange_stained_glass_pane].with[display_name=<&r>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel;nbt=<list[to/actions]>]>
    head: <item[mod_player_item]>
  slots:
    - [x] [x] [x] [x] [x] [x] [x] [x] [x]
    - [x] [x] [] [x] [] [x] [] [x] [x]
    - [x] [] [] [x] [] [x] [] [] [x]
    - [x] [x] [] [x] [] [x] [] [x] [x]
    - [] [] [] [] [] [] [] [] []
    - [back] [b1] [b2] [b1] [head] [b1] [b2] [b1] [back]

mod_ban_inv_events:
  type: world
  debug: false
  events:
    on player right clicks mod_level*_item in mod_ban_inv:
      - run mod_log_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.flag[LEVEL]>|<context.item.flag[INFRACTION]>|Ban|<context.item.flag[LENGTH]>
      - run mod_log_ban def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.flag[LEVEL]>|<context.item.flag[INFRACTION]>|<context.item.flag[LENGTH]>
      - run mod_notify_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.flag[INFRACTION]>|Ban|<context.item.flag[LENGTH]>
      - run mod_message_discord def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid].as_player.name>|<context.item.flag[LEVEL]>|<context.item.flag[INFRACTION]>|Ban|<context.item.flag[LENGTH]>
      - if <player.flag[amp_map].as_map.get[from]> == server:
        - run mod_ban_player def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.flag[LEVEL]>|<context.item.flag[INFRACTION]>|<context.item.flag[LENGTH]>
      - else if <player.flag[amp_map].as_map.get[from]> == network:
        - run mod_ban_player def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.flag[LEVEL]>|<context.item.flag[INFRACTION]>|<context.item.flag[LENGTH]>|global
      - else:
        - announce to_console "<&c><player.name> triggered an error in mod_ban_inv_events!"
        - announce to_console "<&c>mod_ban_inv_events has an error! amp_map's [from] key is <&6><player.flag[amp_map].as_map.get[from]>."

mod_ban_inv_open:
  type: task
  debug: false
  script:
    - define items <list>
    - define inventory <inventory[mod_ban_inv]>
    - adjust def:inventory "title:<&6>A<&e>MP <&f><&gt> <&c>Ban <&6><player.flag[amp_map].as_map.get[uuid].as_player.name> from <player.flag[amp_map].as_map.get[from].to_titlecase>."
    - foreach <list[1|2|3]> as:level:
      - foreach <script[mod_ban_infractions].list_keys[<[level]>]> as:infraction:
        - define item <item[mod_level<[level]>_item]>
        - define name <[item].script.parsed_key[tag]><&sp><[infraction]>
        - define lore <list[<&b>Level<&co><&sp><[item].script.parsed_key[colour]><[level]>]>
        - define lore:->:<&c>Right<&sp>Click<&sp>to<&sp>ban<&co>
        - define lore:->:<player.flag[amp_map].as_map.get[uuid].as_player.name>
        - define lore:->:<&c>Clic<&sp>Droit<&sp>pour<&sp>bannir<&co>
        - flag <[item]> LEVEL:<[level]>
        - flag <[item]> INFRACTION:<[infraction]>
        - flag <[item]> LENGTH:<script[mod_ban_infractions].data_key[<[level]>.<[infraction]>.length]>
        - define item <[item].with[display_name=<[name]>;lore=<[lore]>]>
        - define items:->:<[item]>
    - give <[items]> to:<[inventory]>
    - inventory open d:<[inventory]>
