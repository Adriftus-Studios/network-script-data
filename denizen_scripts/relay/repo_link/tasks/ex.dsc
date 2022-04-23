##IgnoreWarning bad_execute
ex_command_create:
  type: task
  debug: true
  script:
    - definemap options:
        1:
          type: string
          name: command
          description: Executes an /ex command
          required: true
        2:
          type: string
          name: server
          description: Selects the server to execute the command for
          required: false

    - ~discordcommand id:a_bot create options:<[options]> name:ex "Description:Executes an /ex command for a server" group:626078288556851230

ex_command_handler:
  type: world
  debug: false
  events:
    on discord slash command name:ex:
    # % ██ [ create base definitions               ] ██
      - define command <context.options.get[command].escaped>
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
            description: <&co>warning<&co> Tried executing command for server <&dq>`<[server].to_titlecase>`<&dq><n>Server is not configured in the network's server listings.
            footer: Attempted<&co> /ex <[command].unescaped>
        - ~discordinteraction reply interaction:<context.interaction> <[embed].with_map[<[embed_data]>]>
        - stop

    # % ██ [ verify server is connected            ] ██
      - if !<bungee.list_servers.contains[<[server]>]>:
        - definemap embed_data:
            color: 200,0,0
            description: <&co>warning<&co> Server<&co> <&dq>`<[server].to_titlecase>`<&dq> is Offline.
            footer: Attempted<&co> /ex <[command].unescaped>
        - ~discordinteraction reply interaction:<context.interaction> <[embed].with_map[<[embed_data]>]>
        - stop

    # % ██ [ create base embed                     ] ██
      - definemap embed_data:
          color: 0,254,255
          footer: Executed on<&co> <[server].to_titlecase>
      - define embed <[embed].with_map[<[embed_data]>]>

    # % ██ [ execute command                       ] ██
      - if <context.options.contains[server]>:
        - bungee <[server]>:
          - execute as_server "ex <[Command].unescaped>"
      - else:
        - execute as_server "ex <[Command].unescaped>"

    # % ██ [ Parse Tags                            ] ██
      - define embed "<[embed].with[description].as[<&lt>a:checc:901758512420503572<&gt> Executed command: `/ex <[command].unescaped.replace[`].with[']>`]>"
      - ~discordinteraction reply interaction:<context.interaction> <[embed]>
