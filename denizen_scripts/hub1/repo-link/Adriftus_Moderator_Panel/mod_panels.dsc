# -- Split panel scripts up into a folder.
# -- GLOBAL INVENTORY EVENTS --
mod_global_inv_events:
  type: world
  debug: false
  events:
    on player clicks item in mod_*_inv priority:10:
      - determine cancelled
    
    on player drags item in mod_*_inv priority:10:
      - determine cancelled

    on player clicks red_stained_glass_pane in mod_*_inv:
      - if <context.item.has_nbt[to]>:
        - choose <context.item.nbt[to]>:
          - case actions:
            - inventory open d:<inventory[mod_actions_inv]>
          - case online:
            - inventory open d:<inventory[mod_online_inv]>
          - default:
            - inventory close

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
  procedural items:
    - define inventory:<list>
    # Loop over list of online players.
    - foreach <server.online_players> as:player:
      # Match item display name and lore to information about the online player.
      - define name:<[player].name>
      - define skin:<[player].name>
      - define lore:|:<&2>Nickname<&co><&sp><&r><yaml[global.player.<[player].uuid>].read[Display_Name]||None>
      - define lore:|:<&2>Rank<&co><&sp><&r><yaml[global.player.<[player].uuid>].read[Rank]||None>
      - define lore:|:<&a>Current<&sp>Channel<&co><&sp><&r><yaml[global.player.<[player].uuid>].read[chat.channels.current].to_titlecase||None>
      - define lore:|:<&a>Active<&sp>Channels<&co>
      - define lore:|:<&e><&gt><&r><&sp><yaml[global.player.<[player].uuid>].read[chat.channels.active].separated_by[<&nl><&e><&gt><&r><&sp>].to_titlecase||None>
      # Build the final item.
      - define item:<item[player_head].with[display_name=<&a><[name]>;lore=<[lore]>;skull_skin=<[skin]>]>
      # Add the defined item to inventory list.
      - define inventory:|:<[item]>
    # Replace empty slots in inventory with player heads.
    - determine <[inventory]>
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
      - if <server.match_player[<context.item.display.strip_color>].has_permission[mod.staff]>:
        - narrate "<&c>You cannot perform actions on other staff members."
        - stop
      - define uuid <server.match_player[<context.item.display.strip_color>].uuid>
      - define map <map.with[uuid].as[<[uuid]>]>
      - define map <[map].with[display_name].as[<yaml[global.player.<[uuid]>].read[Display_Name]||None>]>
      - define map <[map].with[rank].as[<yaml[global.player.<[uuid]>].read[Rank]||None>]>
      - define map <[map].with[current].as[<yaml[global.player.<[uuid]>].read[chat.channels.current]||None>]>
      - define map <[map].with[active].as[<yaml[global.player.<[uuid]>].read[chat.channels.active]||None>]>
      - flag <player> amp_map:<[map]>
      - inventory open d:<inventory[mod_actions_inv]>


# -- ACTIONS PANEL --
mod_actions_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f>· <&5>Actions on <&d><player.flag[amp_map].as_map.get[uuid].as_player.name>.
  inventory: CHEST
  size: 27
  definitions:
    x: <item[air]>
    b1: <item[light_blue_stained_glass_pane].with[display_name=<&r>]>
    b2: <item[cyan_stained_glass_pane].with[display_name=<&r>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Player<&sp>list;nbt=<list[to/online]>]>
    head: <item[mod_player_item]>
  procedural items:
    - define muteItem <tern[<player.flag[amp_map].as_map.get[uuid].as_player.has_flag[muted]>].pass[<item[mod_unmute_item]>].fail[<item[mod_mute_item]>]>
    - define sendItem <item[mod_send_item]>
    - define kickItem <tern[<player.has_permission[mod.moderator]>].pass[<item[mod_kick_item]>].fail[<item[air]>]>
    - define banItem <tern[<player.has_permission[mod.moderator]>].pass[<item[mod_ban_item]>].fail[<item[air]>]>
    - determine <list[<[muteItem]>|<[sendItem]>|<[kickItem]>|<[banItem]>]>
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
      - inventory open d:<inventory[mod_ban_inv]>

    on player clicks mod_send_item in mod_actions_inv:
      - inventory open d:<inventory[mod_send_inv]>

    on player clicks mod_kick_item in mod_actions_inv:
      - inventory open d:<inventory[mod_kick_inv]>

    on player right clicks mod_*mute_item in mod_actions_inv:
      # - Check if target player is muted from somewhere?
      - if <player.flag[amp_map].as_map.get[uuid].as_player.has_flag[muted]>:
        - flag <player.flag[amp_map].as_map.get[uuid].as_player> muted:!
        - run mod_notify_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|1|Unmuted<&sp>by<&sp><player.name>|Unmute
      - else:
        - flag <player.flag[amp_map].as_map.get[uuid].as_player> muted
        - run mod_notify_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|1|Muted<&sp>by<&sp><player.name>|Mute
      - inventory open d:<inventory[mod_actions_inv]>


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
  procedural items:
    - define inventory:<list>
    - foreach <yaml[bungee.config].list_keys[servers]> as:server:
      - if <yaml[bungee.config].read[servers.<[server]>.show_in_play_menu]>:
        - define name <[server]>
        - define lore <list[].include[<yaml[bungee.config].read[servers.<[server]>.description].parsed>]>
        - define lore:|:<&d>Right<&sp>Click<&sp>to<&sp>transfer<&co>
        - define lore:|:<player.flag[amp_map].as_map.get[uuid].as_player.name>
        - define lore:|:<&d>Clic<&sp>Droit<&sp>pour<&sp>envoyer<&co>
        - define nbt <list[SERVER/<[server]>]>
        - define item <yaml[bungee.config].read[servers.<[server]>.material].as_item.with[display_name=<[name]>;lore=<[lore]>]>
        - define inventory:|:<[item]>
    - determine <[inventory]>
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
        - run mod_notify_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|0|<[origintodest]>|Send
        - adjust <player.flag[amp_map].as_map.get[uuid].as_player> send_to:<context.item.nbt[SERVER]>


