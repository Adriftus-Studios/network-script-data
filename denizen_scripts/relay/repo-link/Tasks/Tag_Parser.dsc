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
  definitions: Message|Channel|Author|Group
  debug: true
  Context: Color
  speed: 0
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject Role_Verification
    - inject Command_Arg_Registry

  # % ██ [ Verify Arguments            ] ██
    - if <[Args].is_empty>:
      - stop
    - else if <[Args].size> == 1:
      - define Server Relay
      - define Tag <[Args].first>
    - else:
      - if <yaml[bungee_config].list_keys[servers].contains[<[Args].first>]>:
        - if !<bungee.list_servers.contains[<[Args].first>]>:
          - define color red
          - inject Embedded_Color_Formatting
          - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
          - define Embeds "<list[<map[description/<[Args].first> is **Not Connected** or is **OFFLINE**.|color/<[Color]>]>]>"
          - define Data "<map[username/Server Status Warning|avatar_url/https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>"
          - define headers <list[User-Agent/really|Content-Type/application/json]>
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

  # % ██ [ Send Embedded Message           ] ██
    - define color Code
    - inject Embedded_Color_Formatting
    - define Footer "<map[].with[text].as[Parsed on: <[Server]> for: <[tag]>]>"
    - define Embeds <list[<map[color/<[Color]>].with[footer].as[<[Footer]>].with[description].as[<[TagData].unescaped>]>]>
    - define Data "<map[username/Tag Parser Results|avatar_url/https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>"

    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define headers <list[User-Agent/really|Content-Type/application/json]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>

# $ ██ [ Run on Relay ] ██
Tag_ParseFrom:
  type: task
  definitions: Server|Tag
  script:
    - flag server TagUnparsed:<[Tag].escaped> duration:1s
    - bungeerun <[Server]> Tag_Parse def:<[Tag].escaped>


# $ ██ [ Run on Server induced by Relay ] ██
Tag_Parse:
  type: task
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
  definitions: TagData|TagError
  script:
  # % ██ [                     ] ██
    - if <[TagError].exists>:
      - define Color Red
    - else:
      - define Color Code
    - define TagUnparsed:<server.flag[TagUnparsed]>


  # % ██ [ Send Embedded Message           ] ██
    - define color Code
    - inject Embedded_Color_Formatting
    - define Footer "<map[].with[text].as[Parsed on: <[Server]> for: <[tag]>]>"
    - define Embeds <list[<map[color/<[Color]>].with[footer].as[<[Footer]>].with[description].as[<[TagData].unescaped>]>]>
    - define Data "<map[username/Tag Parser Results|avatar_url/https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>"

    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define headers <list[User-Agent/really|Content-Type/application/json]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>

Tag_Parse_Listener:
  type: world
  debug: false
  events:
    on script generates error:
      - announce to_console "Script Generates Error-------------------------------------------------"
      - if <context.queue.id.contains[Tag_Parse]>:
        - determine passively cancelled
        - announce to_console "<&4>Error:<&c> <context.message>"
        - announce to_console "<&4>Error:<&c> <context.queue>"
        - announce to_console "<&4>Error:<&c> <context.script>"
        - announce to_console "<&4>Error:<&c> <context.line>"
    on script generates exception:
      - announce to_console "Script Generates exception-------------------------------------------------"
      - if <context.queue.id.contains[Tag_Parse]>:
        - determine passively cancelled
        - announce to_console "<&4>Error:<&c> <context.message>"
        - announce to_console "<&4>Error:<&c> <context.full_trace>"
        - announce to_console "<&4>Error:<&c> <context.type>"
        - announce to_console "<&4>Error:<&c> <context.queue>"