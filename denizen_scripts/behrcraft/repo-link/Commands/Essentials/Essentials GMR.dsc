GMR_Command:
    type: command
    name: gmr
    debug: false
    description: turns on or off gamemode requesting for the specific gamemode
    usage: /gmr <&lt>Gamemode<&gt> (On/Off)
    permission: behrry.essentials.gmr
    tab complete:
        - define Arg1 <list[Adventure|Creative|Survival|Spectator]>
        - define Arg2 <list[On|Off]>
        #/command█
        - if <context.args.size||0> == 0:
            - determine <[Arg1]>
        #/command█X
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <[Arg1].filter[starts_with[<context.args.get[1]>]]>
        #/command█X█
        - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
            - determine <[Arg2]>
        #/command█X█X
        - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <[Arg2].filter[starts_with[<context.args.get[2]>]]>
    script:
        # - argcheck !4  /c [1] [2] [3] [?]
        - if <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly
        # - argcheck 1 - Gamemode   /c [?]
        - if <context.args.get[1]||null> != null:
            - if <list[Adventure|Creative|Survival|Spectator].contains[<context.args.get[1]>]>:
                - define Gamemode <context.args.get[1]>
            - else:
                - inject Command_Syntax Instantly
        - else:
            - inject Command_Syntax Instantly
            
        # - argcheck 2 - Toggle
        - if <context.args.get[2]||null> != null:
            - if <list[Open|Close|True|False|On|Off].contains[<context.args.get[2]>]>:
                - choose <context.args.get[2]>:
                    - case Open|True|On:
                        - define Toggle TRUE
                    - case Close|False|Off:
                        - define Toggle FALSE
            - else:
                - inject Command_Syntax Instantly
        - else:
            - if <server.has_flag[behrry.essentials.gamemoderequest.<[Gamemode]>.open]>:
                - define Toggle FALSE
            - else:
                - define Toggle TRUE
        
        - if <[Toggle]> == true:
            - if <server.has_flag[behrry.essentials.gamemoderequest.<[Gamemode]>.open]>:
                - narrate "This already is on"
            - else:
                - flag server behrry.essentials.gamemoderequest.<[Gamemode]>.open
        - else:
            - if <server.has_flag[behrry.essentials.gamemoderequest.<[Gamemode]>.open]>:
                - flag server behrry.essentials.gamemoderequest.<[Gamemode]>.open:!
            - else:
                - narrate "This is already of"
        