# -- KICK PANEL
mod_kick_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f>› <&d>Kick <&e><player.flag[amp_map].as_map.get[uuid].as_player.name>.
  inventory: CHEST
  size: 54
  definitions:
    x: <item[air]>
    b1: <item[lime_stained_glass_pane].with[display_name=<&r>]>
    b2: <item[green_stained_glass_pane].with[display_name=<&r>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel;nbt=<list[to/actions]>]>
    head: <item[mod_player_item]>
  procedural items:
    - define inventory:<list>
    - foreach <list[1|2|3]> as:level:
      - foreach <script[mod_kick_infractions].list_keys[<[level]>]> as:infraction:
        - define item <item[mod_level<[level]>_item]>
        - define name <[item].script.parsed_key[tag]><&sp><[infraction]>
        - define lore <list[<&b>Level<&co><&sp><[item].script.parsed_key[colour]><[level]>]>
        - define lore:|:<&e>Right<&sp>Click<&sp>to<&sp>kick<&co>
        - define lore:|:<player.flag[amp_map].as_map.get[uuid].as_player.name>
        - define lore:|:<&e>Clic<&sp>Droit<&sp>pour<&sp>un<&sp>coup<&co>
        - define nbt <list[LEVEL/<[level]>|INFRACTION/<[infraction]>]>
        - define item <[item].with[display_name=<[name]>;lore=<[lore]>;nbt=<[nbt]>]>
        - define inventory:|:<[item]>
    - determine <[inventory]>
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
      - run mod_notify_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>|Kick
      - run mod_message_discord def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid].as_player.name>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>|Kick
      - kick <player.flag[amp_map].as_map.get[uuid].as_player> reason:<proc[mod_kick_message].context[<player.uuid>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>]>


# -- BAN PANEL
mod_ban_inv:
  type: inventory
  debug: false
  title: <&6>A<&e>MP <&f>› <&c>Ban <&6><player.flag[amp_map].as_map.get[uuid].as_player.name> from <player.flag[amp_map].as_map.get[from].to_titlecase>.
  inventory: CHEST
  size: 54
  definitions:
    x: <item[air]>
    b1: <item[yellow_stained_glass_pane].with[display_name=<&r>]>
    b2: <item[orange_stained_glass_pane].with[display_name=<&r>]>
    back: <item[red_stained_glass_pane].with[display_name=<&c><&l>↩<&sp>Actions<&sp>panel;nbt=<list[to/actions]>]>
    head: <item[mod_player_item]>
  procedural items:
    - define inventory:<list>
    - foreach <list[1|2|3]> as:level:
      - foreach <script[mod_ban_infractions].list_keys[<[level]>]> as:infraction:
        - define item <item[mod_level<[level]>_item]>
        - define name <[item].script.parsed_key[tag]><&sp><[infraction]>
        - define lore <list[<&b>Level<&co><&sp><[item].script.parsed_key[colour]><[level]>]>
        - define lore:|:<&c>Right<&sp>Click<&sp>to<&sp>ban<&co>
        - define lore:|:<player.flag[amp_map].as_map.get[uuid].as_player.name>
        - define lore:|:<&c>Clic<&sp>Droit<&sp>pour<&sp>bannir<&co>
        - define nbt <list[LEVEL/<[level]>|INFRACTION/<[infraction]>|LENGTH/<script[mod_ban_infractions].data_key[<[level]>.<[infraction]>.length]>]>
        - define item <[item].with[display_name=<[name]>;lore=<[lore]>;nbt=<[nbt]>]>
        - define inventory:|:<[item]>
    - determine <[inventory]>
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
      - run mod_log_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>|Ban|<context.item.nbt[LENGTH]>
      - run mod_log_ban def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>|<context.item.nbt[LENGTH]>
      - run mod_notify_action def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>|Ban|<context.item.nbt[LENGTH]>
      - run mod_message_discord def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid].as_player.name>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>|Ban|<context.item.nbt[LENGTH]>
      - if <player.flag[amp_map].as_map.get[from]> == server:
        - run mod_ban_player def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>|<context.item.nbt[LENGTH]>
      - else if <player.flag[amp_map].as_map.get[from]> == network:
        - run mod_ban_player def:<player.uuid>|<player.flag[amp_map].as_map.get[uuid]>|<context.item.nbt[LEVEL]>|<context.item.nbt[INFRACTION]>|<context.item.nbt[LENGTH]>|global
      - else:
        - announce to_console "<&c><player.name> triggered an error in mod_ban_inv_events!"
        - announce to_console "<&c>mod_ban_inv_events has an error! amp_map's [from] key is <&6><player.flag[amp_map].as_map.get[from]>."
