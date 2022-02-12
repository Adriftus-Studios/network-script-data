
command_debugmode:
  type: command
  debug: false
  name: debugmode
  script:
  - if !<player.has_permission[debugmode]>:
    - narrate "<&c>You do not have permission for this command."
    - stop
  - if <player.has_flag[debugmode]>:
    - flag <player> debugmode:!
    - narrate "<&9>You have left <&l>DebugMode."
  - else:
    - flag <player> debugmode
    - narrate "<&9>You have entered <&l>DebugMode."

error_handler_events:
  type: world
  debug: false
  events:
    on plugin generates exception:
    - define msg "<context.full_trace.replace[\n].with[<&nl>].strip_color.replace[<&lb>Error Continued<&rb>]>"
    - ratelimit 1t <[msg]>
    - announce to_flagged:debugmode "<&c>An exception has been thrown... <&l><&click[<[msg]>].type[COPY_TO_CLIPBOARD]><&hover[<[msg]>].type[SHOW_TEXT]><&lb>Click to copy!<&rb><&end_hover><&end_click>"
    on script generates error:
    - if <context.script.filename.ends_with[staffmode.dsc]>:
      - stop
    - if !<context.script.exists>:
      - stop
    - if <context.script> == <script>:
      - stop
    - if "<context.message.starts_with[Several text tags like '&dot' or '&cm' are pointless]>":
      - determine cancelled
    - if <context.message.ends_with[is<&sp>invalid!]> && <context.message.starts_with[Tag<&sp><&lt>inventory<&lb>]> && !<player.has_flag[debugmode]>:
      - wait 1t
      - inventory close
    - if <context.script||null> != null && <context.line||null> != null:
      - if <player.if_null[null]> != null:
        - define "cause:<player.name.as_element.on_hover[Click to teleport].on_click[/ex -q teleport <player.location||null>]||None>"
      - else:
        - define cause:None
      - flag server debug.errors.<context.queue.id>.stacktrace.<context.line>.message:<context.message>
      - ratelimit <context.queue> 1h
      - waituntil <context.queue.state> == stopping
      - foreach <server.flag[debug.errors.<context.queue.id>.stacktrace].keys> as:t:
        - define message <server.flag[debug.errors.<context.queue.id>.stacktrace.<[t]>.message]>
        - define "stacktrace:|:<&c><context.script.filename.split[plugins/Denizen/scripts/].get[2]><&co><&l><[t]> <&r><[message]>"
      - foreach <context.queue.definitions.deduplicate> as:definition:
        - define data <context.queue.definition[<[definition]>]>
        - if <[data].parsed.exists>:
          - define definitions:|:<proc[get_debug_info].context[<[data].escaped>|<[definition]>]>
      - announce to_console "<&c>|----------------------| <&4>Error<&c> |-----------------------|"
      - announce to_console " <&c>Filename: <context.script.filename.split[plugins/Denizen/scripts/].get[2]>"
      - announce to_console " <&c>Player: <[cause]>"
      - announce to_console " <[stacktrace].separated_by[<&nl> ]>"
      - announce to_console " <&c>Definitions: <&l><[definitions].separated_by[<&sp><&2>|<&sp><&c><&l>]||None>"

      - announce to_flagged:debugmode "<&c>|----------------------| <&4>Error<&c> |-----------------------|"
      - announce to_flagged:debugmode " <&c>Filename: <context.script.filename.split[plugins/Denizen/scripts/].get[2]>"
      - announce to_flagged:debugmode " <&c>Player: <[cause]>"
      - announce to_flagged:debugmode " <[stacktrace].separated_by[<&nl> ]>"
      - announce to_flagged:debugmode " <&c>Definitions: <&l><[definitions].separated_by[<&sp><&2>|<&sp><&c><&l>]||None>"
      - flag server debug.errors.<context.queue.id>:!

