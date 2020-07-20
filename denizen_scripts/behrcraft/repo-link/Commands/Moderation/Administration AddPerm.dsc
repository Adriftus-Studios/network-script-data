# | ███████████████████████████████████████████████████████████
# % ██    /addperm - adds a permission node to a group
# | ██
# % ██  [ Command ] ██
addperm_Command:
    type: command
    name: addperm
    debug: false
    description: adds a permission node to a group
    usage: /addperm
    permission: behrry.essentials.addperm
    tab complete:
        - define Arg1 <list[Silent|Visitor|Patron|Sponsor|Builder|Constructor|Architect|Developer|Support|Moderator|Administrator|Coordinator|CMeme]>
        - define Arg2 <list[behrry.essentials.|behrry.moderation.]>
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
            - determine <[Arg2].filter[starts_with[<context.args.get[1]>]]>

    script:
        - if <context.args.size> != 2:
            - inject Command_Syntax Instantly
        - if <list[Silent|Visitor|Patron|Sponsor|Builder|Constructor|Architect|Developer|Support|Moderator|Administrator|Coordinator|CMeme].contains[<context.args.get[1]>]>:
            - define Group <context.args.get[1]>
        - else:
            - define Reason "Invalid Group."
            - inject Command_Error Instantly
        - define Permission <context.args.get[2]>
        - execute as_player "upc addgrouppermission <[Group]> <[Permission]>"
        - narrate targets:<server.list_online_players.filter[in_group[Moderation]]> "<&b>Permission: <&a><[Permission]> <&e>added to: <&a><[Group]>"
