Restart_DCommand:
  type: task
  PermissionRoles:
  # % ██ [ Staff Roles  ] ██
    - Lead Developer
    - Developer

  # % ██ [ Public Roles ] ██
    - Lead Developer
    - Developer
  definitions: Message|Channel|Author|Group
  debug: true
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject Role_Verification
    - inject Command_Arg_Registry
    - waituntil rate:1s <bungee.connected>

  # % ██ [ Verify Arguments                 ] ██
    - if <[Args].size> > <bungee.list.size.add[3]>:
      - stop

    - else if <[Args].is_empty>:
      - define Args:->:Relay

  # % ██ [ Server Argument Check ] ██
    - if <[Args].contains_any[all|network]>:
      - define Servers <bungee.list_servers>
    - else:
      - define Servers <[Args].filter[contains_any[help|cancel|stop|-l|-log|-logs|-c|-conf|-confirmation].not].filter_tag[<list[d|delay|w|wait].contains[<[filter_value].before[:]>].not>]>
      - foreach <[Servers]> as:Server:
        - if !<yaml[bungee.config].contains[servers.<[Server]>]>:
          - narrate "Invalid server."
          - stop
        - else if !<bungee.list_servers.contains[<[Server]>]>:
          - narrate "Server is not online."
          - stop
        - if <server.has_flag[Queue.Restart]>:
          - narrate "Verify if the flag contains the server, if it's within the schedule period, and if it's already in progress."

  # % ██ [ Check for Help Argument          ] ██
    - if <[Args].first> == Help:
      - choose <context.args.size>:
        - case 1:
          - narrate "Helpful information."
        - case 2:
          - narrate "Depends on the sub-command or flag."
        - default:
          - narrate "There's no helping stupid."
      - stop

  # % ██ [ Check for Cancel Argument        ] ██
    - else if <[Args].first.contains_any[Cancel|Stop]>:
      - if <server.has_flag[Queue.Restart]> || <server.flag[Queue.Restart].is_empty>:
      - foreach <[Servers]> as:Server:
        - if !<server.flag[Queue.Restart].parse[get[Server]].contains[<[Server]>]>:
          #$ Verify this server is scheduled to restart
          - narrate "This server is not restarting."
          - stop
        - else:
          - define Map_Data <server.flag[Queue.Restart].filter[get[<[Server]>].is[==].to[<[Server]>]].first>
          - narrate "Restart stopped."
          #$ Bungeerun a task that:
          #% Verifies the server is queued to restart
          #- flag server Queue.Restart:!
          #- announce "Server Restart Cancelled"
      - else:
        - narrate "No Queue to cancel."
        - stop

  # % ██ [ Check for Delay Argument         ] ██
    - if <[Args].parse[before[:]].contains_any[d|delay|w|wait]>:
      - if <[Args].filter_tag[<list[d|delay|w|wait].contains[<[filter_value].before[:]>]>].size> > 1:
        - narrate "this is likely an error, display delay help"
        - stop
      - define DelayArg <[Args].filter_tag[<list[d|delay|w|wait].contains[<[filter_value].before[:]>]>].first.after[:]>
      - if <duration[<[DelayArg]>]||null> == null:
        - define Entry_Results "<[Entry_Results].include[<&nl>**Warning**: `Invalid Duration, Defaulted to fallback: 1 minute.`]>"
        - define Delay 1m
      - if <duration[<[DelayArg]>].in_minutes> > 5:
        - define Entry_Results "<[Entry_Results].include[<&nl>**Warning**: `Invalid Duration, Defaulted to the maximum: 5 minutes.`]>"
        - define Delay 5m
    - else:
      - define Delay 2s

  # % ██ [ Send Message                     ] ██
    - define color Code
    - inject Embedded_Color_Formatting
    - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[description].as[Restarting Servers: <[Servers].parse[replace[_].with[<&sp>].to_titlecase].formatted>]>]>"
    - define Data <map.with[username].as[Network<&sp>Control].with[avatar_url].as[https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>

    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define Headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>

  # % ██ [ Execute Restart Queues           ] ██
    - foreach <[Servers]> as:Server:
      - define DUUID <util.random.duuid.after[_]>
      - bungeerun <[Server]> Discord_Server_Restart def:<[DUUID]>|<[Delay]>|<[Args].contains_any[-l|-log|-logs]>|<[Args].contains_any[-c|-conf|-confirmation]>
      - flag server Queue.Restart:->:<map.with[Server].as[<[Server]>].with[Schedule].as[<util.time_now.add[<[Delay]>]>].with[DUUID].as[<[DUUID]>].with[Channel].as[<[Channel]>]>
