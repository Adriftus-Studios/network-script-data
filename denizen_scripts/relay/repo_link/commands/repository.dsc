repository_command_create:
  type: task
  debug: true
  script:
    - ~discordcommand id:a_bot create name:repository "description:Serves the link to a repository" group:626078288556851230

repository_command_handler:
  type: world
  debug: false
  events:
    on discord slash command name:repository:
      - definemap embed_data:
          color: <color[0,254,255]>
          description: "[`[https://github.com/A-Studio/network-script-data/]`](https://github.com/Adriftus-Studios/network-script-data/) | A network script data repository"

      - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed_data]>]>
