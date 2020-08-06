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
  speed: 0
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
        - inject Embedded_Error_Response
      - else:
        - define Server <[Args].first>
    - run Reload_Scripts_Queue def:<list[<[Channel]>].include[<map.with[Color].as[Code].with[Server].as[<[Server]>]>]>

Reload_Scripts_Queue:
  type: task
  version: 1.2
  definitions: Channel|Definitions
  speed: 0
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
        - define Data "<map[username/<[Server]> Server|avatar_url/https://img.icons8.com/nolan/64/source-code.png].with[embeds].as[<[Embeds]>].to_json>"
        - define Hook <[Hook]>
        - define headers <list[User-Agent/really|Content-Type/application/json]>
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
        - define Data "<map[username/<[Server]> Server|avatar_url/https://img.icons8.com/nolan/64/source-code.png].with[embeds].as[<[Embeds]>].to_json>"
        - define Hook <[Hook]>
        - define headers <list[User-Agent/really|Content-Type/application/json]>
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
    - define Data "<map[username/<[Server]> Server|avatar_url/https://img.icons8.com/nolan/64/source-code.png].with[embeds].as[<[Embeds]>].to_json>"
    - define Hook <[Hook]>
    - define headers <list[User-Agent/really|Content-Type/application/json]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
