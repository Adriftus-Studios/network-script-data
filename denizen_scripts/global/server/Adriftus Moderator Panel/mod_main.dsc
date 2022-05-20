# -- TODO
# - Add pagination to online players panel
# - Implement IP Bans

# -- /mod - Adriftus Moderator Panel
mod_command:
  type: command
  debug: false
  permission: adriftus.moderator
  name: mod
  description: Adriftus Moderator Panel
  usage: /mod (username)
  tab complete:
    # -- One Argument Tab Complete
    - define blacklist <player||null>
    - inject online_player_tabcomplete
    # - define arguments <server.online_players.parse[name].exclude[<player.name>]>
    # - if <context.args.is_empty>:
    #   - determine <[arguments]>
    # - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
    #   - determine <[arguments].filter[starts_with[<context.args.first>]]>
  script:
    # -- Hopefully this logic will work & make sense in a few weeks.
    - if <context.args.is_empty>:
      - inject mod_online_inv_open
    - else if <server.match_offline_player[<context.args.first>]||null> != null:
      - if <server.match_offline_player[<context.args.first>].name> == <player.name>:
        - narrate "<&c>You cannot perform actions on yourself."
        - stop
      - if !<player.has_permission[adriftus.admin]> && <server.match_offline_player[<context.args.first>].has_permission[adriftus.admin]>:
        - narrate "<&c>You cannot perform actions on administrators."
        - stop
      - else:
        - flag <player> amp_map:!
        - define uuid <server.match_offline_player[<context.args.first>].uuid>
        # Check if target player is offline
        - if <[uuid].as_player.is_online>:
          # Define YAML ID
          - define id global.player.<[uuid]>
        - else:
          # Define directory and YAML ID
          - define dir data/global/players/<[uuid]>.yml
          - define id amp.target.<[uuid]>
          # Load yaml data
          - ~yaml id:<[id]> load:<[dir]>
        # Save yaml data into map object
        # Use - define map <[map].with[key].as[value]> to avoid object hacking.
        - define map <map.with[uuid].as[<[uuid]>]>
        - define map <[map].with[display_name].as[<yaml[<[id]>].read[Display_Name]||None>]>
        - define map <[map].with[rank].as[<yaml[<[id]>].read[Rank]||None>]>
        - define map <[map].with[current].as[<yaml[<[id]>].read[chat.channels.current]||Server>]>
        - define map <[map].with[active].as[<yaml[<[id]>].read[chat.channels.active]||Server>]>
        # Unload offline player's global data
        - if <yaml.list.contains[amp.target.<[uuid]>]>:
          - yaml unload id:amp.target.<[uuid]>
        # Flag moderator with map of target player's information
        - flag <player> amp_map:<[map]>
        - inject mod_actions_inv_open
    - else:
      - narrate "<&c>Invalid player name entered!"

# -- /amp - Adriftus Moderator Panel
amp_command:
  type: command
  debug: false
  permission: adriftus.moderator
  name: amp
  description: Adriftus Moderator Panel
  usage: /amp
  script:
    - narrate "<&6>Adriftus <&e>Moderator Panel"
    - narrate "<&f>Version 3.1.0 - 2022-04-26"
    - narrate "<&f>Scripted by <&b>Kyu#5957"
    - narrate "<&f>Channel <proc[msg_url].context[<script[amp_url].parsed_key[hover]>|<script[amp_url].parsed_key[text]>|<script[amp_url].parsed_key[url]>]>"

# -- /amp - URL Data
amp_url:
  type: data
  url: https://discord.com/channels/626078288556851230/715731482978812014
  hover: "<&e>View the Action Log."
  text: <&b>#action-log
