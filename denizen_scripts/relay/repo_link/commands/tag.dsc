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
