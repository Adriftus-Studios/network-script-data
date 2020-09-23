Time_Command:
    type: command
    name: time
    debug: false
    description: Changes the time of day.
    usage: /time <&lt>Time of Day<&gt>/<&lt>0-23999<&gt>
    permission: Behr.Essentials.time
    aliases:
        - nick
    tab complete:
        - define Args <list[Start|Day|Noon|Sunset|Bedtime|Dusk|Night|Midnight|Sunrise|Dawn]>
        - inject OneArg_Command_Tabcomplete
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.is_empty>:
            - inject Command_Syntax

    # % ██ [ Check if Arg is a number ] ██
        - if <context.args.first.is_integer>:
            - define Int <context.args.first>

        # % ██ [ Check if number is a valid number for usage ] ██
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

    # % ██ [ Match time with time of day by name ] ██
        - else:
            - define Arg <context.args.first>
            - choose <[Arg]>:
                - case Start:
                    - time 0
                    - define Name <&e>Start
                - case Day:
                    - time 1000t
                    - define Name <&e>Day
                - case Noon:
                    - time 6000t
                    - define Name <&e>Noon
                - case Sunset:
                    - time 11615t
                    - define Name <&e>Sunset
                - case Bedtime:
                    - time 12542t
                    - define Name <&e>Bedtime
                - case Dusk:
                    - time 12786t
                    - define Name <&e>Dusk
                - case Night:
                    - time 13000t
                    - define Name <&e>Night
                - case Midnight:
                    - time 18000t
                    - define Name <&e>Midnight
                - case Sunrise:
                    - time 22200t
                    - define Name <&e>Sunrise
                - case Dawn:
                    - time 23216t
                    - define Name <&e>Dawn
                - default:
                    - inject Command_Syntax
            - narrate "<proc[Colorize].context[Time set to:|green]> <[Name]>"