get_debug_info:
  type: procedure
  debug: false
  definitions: data|definition
  script:
  - define data <[data].unescaped>
  - define "info:Type: <[data].object_type||Unknown>"
  - define "info:|:Script: <[data].script.name||None>"
  - choose <[data].object_type>:
    - case item:
      - define "info:|:Click to obtain."
      - define "info:|:Material: <[data].material.name||Unknown>"
      - if <[data].has_display>:
        - define "info:|:Display Name: <[data].display>"
      - if <[data].has_lore>:
        - foreach <[data].lore> as:line:
          - define "info:|:Lore line <[loop_index]>: <[line]>"
      - determine "<&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><&click[/ex -q give<&sp><[data]>].type[RUN_COMMAND]><[definition]><&end_click><&end_hover>"
    - case location:
      - define "info:|:Click to teleport."
      - define "info:|:X=<[data].block.x>; Y=<[data].block.y>; Z=<[data].block.z>; World=<[data].world.name>"
      - define "info:|:Note: <[data].note_name||None>"
      - determine "<&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><&click[/ex -q teleport<&sp><[data]>].type[RUN_COMMAND]><[definition]><&end_click><&end_hover>"
    - case player:
      - define "info:|:Click to teleport."
      - define "info:|:Name: <[data].name>"
      - define "info:|:UUID: <[data].uuid>"
      - define "info:|:Health: <[data].health||Null>; Hunger: <[data].food_level||Null>"
      - if <[data].name.contains[<&ss>]>:
        - define "info:|:<&c>This players name contains hidden characters.<&r>"
      - determine "<&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><&click[/ex -q teleport<&sp><[data].location>].type[RUN_COMMAND]><[definition]><&end_click><&end_hover>"
    - case entity:
      - define "info:|:Click to teleport."
      - define "info:|:Entity Type: <[data].entity_type>"
      - define "info:|:UUID: <[data].uuid>"
      - define "info:|:Health: <[data].health>"
      - if <[data].name.contains[<&ss>]>:
        - define "info:|:<&c>This entitys name contains hidden characters.<&r>"
      - determine "<&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><&click[/ex -q teleport<&sp><[data].location>].type[RUN_COMMAND]><[definition]><&end_click><&end_hover>"
    - case list:
      - define "info:|:Click to copy to clipboard."
      - define "info:|:Size: <[data].size>"
      - foreach <[data]> as:v:
        - define i <[i].add[1]||1>
        - if <[i].is_more_than[50]>:
          - foreach stop
        - choose <[v].object_type>:
          - case player:
            - define "t:<[v].name> ( <[v].uuid> )"
          - case entity:
            - define "t:<player.target.script.name||<[v].entity_type>> ( <[v].uuid> )"
          - case item:
            - define t:<[v].script.name||<[v].material.name>>
          - case location:
            - define "t:<tern[<[v].note_name.is_truthy>].pass[Note=<[v].note_name>; ].fail[]>X=<[v].block.x>; Y=<[v].block.y>; Z=<[v].block.z>; World=<[v].world.name>"
          - default:
            - define t:<[v]>
        - define "info:|: - <[t]>"
      - determine <&click[<[data]>].type[COPY_TO_CLIPBOARD]><&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><[definition]><&end_hover><&end_click>
    - case map:
      - define "info:|:Click to copy to clipboard."
      - define "info:|:Size: <[data].size>"
      - foreach <[data].keys> as:k:
        - define i <[i].add[1]||1>
        - if <[i].is_more_than[50]>:
          - foreach stop
        - define v <[data].get[<[k]>]>
        - choose <[v].object_type>:
          - case player:
            - define "t:<[v].name> ( <[v].uuid> )"
          - case entity:
            - define "t:<player.target.script.name||<[v].entity_type>> ( <[v].uuid> )"
          - case item:
            - define t:<[v].script.name||<[v].material.name>>
          - case location:
            - define "t:<tern[<[v].note_name.is_truthy>].pass[Note=<[v].note_name>; ].fail[]>X=<[v].block.x>; Y=<[v].block.y>; Z=<[v].block.z>; World=<[v].world.name>"
          - default:
            - define t:<[v]>
        - define "info:|: <[k]> : <[t]>"
      - determine <&click[<[data]>].type[COPY_TO_CLIPBOARD]><&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><[definition]><&end_hover><&end_click>
    - default:
      - define "info:|:Click to copy to clipboard."
      - define "info:|:Value: <[data]>"
      - determine <&click[<[data]>].type[COPY_TO_CLIPBOARD]><&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><[definition]><&end_hover><&end_click>
