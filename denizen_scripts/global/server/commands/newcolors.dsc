NewColors:
    type: command
    name: NewColors
    debug: false
    usage: /newcolors (#)
    description: Lists the new colors in a click-menu
    permission: Behrry.Essentials.NewColors
    script:
        - if !<list[0|1].contains[<context.args.size>]>:
            - inject Command_Syntax Instantly

        - if <context.args.is_empty>:
            - define Int 34
        - else:
            - define int <context.args.first>
            - if !<[Int].is_integer>:
                - define Reason "Must specify an integer if specifying size."
                - inject Command_Error
            - if <[Int].contains[.]>:
                - define Reason "Cannot specify decimals."
                - inject Command_error
            - if <[Int]> < 0:
                - define reason "Must specify a number higher than zero."
                - inject Command_error
            - if <[Int]> > 111:
                - define reason "Cannot exceed 100 for size."
                - inject Command_error
    #^  - define Color <&color[#FF0000]>
    #^  - define ColorList <list[<[Color]>]>
    #^  - define Scale <element[360].div[<[Int]>]>
        - define color <color[255,0,0]>
        - inject locally ColorFormat
        - define ColorList <list[<[Text]>]>

        - repeat <[Int]>:
        #^  - define NextColor <[Color].with_hue[<[Loop_index].mul[<[Scale]>]>]>
            - define color <proc[cycle_hue].context[<[color]>|<[Int]>]>
            - inject locally ColorFormat
            - define ColorList <[ColorList].include[<[Text]>]>
        - narrate <[ColorList].unseparated>
    ColorFormat:
        - define Hover "<element[<&chr[2588]><&chr[2588]>Click to insert!<&chr[2588]><&chr[2588]>].color[<[color]>]>"
        - define Insertion #<[Color].rgb>#
        - define Text <&hover[<[Hover]>]><&insertion[<[Insertion]>]><&chr[2588].color[<[color]>]><&end_insertion><&end_hover>
