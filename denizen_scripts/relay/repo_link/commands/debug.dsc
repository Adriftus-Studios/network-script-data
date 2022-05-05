debug_command_create:
  type: task
  debug: true
  script:
    - definemap options:
        1:
          type: string
          name: error_reporting
          description: Modifies error reporting configurations
          required: true

    - ~discordcommand id:a_bot create options:<[options]> name:debug "Description:Adjusts debugging configurations or executes debugging tools" group:626078288556851230

debug_command_handler:
  type: world
  debug: false
  events:
    on discord slash command name:debug:
    # % ██ [ create base definitions               ] ██
      - define embed <discord_embed.with[title].as[options<&co><context.options>]>

      - ~discordinteraction reply interaction:<context.interaction> <[embed]>
