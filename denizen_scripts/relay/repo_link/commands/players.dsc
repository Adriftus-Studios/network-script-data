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
      - ~discordinteraction defer interaction:<context.interaction>
      - define embed <discord_embed.with[color].as[<color[0,254,255]>]>
      - define players <list>

      - if <context.options.is_empty.if_null[true]>:
        - define servers <bungee.list_servers>
      - else:
        - define servers <context.options>
      - foreach <[servers]> as:server:
        - ~bungeetag server:<[server]> <server.online_players.parse[name]> save:request
        - define players <entry[request].result>
        - if <[players].is_empty>:
          - foreach next
        - define embed "<[embed].add_inline_field[**<[server].to_titlecase>** `(<[players].size>)`].value[```md<n>- <[players].separated_by[<n>- ]>```]>"

      - if <[players].is_empty>:
        - define embed "<[embed].with[description].as[No players online.]>"

      - ~discordinteraction reply interaction:<context.interaction> <[embed]>
