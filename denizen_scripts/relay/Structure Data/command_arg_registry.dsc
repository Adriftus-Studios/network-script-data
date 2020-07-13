Command_Arg_Registry:
    type: task
    debug: false
    definitions: Message
    speed: 0
    script:
        - define Args <[Message].split_args.remove[first]>