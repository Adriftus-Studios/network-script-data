command_play:
  type: command
  debug: false
  name: play
  usage: /play [Server]
  description: Takes you to the named server.
  tab complete:
    - define Args <yaml[bungee_config].list_keys[servers].filter_tag[<yaml[bungee_config].read[servers.<[Filter_Value]>.show_in_play_menu]>].shared_contents[<bungee.list_servers>]>
    - inject OneArg_Command_Tabcomplete
  script:
    # % ██ [ Verify Args ] ██
    - if <context.args.is_empty>:
      - inventory open d:command_play_inventory
      - stop
    - else if <context.args.size> != 1:
      - inject command_syntax

    # % ██ [ Verify Valid Server for Network ] ██
    - define timeout <util.time_now.add[1m]>
    - waituntil rate:1s <bungee.connected> || <[timeout].duration_since[<util.time_now>].in_seconds> == 0 rate:1s
    - if <[timeout].duration_since[<util.time_now>].in_seconds> == 0:
      - narrate "You timed out, or something like that. Nothing interesting happens please try again later"
    - else if !<yaml[bungee_config].contains[servers.<context.args.first.to_lowercase>]>:
      - define Reason "Invalid Server."
      - inject command_error

    # % ██ [ Verify Valid Online Server ] ██
    - else if !<bungee.list_servers.contains[<context.args.first.to_lowercase>]>:
      - define Reason "Server is not currently available."
      - stop

    # % ██ [ Check for Same Server ] ██
    - else if <bungee.server> == <context.args.first.to_lowercase>:
      - define Reason "You're already on <yaml[bungee_config].parsed_key[servers.<context.args.first.to_lowercase>.display_name]>."
      - inject command_error

    # % ██ [ Transfer Server ] ██
    - narrate "<&e>Joining Server<&co> <yaml[bungee_config].parsed_key[servers.<context.args.first.to_lowercase>.display_name]>"
    - adjust <player> send_to:<context.args.first.to_lowercase>

command_play_events:
  type: world
  debug: false
  events:

    on server start:
      - ~run pull_bungee_config

    on script reload:
      - ~run pull_bungee_config

    on player clicks item in command_play_inventory:
      - determine passively cancelled
      - if <context.item.has_flag[server]>:
        - if <bungee.server> != <context.item.flag[server]>:
          - adjust <player> send_to:<context.item.flag[server]>
          - stop
        - if <bungee.server> == <context.item.flag[server]>:
          - narrate "<&c>You are already on the <yaml[bungee_config].parsed_key[servers.<context.item.flag[server]>.display_name]> <&c>server."
          - stop
        - if <bungee.list_servers.contains[<context.item.flag[server]>]>:
          - narrate "<&e>Joining Server<&co> <yaml[bungee_config].parsed_key[servers.<context.item.flag[server]>.display_name]>"
          - adjust <player> send_to:<context.item.flag[server]>
        - else:
          - narrate "<yaml[bungee_config].parsed_key[servers.<context.item.flag[server]>.display_name]> <&c>server is currently offline."

pull_bungee_config:
  type: task
  debug: false
  script:
    - if <yaml.list.contains[bungee_config]>:
      - yaml id:bungee_config unload
    - yaml id:bungee_config load:data/global/bungee/config.yml

command_play_inventory:
  type: inventory
  debug: false
  inventory: chest
  gui: true
  title: <&a>Play Menu
  size: 27
  definitions:
    player: <item[player_head]||<item[human_skull]>>[display_name=<&b><player.name>;lore=<&3>Current<&sp>Server<&co><&sp><yaml[bungee_config].parsed_key[servers.<bungee.server>.display_name]>;skull_skin=<player.uuid>]
  procedural items:
    - foreach <yaml[bungee_config].list_keys[servers]> as:server:
      # Check if the server is set up for /play menu
      - if <yaml[bungee_config].read[servers.<[server]>.show_in_play_menu]||false> :
        - if <yaml[bungee_config].read[servers.<[server]>.restricted]||false> && !<yaml[bungee_config].parsed_key[servers.<[server]>.restricted_check]||true>:
          - foreach next
        # Get the material from the config
        - define item <item[<yaml[bungee_config].read[servers.<[server]>.material]>]>
        # Set the display name
        - adjust <[item]> display_name:<yaml[bungee_config].parsed_key[servers.<[server]>.display_name]> save:item
        # Set the Lore
        # Top Border first
        - define lore:<&e>---------------------
        # Next is the server status
        - if <bungee.list_servers.contains[<[server]>]>:
          - define lore:->:<&a>Server<&sp>Status<&co><&sp>Online
        - else:
          - define lore:->:<&c>Server<&sp>Status<&co><&sp>Offline
        # Then the server's description
        - define lore:|:<yaml[bungee_config].parsed_key[servers.<[server]>.description]>
        # Bottom border
        - define lore:->:<&e>---------------------
        - adjust <entry[item].result> lore:<[lore]> save:item
        - adjust <entry[item].result> flag:server:<[server]> save:item
        - define list:->:<entry[item].result>
    - determine <[list]>
  slots:
    - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [player] [standard_filler] [standard_filler] [standard_filler] [standard_filler]
    - [standard_filler] [] [standard_filler] [] [standard_filler] [] [standard_filler] [] [standard_filler]
    - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [] [standard_filler] [standard_filler] [standard_filler] [standard_filler]

survival_command:
  type: command
  debug: false
  name: survival
  description: Sends a player to the Survival server
  usage: /survival
  script:
  - adjust <player> send_to:survival

hub_command:
  type: command
  debug: false
  name: hub
  description: Sends a player to the Hub server
  usage: /hub
  script:
  - adjust <player> send_to:hub

BehrCraft_Command:
  type: command
  debug: false
  description: Sends a player to the BehrCraft server
  usage: /behrcraft
  name: BehrCraft
  aliases:
  - bc
  script:
  - adjust <player> send_to:behrcraft

test_Command:
  type: command
  debug: false
  description: Sends a player to the test server
  usage: /test
  name: test
  script:
  - adjust <player> send_to:test

stage_Command:
  type: command
  debug: false
  description: Sends a player to the stage server
  usage: /stage
  name: stage
  script:
  - adjust <player> send_to:stage
