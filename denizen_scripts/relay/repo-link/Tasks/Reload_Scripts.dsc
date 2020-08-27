Reload_Scripts_DCommand:
  type: task
  PermissionRoles:
  # % ██ [ Staff Roles  ] ██
    - Lead Developer
    - External Developer
    - Developer

  # % ██ [ Public Roles ] ██
    - Lead Developer
    - Developer
  definitions: Message|Channel|Author|Group
  Context: Color
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject Role_Verification
    - inject Command_Arg_Registry
    
  # % ██ [ Verify Arguments            ] ██
    - if <[Args].size> == 0:
      - reload
      - define Server Relay
      - define ScriptCount <server.scripts.size>
    - else if <[Args].size> == 1:
      - if <[Args].first> == all:
        - foreach <bungee.list_servers> as:Server:
          - run Reload_Scripts_Queue def:<list[<[Channel]>].include_single[<map.with[Color].as[Code].with[Server].as[<[Server]>]>]>
      - else if !<bungee.list_servers.contains[<[Args].first>]>:
        - define Description "Command: `/Reload` | Reloads a server's scripts."
        - define Syntax "/Reload <&lt>Server<&gt>/All"
        - define Context <bungee.list_servers.parse[To_Titlecase].include[All].comma_separated>
        - define Footer "You typed: <[Message]>"
        - define map <map.with[Color].as[red].with[Description].as[<[Description]>].with[Syntax].as[<[Syntax]>].with[Context].as[<[Context]>].with[Footer].as[<[Footer]>]>
      #^- run Embedded_Discord_Message def:<list[Command_Error_Support_Syntax_Context1|<[Channel]>].include_single[<[Map]>]>
        - define Definitions <[Map]>
        - inject Definition_Registry
        - inject Embedded_Color_Formatting
        - inject Embedded_Time_Formatting
        - if <script[DDTBCTY].list_keys[WebHooks].contains[<[Channel]>]>:
            - define Token <script[DDTBCTY].data_key[WebHooks.<[Channel]>.Hook]>
            - define Data <yaml[webhook_template_<[Template]>].to_json.parsed>
            - ~webget <[Token]> headers:<yaml[Saved_Headers].read[Discord.Webhook_Message]> data:<[Data]> save:test
            - narrate <entry[test].result>
        - stop
      - else:
        - define Server <[Args].first>
    - run Reload_Scripts_Queue def:<list[<[Channel]>].include[<map.with[Color].as[Code].with[Server].as[<[Server]>]>]>

Reload_Scripts_Queue:
  type: task
  version: 1.2
  definitions: Channel|Definitions
  script:
  # % ██ [ Inject Dependencies           ] ██
    - inject Definition_Registry
    - inject Embedded_Color_Formatting
    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>

  # % ██ [ Send Server Data            ] ██
    - ~bungeetag server:<[Server]> <server.scripts.parse[name].contains[Reload_Task]> save:ResponsiveReload
    - Choose <entry[ResponsiveReload].result||Invalid>:
      - case true:
        #$ This should be a transcribed embedded message
        - bungeerun <[Server]> Reload_Task def:<[Hook]>
      - case false:
        #$ This should be a transcribed embedded message
        - ~bungeetag server:<[Server]> <server.scripts.size> save:ScriptCount
        - bungee <[Server]>:
          - reload
        - define color Yellow
        - inject Embedded_Color_Formatting
        - define Title "Script Reload Pushed"
        - define Footer "<map.with[text].as[Scripts: <entry[ScriptCount].result> (No Error Response)]>"
        - define Embeds <list[<map[title/<[Title]>|color/<[Color]>|footer/<[Footer]>]>]>
        - define Data "<map[username/<[Server]> Server|avatar_url/https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
        - define Hook <[Hook]>
        - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
      - default:
        #$ This should be a transcribed embedded message
        - ~bungeetag server:<[Server]> <server.scripts.size> save:ScriptCount
        - bungee <[Server]>:
          - reload
        - define ScriptCount <entry[ScriptCount].result||invalid>
        - if <[ScriptCount]> == invalid:
          - define color Red
          - define Title "Script Reload Pushed"
          - define Footer "<map.with[text].as[Scripts: ~ (No Error Response)]>"
        - else:
          - define color Yellow
          - define Title "Script Reload Pushed (No Response)"
          - define Footer "<map.with[text].as[Scripts: <entry[ScriptCount].result> (No Error Response)]>"
        - inject Embedded_Color_Formatting
        - define Embeds <list[<map[title/<[Title]>|color/<[Color]>|footer/<[Footer]>]>]>
        - define Data "<map.with[username].as[<[Server].to_titlecase> Server].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
        - define Hook <[Hook]>
        - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>


# % ██ [ Relay Induced Reload Task           ] ██
Reload_Task:
  type: task
  definitions: Hook
  script:
    - flag server ReloadHook:<[Hook]> duration:1s
    - reload

Reload_Error_Detection:
  type: world
  events:
    on reload scripts:
    # % ██ [ Verify Relay Induced Reload   ] ██
      - if <server.has_flag[ReloadHook]>:
        - if !<context.had_error>:
          - define Color Code
          - define title "Scripts Reloaded"
        - else:
          - define color Red
          - define title "Scripts Reloaded (With Errors)"
        - define ScriptCount <server.scripts.size>
        # % ██ [ Respond to Relay        ] ██
        - bungeerun Relay Reload_Response def:<[Color]>|<[Title]>|<bungee.server>|<[ScriptCount]>|<server.flag[ReloadHook]>

Reload_Response:
  type: task
  definitions: Color|Title|Server|ScriptCount|Hook
  script:
    # % ██ [ Inject Dependencies           ] ██
    - inject Embedded_Color_Formatting

    - define Footer <map.with[text].as[Scripts:<&sp><[ScriptCount]>]>
    - define Embeds <list[<map[title/<[Title]>|color/<[Color]>|footer/<[Footer]>]>]>
    - define Data "<map[username/<[Server]> Server|avatar_url/https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
    - define Hook <[Hook]>
    - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
