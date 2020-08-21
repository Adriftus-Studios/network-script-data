Tag_Parser_DCommand:
  type: task
  PermissionRoles:
  # % ██ [ Staff Roles  ] ██
    - Lead Developer
    - External Developer
    - Developer

  # % ██ [ Public Roles ] ██
    - Lead Developer
    - Developer
  definitions: Message|Channel|Author|Group|Direct
  debug: false
  Context: Color
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject Role_Verification
    - inject Command_Arg_Registry

  # % ██ [ Verify Blacklists           ] ██
    - if <server.has_flag[Discord.Blacklist]> && <server.flag[Discord.Blacklist].contains[<[Author]>]>:
      - if <server.has_flag[Discord.Ratelimit]>:
        - define User_Ratelimit_Cache <server.flag[Discord.Ratelimit].filter[get[Discord_User].contains[<[Author]>]]>
        - if !<[User_Ratelimit_Cache].is_empty>:
          - if <[User_Ratelimit_Cache].first.get[Timeout].duration_since[<util.time_now>].in_seconds> != 0:
            - stop
          - flag server Discord.Ratelimit:<-:<[User_Ratelimit_Cache]>
      - flag server Discord.Ratelimit:->:<map.with[Discord_User].as[<[Author]>].with[Timeout].as[<util.time_now.add[5m]>]>
      - discord id:AdriftusBot message user:<[Author]> "You are blacklisted from this command for unethical tag parsing."
      - stop

  # % ██ [ Verify Arguments            ] ██
    - if <[Args].is_empty>:
      - stop
    - else if <[Args].size> == 1:
      - define Server Relay
      - define Tag <[Args].first>
    - else:
      - if <yaml[bungee.config].contains[servers.<[Args].first>]>:
        - if !<bungee.list_servers.contains[<[Args].first>]>:
          - define color red
          - inject Embedded_Color_Formatting
          - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
          - define Embeds "<list[<map[description/<[Args].first> is **Not Connected** or is **OFFLINE**.|color/<[Color]>]>]>"
          - define Data "<map[username/Server Status Warning|avatar_url/https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>"
          - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
          - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
          - stop
        - else:
          - narrate <[Args]>
          - define Server <[Args].first>
          - define Tag <[Args].remove[1].space_separated>
      - else:
        - narrate <[Args]>
        - define Server Relay
        - define Tag <[Args].space_separated>
  # % ██ [ Parse Tags                ] ██
    - ~bungeetag server:<[server]> <[tag].parsed> save:result
    - define TagData <entry[result].result.escaped>

  # % ██ [ Send Direct Message       ] ██
    - if <[Direct]>:
      - if <[Author].id> == 194619362223718400:
        - discord id:AdriftusBot message user:<[Author]> "```ini<n># Parsed on: <[Server]> for: <[tag]>:<n> <[TagData].unescaped><n>```"
        - stop
      - else:
        - announce to_console "<&7># <&8>Parsed on: <&6><[Server]><&8> for<&7>: <&6><[tag]> <&8>From user<&8>: <&6><[Author].name> <&e>(<&6><[Author].id><&e>)<&7>"
        #| Potentially add when restricting Logs: <n> <&3><[TagData].unescaped>
        - if <[TagData].unescaped.contains_any_text[<list_single[<yaml[AdriftusBot_temp].read[AdriftusBotToken]>].include_single[<yaml[oAuth].list_deep_keys[].parse_tag[<yaml[oAuth].parsed_key[<[Parse_Value]>]>]>].exclude[Headers|User-Agent|redirect_uri|code|state|discord|application|client|token|parameters|scope|grand|hATE_Webhook|ATE|name|config|GitHub|Twitch|Repository|Repositories]>]>:
          - discord id:AdriftusBot message user:<[Author]> "You have been blacklisted from this command for unethical tag parsing. This incident will be reported."
          - flag server Discord.Blacklist:->:<[Author]>
          - Define Warning "<&lt>a:weewoo:619323397880676363<&gt> Attention:<discorduser[adriftusbot,194619362223718400].mention> **Warning**:<n>"
        - else:
          - define Warning <empty>
        - discord id:AdriftusBot message channel:746416381112877147 "<[Warning]>```ini<n># Parsed on: <[Server]> From user: <[Author].name> (<[Author].id>) for:<n> <[tag]><n>```"
        #| Potentially add when restricting Channel: :<n><[TagData].unescaped><n>

  # % ██ [ Send Public Message       ] ██
    - else:
      - define color Code
      - inject Embedded_Color_Formatting
      - define Footer "<map.with[text].as[Parsed on: <[Server]> for: <[tag]>]>"
      - define Embeds <list[<map[color/<[Color]>].with[footer].as[<[Footer]>].with[description].as[<[TagData].unescaped>]>]>
      - define Data "<map[username/Tag Parser Results|avatar_url/https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>"

      - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
      - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
      - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>

# $ ██ [ Run on Relay ] ██
Tag_ParseFrom:
  type: task
  debug: false
  definitions: Server|Tag
  script:
    - flag server TagUnparsed:<[Tag].escaped> duration:1s
    - bungeerun <[Server]> Tag_Parse def:<[Tag].escaped>


# $ ██ [ Run on Server induced by Relay ] ██
Tag_Parse:
  type: task
  debug: false
  definitions: Tag
  script:
    - define TagData <[Tag].unescaped.parsed>
    - if <server.has_flag[TagError]>:
      - bungeerun Relay Tag_Receive def:<list_single[<[TagData]>].include[<server.flag[TagError]>]>
    - else:
      - bungeerun Relay Tag_Receive def:<list_single[<[TagData]>]>


# $ ██ [ Run on Relay induced by Server ] ██
Tag_Receive:
  type: task
  debug: false
  definitions: TagData|TagError
  script:
  # % ██ [                     ] ██
    - if <[TagError]||null> != null:
      - define Color Red
    - else:
      - define Color Code
    - define TagUnparsed:<server.flag[TagUnparsed]>


  # % ██ [ Send Embedded Message           ] ██
    - define color Code
    - inject Embedded_Color_Formatting
    - define Footer "<map.with[text].as[Parsed on: <[Server]> for: <[tag]>]>"
    - define Embeds <list[<map[color/<[Color]>].with[footer].as[<[Footer]>].with[description].as[<[TagData].unescaped>]>]>
    - define Data "<map[username/Tag Parser Results|avatar_url/https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>"

    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>

Tag_Parse_Listener:
  type: world
  debug: false
  events:
    on script generates error:
      - announce to_console "Script Generates Error-------------------------------------------------"
      - if <context.queue.id.contains[Tag_Parse]||false>:
        - determine passively cancelled
        - announce to_console "<&4>Error:<&c> <context.message>"
        - announce to_console "<&4>Error:<&c> <context.queue>"
        - announce to_console "<&4>Error:<&c> <context.script>"
        - announce to_console "<&4>Error:<&c> <context.line>"
    on server generates exception:
      - announce to_console "Server Generates exception-------------------------------------------------"
      - if <context.queue.id.contains[Tag_Parse]||false>:
        - determine passively cancelled
        - announce to_console "<&4>Error:<&c> <context.message>"
        - announce to_console "<&4>Error:<&c> <context.full_trace>"
        - announce to_console "<&4>Error:<&c> <context.type>"
        - announce to_console "<&4>Error:<&c> <context.queue>"
