# -- Notes for later!
# - REPLACE TAB COMPLETES WITH NEW TAB COMPLETIONS SYSTEM.
# - MAKE COMMAND DEFINITIONS CONSISTENT BETWEEN COMMANDS. (Definition name, value, usage, etc.)
# - EXPAND CHAT (UN)MUTE FUNCTION.
# - Use <context.args.is_empty> instead of `<context.args.get[1]||null> == null`.
# - Add report commands, that will notify staff and a Discord channel.
# - Replace nested foreach loop in mod_get_infractions procedure in mod_infractions.
# - Split panel scripts up into a folder.

# -- /mod - Adriftus Moderator Panel
mod_command:
  type: command
  debug: false
  permission: mod.staff
  name: mod
  description: Adriftus Moderator Panel
  usage: /mod (username)
  tab complete:
    # -- One Argument Tab Complete
    - define arguments <server.online_players.parse[name].exclude[<player.name>]>
    - if <context.args.is_empty>:
      - determine <[arguments]>
    - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
      - determine <[arguments].filter[starts_with[<context.args.get[1]>]]>
  script:
    # -- Hopefully this logic will work & make sense in a few weeks.
    - if <context.args.is_empty>:
      - inventory open d:<inventory[mod_online_inv]>
    - else if <context.args.get[1]> == version:
      - narrate "<&6>Adriftus <&e>Moderator Panel"
      - narrate "<&f>Version 2.0.0 - 2020-07-31"
      - narrate "<&f>Scripted by <&b>Kyu#5957"
    - else if <server.match_offline_player[<context.args.get[1]>]||null> != null:
      - if <server.match_offline_player[<context.args.get[1]>].name> == <player.name>:
        - narrate "<&c>You cannot perform actions on yourself."
        - stop
      - else if <server.match_offline_player[<context.args.get[1]>].has_permission[mod.staff]>:
        - narrate "<&c>You cannot perform actions on other staff members."
        - stop
      - else:
        - flag <player> amp_map:!
        - define uuid <server.match_offline_player[<context.args.get[1]>].uuid>
        # Check if target player is offline
        - if <[uuid].as_player.is_online>:
          # Define YAML ID
          - define id global.player.<[uuid]>
        - else:
          # Define directory and YAML ID
          - define dir data/globalData/players/<[uuid]>.yml
          - define id amp.target.<[uuid]>
          # Load yaml data
          - ~yaml id:<[id]> load:<[dir]>
        # Save yaml data into map object
        # Use - define map <[map].with[key].as[value]> to avoid object hacking.
        - define map <map.with[uuid].as[<[uuid]>]>
        - define map <[map].with[display_name].as[<yaml[<[id]>].read[Display_Name]||None>]>
        - define map <[map].with[rank].as[<yaml[<[id]>].read[Rank]||None>]>
        - define map <[map].with[current].as[<yaml[<[id]>].read[chat.channels.current]||None>]>
        - define map <[map].with[active].as[<yaml[<[id]>].read[chat.channels.active]||None>]>
        # Unload offline player's global data
        - if <yaml.list.contains[amp.target.<[uuid]>]>:
          - yaml unload id:amp.target.<[uuid]>
        # Flag moderator with map of target player's information
        - flag <player> amp_map:<[map]>
        - inventory open d:<inventory[mod_actions_inv]>
    - else:
      - narrate "<&c>Invalid player name entered!"

