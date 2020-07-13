Give_Command:
    type: yaml data
    name: give
    debug: false
    description: Gives yourself an item.
    admindescription: gives yourself or another player an item.
    usage: /give <&lt>Item<&gt> (#) (-s)
    adminusage: /give <&lt>Item<&gt> (#) (-s)
    permission: Behrry.Essentials.Give
    tab complete:
        - if <context.args.size||0> == 0:
          - determine <server.list_online_players.parse[name]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
          - determine <server.list_online_players.parse[name].filter[starts_with[<context.args.get[1]>]]>

        - define BlackList <list[air|water|lava|Bedrock]>
        - define list <server.list_materials.parse[to_lowercase].exclude[<[BlackList]>]>
        - if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
          - determine <[list]>
        - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
          - determine <[List].filter[starts_with[<context.args.get[2]>]]>
    script:
        - execute as_server "denizen do_nothing"

Give_Handler:
    type: yaml data
    debug: false
    events:
        on give command:
            - determine passively fulfilled
            - if <context.args.get[1]||null> || <context.args.get[5]||null> != null:
                - inject Command_Syntax Instantly
            - define BlackList <list[air|water|lava|Bedrock]>
            - define list <server.list_materials.parse[to_lowercase].exclude[<[BlackList]>]>
            - if <element[-s].contains_any[<context.raw_args.split[<&sp>]>]>:
                - define UnlimitStackSize True
            - if <[list].contains[<context.args.get[1]>]>:
                - define Item <context.args.get[1]>
                - define Quantity <context.args.get[2]||1>
            - else:
                - define User <context.args.get[1]>
                - inject Player_Verification Instantly
                - define Item <context.args.get[2]>
                - define Quantity <context.args.get[3]||1>
                - if <[User]> != <player>:
                    - narrate targets:<player> "<proc[Colorize].context[You gave|green]> <[User].name.display><&r> <&6>[<&e><[Quantity]><&6>] <&e><[Item].as_material.name.replace[_].with[ ]>"
                

            - if <[UnlimitStackSize].exists>:
                - give player:<[User]||<player>> <[Item]> quantity:<[Quantity]> unlimit_stack_size
            - else:
                - give player:<[User]||<player>> <[Item]> quantity:<[Quantity]>
            - narrate "<proc[Colorize].context[You received:|green]> <&6>[<&e><[Quantity]><&6>] <&e><[Item].as_material.name.replace[_].with[ ]>"

