Time_Command:
    type: command
    name: time
    debug: false
    description: Changes the time of day.
    usage: /time <&lt>Time of Day<&gt>/<&lt>0-23999<&gt>
    permission: behrry.essentials.time
    aliases:
        - nick
    tab complete:
        - define time <list[Start|Day|Noon|Sunset|Bedtime|Dusk|Night|Midnight|Sunrise|Dawn]>
        - if <context.args.size||0> == 0:
            - determine <[Time]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <[Time].filter[starts_with[<context.args.get[1]>]]>
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly

    # @ ██ [  Check if Arg is a number ] ██
        - if <context.args.get[1].is_integer>:
            - define Int <context.args.get[1]>
        # @ ██ [  Check if number is a valid number for usage ] ██
            - if <[Int]> < 0:
                - narrate "<proc[Colorize].context[Time cannot be negative.|red]>"
                - stop
            - if <[Int]> >= 24000:
                - narrate "<proc[Colorize].context[Time cannot exceed 23999.|red]>"
                - stop
            - if <[Int].contains[.]>:
                - narrate "<proc[Colorize].context[Time cannot contain decimals.|red]>"
                - stop
            - time <[Int]>t
            - define Name <&e><[Int]>
            - narrate "<proc[Colorize].context[Time set to:|green]> <&e><[Int]>"
    # @ ██ [  Match time with time of day by name ] ██
        - else:
            - define Arg <context.args.get[1]>
            - choose <[Arg]>:
                - case Start:
                    - time 0
                    - define Name "<&e>Start"
                - case Day:
                    - time 1000t
                    - define Name "<&e>Day"
                - case Noon:
                    - time 6000t
                    - define Name "<&e>Noon"
                - case Sunset:
                    - time 11615t
                    - define Name "<&e>Sunset"
                - case Bedtime:
                    - time 12542t
                    - define Name "<&e>Bedtime"
                - case Dusk:
                    - time 12786t
                    - define Name "<&e>Dusk"
                - case Night:
                    - time 13000t
                    - define Name "<&e>Night"
                - case Midnight:
                    - time 18000t
                    - define Name "<&e>Midnight"
                - case Sunrise:
                    - time 22200t
                    - define Name "<&e>Sunrise"
                - case Dawn:
                    - time 23216t
                    - define Name "<&e>Dawn"
                - default:
                    - inject Command_Syntax Instantly
            - narrate "<proc[Colorize].context[Time set to:|green]> <[Name]>"
            
