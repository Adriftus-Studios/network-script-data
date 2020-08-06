Command_Arg_Registry:
    type: task
    debug: false
    definitions: Message
    script:
        - define Args <[Message].split_args.remove[first]>
