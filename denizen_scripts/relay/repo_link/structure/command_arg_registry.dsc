command_arg_registry:
  type: task
  debug: false
  definitions: message|command_alias
  script:
    - if <[message].object_type> == DiscordMessage:
      - define message_object <[message]>
      - define message <[message].text>

    # % ██ [ Equivalent of <context.command> | Returns the command name as an ElementTag. ] ██
    - if <[command_alias]||invalid> == invalid:
      - define command "<[message].before[ ]>"
    - else:
      - define command <[command_alias]>

    # % ██ [ Equivalent of <context.args>   | Returns a ListTag of the arguments.     ] ██
    - if <[message].split_args.is_empty>:
      - define args <list>
    - else:
      - define args <[message].split_args.remove[first]>

    # % ██ [ Equivalent of <context.raw_args> | Returns any args used as an ElementTag.   ] ██
    - if !<[args].is_empty>:
      - define raw_args "<[message].after[ ]>"

    # % ██ [ Unique return - <[args].first>   | Returns the first argument.         ] ██
      - define first_arg <[args].first>

    # % ██ [ Unique return - <[flag_args]>  | Returns a ListTag of flag arguments.    ] ██
      - define flag_args <[args].filter[starts_with[-]].include[<[args].filter[starts_with[--]]>]>

    # % ██ [ Unique return - <[args].last>   | Returns the last argument.         ] ██
      - define last_arg <[args].last>

#$ Example command:
#- /repo gielinor one two
#| <[command]> == /repo
#| <[args]> == li@el@gielinor|el@one|el@two
#| <[raw_args]> == `gielinor one two`
#| <[first_arg]> == gielinor
#| <[last_arg]> == two
