players_command_create:
  type: task
  debug: false
  script:
    - definemap options:
        1:
          type: string
          name: server
          description: Specifies a server to check for players
          required: false

    - ~discordcommand id:a_bot create options:<[options]> name:players "Description:Shows the players on the network or server" group:626078288556851230

players_command_handler:
  type: world
  debug: true
  events:
    on discord slash command name:players:
      - define embed <discord_embed.with[color].as[<color[0,254,255]>]>
      - define description <list>

      - if !<context.options.is_empty>:
        - ~bungeetag server:<context.options.first> <server.online_players.parse[name]> save:request
        - define players <entry[request].result>
        - define embed "<[embed].with[description].as[**<context.options.get[server]>**<n>`(<[players].size>)`<n>```md<n>- <[players].separated_by[<n>- ]>```]>"

      - else:
        - define players <map>
        - foreach <bungee.list_servers> as:server:
          - ~bungeetag server:<[server]> <server.online_players.parse[name]> save:request
          - define players <entry[request].result>
          - if <[players].is_empty>:
            - foreach next
          - define players <[players].with[<[server]>].as[<[players]>]>
          - define embed "<[embed].add_inline_field[**<[server]>**<n>`(<[players].size>)`].value[```md<n>- <[players].separated_by[<n>- ]>```]>"
        - if <[players].is_empty>:
          - define embed "<[embed].with[description].as[No players online.]>"

      - ~discordinteraction reply interaction:<context.interaction> <[embed]>
