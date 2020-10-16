CommandSpy_Command:
  type: command
  name: commandspy
  debug: false
  description: Enables command spying on players
  permission: behrry.moderation.commandspy
  aliases:
    - cspy
    - cmdspy
  usage: /commandspy (on/off)
  Activate:
    - if <player.has_flag[behrry.moderation.commandlistening]>:
      - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
    - else:
      - flag player behrry.moderation.commandlistening
      - narrate "<proc[Colorize].context[CommandSpy Enabled.|green]>"
  Deactivate:
    - if !<player.has_flag[behrry.moderation.commandlistening]>:
      - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
    - else:
      - flag player behrry.moderation.commandlistening:!
      - narrate "<proc[Colorize].context[CommandSpy Enabled.|green]>"
  script:
    - choose <context.args.first||null>:
      - case on:
        - inject locally Activate Instantly
      - case off:
        - inject locally Deactivate Instantly
      - case null:
        - if <player.has_flag[behrry.moderation.commandlistening]>:
          - inject locally Deactivate Instantly
        - else:
          - inject locally Activate Instantly
      - case default:
        - inject Command_Syntax Instantly

command_listener:
  type: world
  debug: false
  events:
    on QE39XC command:
      - determine passively cancelled
      - if !<player.has_permission[behrry.moderation.commandgrant]>:
        - define Hover "<&c>Permission Required<&4>: <&3>behrry.moderation<&b>.<&3>Command<&b>.<&3>CommandGrant"
        - define Text "<&c>You do not have permission."
        - narrate <proc[msg_hover].context[<[Hover]>|<[Text]>]>
        - stop
      - flag <context.args.first||> OpExecuted:<&3>[<&b><player.display_name.strip_color><&3>] duration:1t
      - execute as_op player:<context.args.first||> "<context.args.get[2]||> <context.args.get[3]||> <context.args.get[4].to[99].space_separated||>"
      #- execute as_op player:<context.args.first> "<context.args.get[2]> <context.raw_args.replace[<context.args.get[<context.args.size>]>].with[]>"
    on command:
      - define Blacklist <list[WQGvt6LFz|QE39XC|b|bchat|dialogue|hpos1|hpos2|/hpos1|/hpos2]>
      - if <[Blacklist].contains[<context.command>]> || <context.server> || <player> == <server.match_player[behr_riley]||null>:
        - stop

      - foreach <server.online_players_flagged[behrry.moderation.commandlistening]> as:Moderator:
        - if <[Moderator]> != <player>:
          - if <script[<context.command>_Command].data_key[permission]||null> != null:
            - define Permission <script[<context.command>_Command].data_key[permission]>
          - else:
            - define Permission Invalid
          - if !<player.has_permission[<[Permission]>]> && <[Permission]> != Invalid:
            - define Hover "<&c>Grant Permission<&4>: <&b>/<&3><context.command.to_lowercase> <context.raw_args>"
            - define Text "[<&8><player.display_name.strip_color><&7>]<&3>: <&b>/<&3><context.command.to_lowercase> <context.raw_args>"
            - define Command "QE39XC <player> <context.command.to_lowercase> <context.raw_args.replace[\].with[]||>"
            - if <player.has_flag[OpExecuted]>:
              - narrate targets:<[Moderator]> <player.flag[OpExecuted]><proc[msg_cmd].context[<[Hover]>|<[Text]>|<[Command]>]>
            - else:
              - define Hover1 "<&c>Missing Permission:<&4> <&4><[Permission]>"
              - define Text1 <&c>[<&4><&chr[2716]><&c>]
              - narrate targets:<[Moderator]> <proc[msg_hover].context[<[Hover1]>|<[Text1]>]><&7><proc[msg_cmd].context[<[Hover]>|<[Text]>|<[Command]>]>
          - else:
            - if <[Permission]> == Invalid:
              - define Hover "<&a>Permission<&2>: <&e>N<&6>/<&e>a"
            - else if <player.has_flag[OpExecuted]>:
              - define Hover "<&a>Granted Permission<&2>: <&b>/<&3><context.command.to_lowercase> <context.raw_args>"
            - else:
              - define Hover "<&a>Has Permission<&2>: <&b>/<&3><context.command.to_lowercase> <context.raw_args>"
            - define Text "<&7>[<&8><player.display_name.strip_color><&7>]<&3>: <&b>/<&3><context.command.to_lowercase> <context.raw_args>"
            #- define Command "QE39XC <player> <context.command.to_lowercase> <context.raw_args.replace[\].with[]||>"
            - narrate targets:<[Moderator]> <player.flag[OpExecuted]||><proc[msg_hover].context[<[Hover]>|<[Text]>]>
