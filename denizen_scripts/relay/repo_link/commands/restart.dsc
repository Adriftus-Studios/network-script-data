Restart_DCommand:
  type: task
  PermissionRoles:
  # % ██ [ Staff Roles  ] ██
    - Network Administrator
    - Administrator
    - Lead Developer
    - Developer

  # % ██ [ Public Roles ] ██
    - Network Administrator
    - Administrator
    - Lead Developer
    - Developer
  definitions: Message|Channel|Author|Group
  debug: false
  script:
  # % ██ [ Clean Definitions & Inject dependencies ] ██
    - inject role_verification
    - inject command_arg_registry
    - waituntil rate:1s <bungee.connected>

  # % ██ [ Verify Arguments                 ] ██
    - if ( <[args].size> > <bungee.list.size.add[3]> ) || ( !<[args].is_empty> && <[args].first> == help ):
      - define title "Syntax Error"
      - define message "Use `/restart help` for help with this command."
      - define color red
      - inject embedded_color_formatting
      - define embeds <list_single[<map.with[title].as[<[title]>].with[color].as[<[color]>].with[description].as[<[message]>]>]>
      - define data <map.with[username].as[Network<&sp>Control].with[avatar_url].as[https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[embeds]>].to_json>
      - define hook <script[ddtbcty].data_key[WebHooks.<[channel]>.hook]>
      - define headers <yaml[saved_headers].read[discord.webhook_message]>
      - ~webget <[hook]> data:<[data]> headers:<[headers]>
      - stop
    
    - else if <[args].size> == 1 && <[args].first>:
      - define title "Discord Command | `/status <&lt>Server<&gt>"
      - define message "**Description**: Restarts a specific server, or all servers.<&nl>**Server Usage**: `/restart <&lt>Server/All<&gt>`<&nl>**Misc Args**: `/restart help`"
      - define color 8650752
      - define embeds <list_single[<map.with[title].as[<[title]>].with[color].as[<[color]>].with[description].as[<[message]>]>]>
      - define data <map.with[username].as[Network<&sp>Control].with[avatar_url].as[https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[embeds]>].to_json>
      - define hook <script[ddtbcty].data_key[WebHooks.<[channel]>.hook]>
      - define headers <yaml[saved_headers].read[discord.webhook_message]>
      - ~webget <[hook]> data:<[data]> headers:<[headers]>
      - stop

    - else if <[args].is_empty>:
      - define args:->:relay

  # % ██ [ Server Argument Check ] ██
    - if <[args].contains_any[all|network]>:
      - define servers <bungee.list_servers>
    - else:
      - define servers <[args].filter[contains_any[help|cancel|stop|-l|-log|-logs|-c|-conf|-confirmation].not].filter_tag[<list[d|delay|w|wait].contains[<[filter_value].before[:]>].not>]>
      - foreach <[servers]> as:Server:
        - if !<yaml[bungee_config].contains[servers.<[server]>]>:
          - narrate "Invalid server."
          - stop
        - else if !<bungee.list_servers.contains[<[server]>]>:
          - narrate "Server is not online."
          - stop
        - if <server.has_flag[queue.restart]>:
          - narrate "Verify if the flag contains the server, if it's within the schedule period, and if it's already in progress."

  # % ██ [ Check for Help Argument          ] ██
    - if <[args].first> == Help:
      - choose <context.args.size>:
        - case 1:
          - narrate "Helpful information."
        - case 2:
          - narrate "Depends on the sub-command or flag."
        - default:
          - narrate "There's no helping stupid."
      - stop

  # % ██ [ Check for Cancel Argument        ] ██
    - else if <[args].first.contains_any[cancel|stop]>:
      - if <server.has_flag[queue.restart]> || <server.flag[queue.restart].is_empty>:
      - foreach <[servers]> as:Server:
        - if !<server.flag[queue.restart].parse[get[server]].contains[<[server]>]>:
          #$ Verify this server is scheduled to restart
          - narrate "This server is not restarting."
          - stop
        - else:
          - define map_data <server.flag[queue.restart].filter[get[<[server]>].is[==].to[<[server]>]].first>
          - narrate "Restart stopped."
          #$ Bungeerun a task that:
          #% Verifies the server is queued to restart
          #- flag server Queue.Restart:!
          #- announce "Server Restart Cancelled"
      - else:
        - narrate "No Queue to cancel."
        - stop

  # % ██ [ Check for Delay Argument         ] ██
    - if <[args].parse[before[:]].contains_any[d|delay|w|wait]>:
      - if <[args].filter_tag[<list[d|delay|w|wait].contains[<[filter_value].before[:]>]>].size> > 1:
        - narrate "this is likely an error, display delay help"
        - stop
      - define delayarg <[args].filter_tag[<list[d|delay|w|wait].contains[<[filter_value].before[:]>]>].first.after[:]>
      - if <duration[<[delayarg]>]||null> == null:
        - define entry_results "<[entry_results].include[<&nl>**Warning**: `Invalid Duration, Defaulted to fallback: 1 minute.`]>"
        - define delay 1m
      - if <duration[<[delayarg]>].in_minutes> > 5:
        - define entry_results "<[entry_results].include[<&nl>**Warning**: `Invalid Duration, Defaulted to the maximum: 5 minutes.`]>"
        - define delay 5m
    - else:
      - define delay 2s

  # % ██ [ Send Message                     ] ██
    - define color Code
    - inject embedded_color_formatting
    - define embeds "<list_single[<map.with[color].as[<[color]>].with[description].as[Restarting Servers: <[servers].parse[replace[_].with[<&sp>].to_titlecase].formatted>]>]>"
    - define data <map.with[username].as[Network<&sp>Control].with[avatar_url].as[https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[embeds]>].to_json>

    - define hook <script[ddtbcty].data_key[WebHooks.<[channel]>.hook]>
    - define headers <yaml[saved_headers].read[discord.webhook_message]>
    - ~webget <[hook]> data:<[data]> headers:<[headers]>

  # % ██ [ Execute Restart Queues           ] ██
    - foreach <[servers]> as:Server:
      - define duuid <util.random.duuid.after[_]>
      - bungeerun <[server]> Discord_Server_Restart def:<[duuid]>|<[delay]>|<[args].contains_any[-l|-log|-logs]>|<[args].contains_any[-c|-conf|-confirmation]>
      - flag server Queue.Restart:->:<map.with[server].as[<[server]>].with[schedule].as[<util.time_now.add[<[delay]>]>].with[duuid].as[<[duuid]>].with[channel].as[<[channel]>]>
