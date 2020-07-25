Weather_Command:
    type: command
    name: weather
    debug: false
    description: Adjusts the weather.
    usage: /weather <&lt>Weather<&gt>
    permission: Behr.Essentials.Weather
    tab complete:
        - define Arg1 <list[sunny|storm|thunder]>
        - inject OneArg_Command_Tabcomplete
    script:
        - narrate incomplete
