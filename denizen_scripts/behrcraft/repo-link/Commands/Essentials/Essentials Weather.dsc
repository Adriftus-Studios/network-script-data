Weather_Command:
    type: command
    name: weather
    debug: false
    description: Adjusts the weather.
    usage: /weather <&lt>Weather<&gt>
    permission: Behr.Essentials.Weather
    tab complete:
        - define Args <list[sunny|storm|thunder]>
        - inject OneArg_Command_Tabcomplete
    script:
        - if <context.args.is_empty> || <context.args.size> > 1:
            - inject command_syntax
        
        - if !<list[sunny|storm|thunder].contains[<context.args.first>]>:
            - inject command_syntax
        
        - weather <context.args.first> <player.world>
        - announce "<proc[colorize].context[Weather changed to|green]> <&e><context.args.first.to_titlecase>"
