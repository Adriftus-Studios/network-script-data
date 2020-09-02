command_arg_registry:
    type: task
    debug: false
    definitions: message
    script:
        # % ██ [ Equivalent of <context.command> | Returns the command name as an ElementTag. ] ██
        - define command "<[message].before[ ]>"

        # % ██ [ Equivalent of <context.args>     | Returns a ListTag of the arguments.       ] ██
        - if <[message].split_args.is_empty>:
            - define args <list>
        - else:
            - define args <[message].split_args.remove[first]>

        # % ██ [ Equivalent of <context.raw_args> | Returns any args used as an ElementTag.   ] ██

            - define raw_args "<[message].after[ ]>"
        # % ██ [ Unique return - <[args].first>   | Returns the first argument.               ] ██
            - define first_arg <[args].first>

        # % ██ [ Unique return - <[flag_args]>    | Returns a ListTag of flag arguments.      ] ██
            - define flag_args <[args].filter[starts_with[-]]>

        # % ██ [ Unique return - <[map_args]>    | Returns a ListTag of mapped arguments.     ] ██
            - define flag_args <[args].filter[contains[:]].split[:].limit[2].parse_tag[<map.with[<[parse_value].before[:]>/<[parse_value].after[:]>]>].merge_maps||invalid>
