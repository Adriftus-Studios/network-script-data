release_stage_command:
  type: command
  debug: false
  name: release_stage
  description: Set the release stage of the server.
  usage: /release_stage [alpha|beta|release]
  permission: adriftus.admin
  tab complete:
    - define args <list[alpha|beta|release]>
    - inject onearg_command_tabcomplete
  script:
    - if <context.args.is_empty>:
      - narrate <server.flag[release_stage].to_titlecase||Release>
    - else if <context.args.get[1]> == alpha:
      - flag server release_stage:alpha
      - narrate "<&a>Set the server release stage to Alpha."
    - else if <context.args.get[1]> == beta:
      - flag server release_stage:beta
      - narrate "<&b>Set the server release stage to Beta."
    - else if <context.args.get[1]> == release:
      - flag server release_stage:release
      - narrate "<&e>Set the server release stage to Release."
    - else:
      - narrate "<&c>Invalid release mode entered."

release_stage_join_event:
  type: world
  debug: false
  events:
    after player joins:
      - flag <player> <server.flag[release_stage]||release>
