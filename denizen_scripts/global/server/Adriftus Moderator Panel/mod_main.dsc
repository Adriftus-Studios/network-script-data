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
        - run mod_initialize def:<server.match_offline_player[<context.args.first>].uuid>
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
    - narrate "<&f>Version 3.2.0 - 2022-05-23"
    - narrate "<&f>Scripted by <&b>Kyu#5957"
    - narrate "<&f>Graphics by <&b>Berufeng#6062"
    - narrate "<&f>Channel <proc[msg_url].context[<script[amp_url].parsed_key[hover]>|<script[amp_url].parsed_key[text]>|<script[amp_url].parsed_key[url]>]>"

# -- /amp - URL Data
amp_url:
  type: data
  url: https://discord.com/channels/626078288556851230/715731482978812014
  hover: "<&e>View the Action Log."
  text: <&b>#action-log
