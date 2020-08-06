# --- USAGE ---
# flag the player with text_input
# the value should be <ScriptNameToRun>/<AnyDataNeededByScript>
# The script being run will get <context.message> passed in as the first definition
# --- WARNING ---
# using /cancel will forcibly end text input, and you cannot rely on players completing the process
# While they are in text input mode, they cannot move, or look
# There is a message to alert them to this, if they try to.

text_input_handler:
  type: world
  events:
    on player chats flagged:text_input bukkit_priority:LOWEST priority:-1000:
      - determine passively cancelled
      - if <context.message> == /cancel:
        - stop
      - if !<context.message.matches_character_set[1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz<&sp>;&!_<&sq><&dq>]>:
        - narrate "<&c>Invalid characters were specified, only numbers and letters may be used..."
        - stop
      - run <player.flag[text_input].before[/]> def:<context.message>|<player.flag[text_input].after[/]>
    on player walks flagged:text_input:
      - narrate "<&c>You are entering text, use <&b>/cancel<&c> to end this, or click <&a><element[here].on_click[/cancel]><&c>."
      - determine cancelled

text_input_cancel:
  type: command
  name: cancel
  description: Cancels the current text input.
  usage: /cancel
  script:
    - if <player.has_flag[text_input]>:
      - narrate "<&e>Text entry mode has been cancelled without saving changes."
      - inject text_input_complete
    - else:
      - narrate "<&c>You are not in text entry mode."

text_input_complete:
  type: task
  script:
    - if <player.has_flag[text_input]>:
      - flag player text_input:!
