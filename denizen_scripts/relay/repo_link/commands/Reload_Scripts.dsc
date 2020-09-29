Reload_Scripts_DCommand:
  type: task
  debug: false
  PermissionRoles:
  # % ██ [ Staff Roles  ] ██
    - Lead Developer
    - External Developer
    - Developer

  # % ██ [ Public Roles ] ██
    - Lead Developer
    - Developer
  definitions: message|channel|author|group
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject role_verification
    - inject command_arg_registry
    
  # % ██ [ Verify Arguments            ] ██
    - if <[args].size> == 0:
      - reload
      - define server relay
      - define script_count <server.scripts.size>
    - else if <[args].size> == 1:
      - if <[args].first> == all:
        - foreach <bungee.list_servers> as:Server:
          - run Reload_Scripts_Queue def:<list[<[channel]>].include_single[<map.with[color].as[code].with[server].as[<[server]>]>]>
      - else if !<bungee.list_servers.contains[<[args].first>]>:
        - define description "Command: `/Reload` | Reloads a server's scripts."
        - define syntax "/Reload <&lt>Server<&gt>/All"
        - define context <bungee.list_servers.parse[to_titlecase].include[all].comma_separated>
        - define footer "You typed: <[message]>"
        - define map <map.with[color].as[red].with[description].as[<[description]>].with[syntax].as[<[syntax]>].with[context].as[<[context]>].with[footer].as[<[footer]>]>
      #^- run Embedded_Discord_Message def:<list[Command_Error_Support_Syntax_Context1|<[channel]>].include_single[<[map]>]>
        - define definitions <[map]>
        - inject definition_registry
        - inject embedded_color_formatting
        - inject embedded_time_formatting
        - if <script[ddtbcty].list_keys[webhooks].contains[<[channel]>]>:
            - define token <script[ddtbcty].data_key[webhooks.<[channel]>.hook]>
            - define data <yaml[webhook_template_<[template]>].to_json.parsed>
            - ~webget <[token]> headers:<yaml[saved_headers].read[Discord.Webhook_Message]> data:<[data]> save:test
            - narrate <entry[test].result>
        - stop
      - else:
        - define server <[args].first>
    - run reload_scripts_queue def:<list[<[channel]>].include[<map.with[color].as[code].with[server].as[<[server]>]>]>

Reload_Scripts_Queue:
  type: task
  version: 1.3
  definitions: channel|definitions
  script:
  # % ██ [ Inject Dependencies           ] ██
    - inject definition_registry
    - inject embedded_color_formatting
    - define hook <script[ddtbcty].data_key[webhooks.<[channel]>.hook]>

  # % ██ [ Send Server Data            ] ██
    - ~bungeetag server:<[server]> <server.scripts.parse[name].contains[reload_task]> save:responsive_reload
    - Choose <entry[responsive_reload].result||Invalid>:
      - case true:
        #$ This should be a transcribed embedded message
        - bungeerun <[server]> Reload_Task def:<[hook]>
      - case false:
        #$ This should be a transcribed embedded message
        - ~bungeetag server:<[server]> <server.scripts.size> save:script_count
        - bungee <[server]>:
          - reload
        - define color Yellow
        - inject embedded_color_formatting
        - define title "Script Reload Pushed"
        - define footer "<map.with[text].as[Scripts: <entry[script_count].result> (No Error Response)]>"
        - define embeds <list[<map.with[title].as[<[title]>].with[color].as[<[color]>].with[footer].as[<[footer]>]>]>
        - define data "<map.with[username].as[<[server]> Server].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[embeds]>].to_json>"
        - define hook <[hook]>
        - define headers <yaml[saved_headers].read[Discord.Webhook_Message]>
        - ~webget <[hook]> data:<[data]> headers:<[headers]>
      - default:
        #$ This should be a transcribed embedded message
        - ~bungeetag server:<[server]> <server.scripts.size> save:script_count
        - bungee <[server]>:
          - reload
        - define script_count <entry[script_count].result||invalid>
        - if <[script_count]> == invalid:
          - define color Red
          - define title "Script Reload Pushed"
          - define footer "<map.with[text].as[Scripts: ~ (No Error Response)]>"
        - else:
          - define color Yellow
          - define title "Script Reload Pushed (No Response)"
          - define footer "<map.with[text].as[Scripts: <entry[script_count].result> (No Error Response)]>"
        - inject embedded_color_formatting
        - define embeds <list[<map.with[title].as[<[title]>].with[color].as[<[color]>].with[footer].as[<[footer]>]>]>
        - define data "<map.with[username].as[<[server].to_titlecase> Server].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[embeds]>].to_json>"
        - define hook <[hook]>
        - define headers <yaml[saved_headers].read[discord.webhook_message]>
        - ~webget <[hook]> data:<[data]> headers:<[headers]>


# % ██ [ Relay Induced Reload Task           ] ██
Reload_Task:
  type: task
  debug: false
  definitions: hook
  script:
    - flag server reload_hook:<[hook]> duration:1s
    - reload

Reload_Error_Detection:
  type: world
  debug: false
  events:
    on reload scripts:
    # % ██ [ Verify Relay Induced Reload   ] ██
      - if <server.has_flag[reload_hook]>:
        - if !<context.had_error>:
          - define color Code
          - define title "Scripts Reloaded"
        - else:
          - define color Red
          - define title "Scripts Reloaded (With Errors)"
        - define script_count <server.scripts.size>
        # % ██ [ Respond to Relay        ] ██
        - bungeerun relay reload_response def:<[color]>|<[title]>|<bungee.server>|<[script_count]>|<server.flag[reload_hook]>

Reload_Response:
  type: task
  debug: false
  definitions: color|title|server|script_count|hook
  script:
    # % ██ [ Inject Dependencies           ] ██
    - inject embedded_color_formatting

    - define footer <map.with[text].as[Scripts:<&sp><[script_count]>]>
    - define embeds <list[<map.with[title].as[<[title]>].with[color].as[<[color]>].with[footer].as[<[footer]>]>]>
    - define data "<map.with[username].as[<[server]> Server].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[embeds]>].to_json>"
    - define hook <[hook]>
    - define headers <yaml[saved_headers].read[discord.webhook_message]>
    - ~webget <[hook]> data:<[data]> headers:<[headers]>
