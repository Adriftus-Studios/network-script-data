Bungee_DCommand:
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
    debug: false
    script:
    # % ██ [ Clean Definitions & Inject Dependencies ] ██
        - define Message <[Message].unescaped>
        - inject Role_Verification
        - inject Command_Arg_Registry
        
    # % ██ [ Verify Arguments                        ] ██
        - if <[Args].is_empty>:
            - stop
        - define server <[Args].first>
        - if !<bungee.list_servers.contains[<[Server]>]>:
            - define Reason "Invalid Server"
            - discord id:AdriftusBot message channel:<[Channel]> <[Reason]>
            - stop
            
        - run discord_bungeeCommand_execute def:<[Message].after[<&sp>].before[<&sp>]>|<[Message].after[<&sp>].after[<&sp>].replace[<&sp>].with[<&ns>]>|<[Channel]>

discord_bungeeCommand_execute:
  type: task
  debug: false
  definitions: server|element|channel
  script:
    - foreach <[element].split[;]>:
      - define line<[loop_index]> <[value].replace[<&ns>].with[<&sp>]>
    - define command <element[]>
    - repeat 9999:
      - if <[line<[value]>]||invalid> == invalid:
        - repeat stop
      - define command "<[command]>- <[line<[value]>]><n>"
    - if <[Server]> == all:
      - foreach <bungee.list_servers.exclude[<bungee.server>]> as:Server:
        - execute as_server "ex bungee <[server]> { <[command]> }"
        - define ServersRan:->:<[Server]>
      - discord id:AdriftusBot message channel:<[channel]> "Executed Commands on <[ServersRan].comma_separated>:<n>```ini<n><[Command].split[<n>].separated_by[<n>]>```"
    - else if !<bungee.list_servers.contains[<[Server]>]>:
      - discord id:AdriftusBot message channel:<[channel]> "<&lt>a:weewoo:619323397880676363<&gt> **Invalid Server**: `<[server]>` <&lt>a:weewoob:724672346807599282<&gt>"
      - stop
    - else:
      - execute as_server "ex bungee <[server]> { <[command]> }"
    #^- discord id:AdriftusBot message channel:<[channel]> "Executed Commands on <[server]>:<n>```ini<n><[Command].split[<n>].separated_by[<n>]>```"

      
    - define color Code
    - inject Embedded_Color_Formatting
    - define Text "Executed Commands on <[server]>:<n>```ini<n><[Command].split[<n>].separated_by[<n>]>```"
    - define Embeds <list[<map[color/<[Color]>].with[description].as[<[Text]>]>]>
    - define Data <map[username/<[Server]><&sp>Server|avatar_url/https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>

    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
