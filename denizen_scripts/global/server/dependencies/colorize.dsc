Colorize:
    type: procedure
    debug: false
    definitions: string|color
    script:
        - choose <[Color]>:
            - case Blue:
                - define 1 <&3>
                - define 2 <&b>
            - case BlueInverted:
                - define 1 <&b>
                - define 2 <&3>
            - case Green:
                - define 1 <&2>
                - define 2 <&a>
            - case Red:
                - define 1 <&color[#ff3300]>
                - define 2 <&color[#ff5c33]>
            - case Purple:
                - define 1 <&5>
                - define 2 <&d>
            - case Yellow:
                - define 1 <&6>
                - define 2 <&e>
            - case Gray:
                - define 1 <&8>
                - define 2 <&7>

        - define Text <[String].split[].parse_tag[<tern[<[parse_value].matches_character_set[!@#$<&pc>^&*|()<&lt><&gt>{}<&lb><&rb>:;<&sq><&dq>-_,.?/ABCDEFGHIJKLMNOPQRSTUVWXYZ]>].pass[<[1]><[parse_value]>].fail[<[2]><[parse_value]>]>].unseparated>
        - Determine <[Text]>

Colorize_Green:
    type: format
    debug: false
    format: <proc[Colorize].context[<text>|green]>
Colorize_Yellow:
    type: format
    debug: false
    format: <proc[Colorize].context[<text>|yellow]>
Colorize_Red:
    type: format
    debug: false
    format: <proc[Colorize].context[<text>|red]>
Colorize_Blue:
    type: format
    debug: false
    format: <proc[Colorize].context[<text>|blue]>
