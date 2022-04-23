tag_command_create:
  type: task
  debug: true
  script:
    - definemap options:
        1:
          type: string
          name: tag
          description: Parses a tag
          required: true
        2:
          type: string
          name: server
          description: Selects the server to parse the tag for
          required: false

    - ~discordcommand id:a_bot create options:<[options]> name:t "Description:Parse a tag for a server or in general" group:626078288556851230
    - ~discordcommand id:a_bot create options:<[options]> name:tag "Description:Parse a tag for a server or in general" group:626078288556851230
    - ~discordcommand id:a_bot create options:<[options]> name:parse "Description:Parse a tag for a server or in general" group:626078288556851230

tag_command_handler:
  type: world
  debug: false
  events:
    on discord slash command name:tag|parse|t:
  # % ██ [ create base definitions               ] ██
      - define tag <context.options.get[tag].escaped>
      - define embed <discord_embed>

  # % ██ [ verify server argument, if any        ] ██
      - if <context.options.contains[server]>:
        - define server <context.options.get[server]>
      - else:
        - define server relay

  # % ██ [ verify server is bungee configurated  ] ██
      - if !<yaml[bungee_config].contains[servers.<[server].to_titlecase>]>:
        - definemap embed_data:
            color: 200,0,0
            description: <&co>warning<&co> Tried parsing for server <&dq>`<[server].to_titlecase>`<&dq><n>Server is not configured in the network's server listings.
            footer: Attempted<&co> <[tag].unescaped>
        - ~discordinteraction reply interaction:<context.interaction> <[embed].with_map[<[embed_data]>]>
        - stop

  # % ██ [ verify server is connected            ] ██
      - if !<bungee.list_servers.contains[<[server]>]>:
        - definemap embed_data:
            color: 200,0,0
            description: <&co>warning<&co> Server<&co> <&dq>`<[server].to_titlecase>`<&dq> is Offline.
            footer: Attempted<&co> <[tag].unescaped>
        - ~discordinteraction reply interaction:<context.interaction> <[embed].with_map[<[embed_data]>]>
        - stop

  # % ██ [ create base embed                     ] ██
      - definemap embed_data:
          color: 0,254,255
          footer: Parsed on<&co> <[server].to_titlecase> for<&co> <[tag].unescaped>
      - define embed <[embed].with_map[<[embed_data]>]>



  # % ██ [ Parse Tags                            ] ██
      - ~bungeetag server:<[server]> <[tag].unescaped.parsed> save:response
      - define tag_response <entry[response].result.escaped>

      - ~discordinteraction reply interaction:<context.interaction> <[embed].with[description].as[<[tag_response].unescaped>]>


# $ ██ [ Run on Relay ] ██
Tag_ParseFrom:
  type: task
  debug: false
  definitions: Server|Tag
  script:
    - flag server TagUnparsed:<[Tag].escaped> duration:1s
    - bungeerun <[server].to_titlecase> Tag_Parse def:<[Tag].escaped>

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
    - define Footer "<map.with[text].as[Parsed on: <[server].to_titlecase> for: <[tag]>]>"
    - define Embeds <list[<map.with[color].as[<[Color]>].with[footer].as[<[Footer]>].with[description].as[<[TagData].unescaped>]>]>
    - define Data "<map.with[username].as[Tag Parser Results].with[avatar_url].as[https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>"

    - ~run discord_get_or_create_webhook def:<[channel]> save:webhook
    - define Hook <entry[webhook].created_queue.determination.get[1]>
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
