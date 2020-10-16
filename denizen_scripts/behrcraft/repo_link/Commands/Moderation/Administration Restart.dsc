Restart_Command:
    type: command
    name: restart
    debug: false
    description: Restarts the server
    usage: /restart <&lt>Instant/Queue/Skip/Set<&gt> (Time (Speed))
    permission: behrry.moderation.restart
    tab complete:
        - define Args <list[Instant|Queue|Skip|Set]>
        - inject OneArg_Command_Tabcomplete Instantly
    script:
    # % ██ [ Check for args ] ██
        - if <context.args.is_empty>:
            - if <context.source_type> == server:
                - inject Server_Restart_Task path:Restart Instantly
                - stop
            - inject Command_Syntax Instantly

    # % ██ [ Check if Console Ran ] ██
        - if <context.source_type> == server:
            - if <context.args.first||null> != instant:
                - announce to_console format:Colorize_Red "Can only be instant from Console."
                - stop

    # % ██ [ Run sub-command ] ██
        - choose <context.args.first>:
            - case Queue:
            # % ██ [ Check args ] ██
                - if <context.args.get[2]||null> == null:
                    - define Time <duration[300s]>
                    - define Speed 20

                - else:
                # % ██ [ Check for speed ] ██
                    - if <context.args.get[3]||null> == null:
                        - define Speed 20

                # % ██ [ Check speed format & values ] ██
                    - else:
                        - define Speed <context.args.get[3]>
                        - if !<[Speed].is_integer>:
                            - narrate format:Colorize_Red "Speed must be a valid number."
                            - stop
                        - if <[Speed].contains[.]>:
                            - narrate format:Colorize_Red "Speed cannot contain decimals."
                            - stop
                        - if <[Speed]> < 0:
                            - narrate format:Colorize_Red "Time cannot be negative."
                            - stop
                        - if <[Speed]> > 100:
                            - narrate format:Colorize_Red "Time cannot exceed 100 ticks."
                            - stop

                # % ██ [ Check time format ] ██
                    - if <context.args.first.contains[.]>:
                        - narrate format:Colorize_Red "Time cannot contain decimals."
                        - stop
                    - define Time <duration[<context.args.get[2]>]||invalid>
                    - if <[Time]> == invalid:
                        - narrate format:Colorize_Red "Invalid time format."
                        - stop

                # % ██ [ Check time values ] ██
                    - if <[Time].in_seconds> < 0:
                        - narrate format:Colorize_Red "Time cannot be negative."
                        - stop
                    - if <[Time].in_seconds> >= 1200:
                        - narrate format:Colorize_Red "Time cannot exceed 10 minutes."
                        - stop
                    
                - run Server_Restart_Task def:<[Time]>|<[Speed]>

        # % ██ [ Skip the next restart ] ██
            - case Skip:
                - if <context.args.get[2]||null> != null:
                    - inject Command_Syntax Instantly
                - flag server behrry.essentials.restartskip
            
        # % ██ [ Instantly restart the server ] ██
            - case Instant:
                - if <context.args.get[2]||null> != null:
                    - inject Command_Syntax Instantly
                - inject Server_Restart_Task path:Restart Instantly
            
        # % ██ [ Invalid sub-command ] ██
            - case default:
                - inject Command_Syntax Instantly
