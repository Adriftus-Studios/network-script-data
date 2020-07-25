TPPos_Command:
    type: command
    name: tppos
    debug: true
    description: Sets a home location.
    aliases:
        - teleportposition
    usage: /tppos <&lt>X<&gt> (Y) <&lt>Z<&gt> (World)
    permission: Behr.Essentials.sethome
    tab complete:
        - determine <empty>
    script:
        - if <context.args.size> > 4 && <context.args.size> < 1:
            - inject Command_Syntax
        
        - choose <context.args.size>:
            - case 2:
                - define X <context.args.get[1]>
                - define Z <context.args.get[2]>

            - case 3:
                - define X <context.args.get[1]>
                - if <context.args.get[2].is_integer>:
                    - if <context.args.get[3].is_integer>:
                        - defien Y <context.args.get[2]>
                        - define Z <context.args.get[3]>
                    - else if <server.list_worlds.parse[name].contains[<context.args.get[3]>]>:
                        - define Y top
                        - define Z <context.args.get[2]>
                        - define World <context.args.get[3]>
                    - else:
                        - define Reason "Invalid World or Incorrect Syntax."
                        - inject Command_Error
                - else:
                    - inject Command_Syntax

            - case 4:
                - define X <context.args.get[1]>
                - define Y <context.args.get[2]>
                - define Z <context.args.get[3]>
                - if <server.list_worlds.parse[name].contains[<context.args.get[4]>]>:
                    - define World <context.args.get[4]>
                - else:
                    - define Reason "Invalid World."
                    - inject Command_Error

        - if !<[X].is_integer>:
            - define Reason "Invalid Coordinates."
            - inject Command_Error
        - if !<[Z].is_integer>:
            - define Reason "Invalid Coordinates."
            - inject Command_Error
        - if !<[Y].is_integer> && <[Y]> != Top:
            - define Reason "Invalid Coordinates."
            - inject Command_Error
        - if !<[World].exists>:
            - define World <player.world.name>
        - if <[Y]> == top:
            - define Loc <location[<[X]>,0,<[Z]>,<[World]>].highest.above>
            - chunkload <[Loc].chunk>
            - teleport <player> <[Loc]>
        - else:
            - define Loc <player> <location[<[X]>,<[Y]>,<[Z]>,<[World]>]>
            - chunkload <[Loc].chunk>
            - teleport <player> <[Loc]>
