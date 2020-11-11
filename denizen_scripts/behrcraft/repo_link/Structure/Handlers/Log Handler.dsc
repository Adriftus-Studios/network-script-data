Login_Handler:
  type: world
  debug: false
  events:
    on player joins:
      - determine passively NONE

    # % ██ [ Adjust Flags ] ██
      - define BlackFlags <list[behrry.protecc.prospecting]>
      - foreach <[BlackFlags]> as:BlackFlag:
        - if <player.has_flag[<[BlackFlag]>]>:
          - flag player <[BlackFlag]>:!
        - if !<player.has_flag[behrry.economy.coins]>:
          - flag player behrry.economy.coins:0

    # % ██ [ Correct Roles ] ██
      - if <player.in_group[Silent]>:
        - execute as_server "lp user <player.name> group add Public"

    # % ██ [ Check for first login ] ██
      - if !<player.has_flag[Behrry.Essentials.FirstLogin]>:
        - flag player Behrry.Essentials.FirstLogin
        - define Message "<&6><player.name> <&d>joined BehrCraft for the first time!"
        - announce <[Message]>
        - stop

    # % ██ [ Check if a hidden mod ] ██
      - if <player.has_flag[behrry.moderation.hide]>:
        - stop

      - inject Chat_Event_Messages path:Join_Event

    on player quits:
      - determine passively NONE

    # % ██ [ Remove Flags ] ██
      - define BlacklistFlags <list[behrry.chat.lastreply|behrry.essentials.inbed|Behrry.Essentials.Sitting]>
      - foreach <[BlacklistFlags]> as:Flag:
        - flag player <[Flag]>:!

    # % ██ [ Cancel if player was kicked ] ██
      - if <player.has_flag[behrry.moderation.kicked]>:
        - stop

    # % ██ [ Check if a hidden mod ] ██
      - if <player.has_flag[behrry.moderation.hide]>:
        - stop

      - inject Chat_Event_Messages path:Quit_Event

Chat_Event_Messages:
  type: task
  debug: false
  script:
    - narrate hello
  Join_Event:
    - define global_yaml global.player.<player.uuid>

    # % ██ [ Load and define display_name ] ██
    - define timeout <util.time_now.add[5m]>
    - waituntil rate:2t <yaml.list.contains[<[global_yaml]>]> || !<player.is_online> || <[timeout].duration_since[<util.time_now>].in_seconds> == 0
    - if !<player.is_online>:
      - stop

    - if !<yaml[<[global_yaml]>].contains[display_name]> || !<yaml.list.contains[<[global_yaml]>]>:
      - define display_name <player.name>
    - else:
      - define display_name <yaml[<[global_yaml]>].read[display_name]>

    - define Message "<[display_name]> <proc[Colorize].context[joined the game.|yellow]>"

  # % ██ [ Print the message ] ██
    - wait 1.5s
    - announce <[Message]>
    - if <bungee.connected> && <bungee.list.contains[Gielinor]>:
      - bungee Gielinor:
        - announce <[Message]>

  Quit_Event:
    - define global_yaml global.player.<player.uuid>

    # % ██ [ Load and define display_name ] ██
    - define timeout <util.time_now.add[5m]>
    - waituntil rate:2t <yaml.list_servers.contains[<[global_yaml]>]> || !<player.is_online> || <[timeout].duration_since[<util.time_now>].in_seconds> == 0
    - if !<player.is_online>:
      - stop

    - if !<yaml[<[global_yaml]>].contains[display_name]> || !<yaml.list.contains[<[global_yaml]>]>:
      - define display_name <player.name>
    - else:
      - define display_name <yaml[<[global_yaml]>].read[display_name]>

    - define Message "<[display_name]> <proc[Colorize].context[left the game.|yellow]>"

  # % ██ [ Print the message ] ██
    - wait 1.5s
    - announce <[Message]>
    - if <bungee.connected> && <bungee.list_servers.contains[Gielinor]>:
      - bungee Gielinor:
        - announce <[Message]>
