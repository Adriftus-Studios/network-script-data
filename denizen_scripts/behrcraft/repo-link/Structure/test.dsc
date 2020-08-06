#XeaneTesting:
    #type: world
    #debug: false
    #events:
        #on chunk unloads bukkit_priority:MONITOR ignorecancelled:true:
        #    - announce to_console "<&e>Chunk<&6>: <&a><context.chunk> <&b>| <&e>Cancelled<&6>: <&a><context.cancelled>"


HomeTest:
    type: task
    debug: false
    definitions: ChunkHolders
    script:
        - foreach <server.players.filter[has_flag[Behrry.Essentials.homes]]> as:Player:
            - define PlayersWithHomes:->:<[Player]>
            - foreach <[player].flag[Behrry.Essentials.homes].parse[after[/].as_location.chunk]> as:Chunk:
                - if <[Chunk].is_loaded||false>:
                    - if !<[ChunkHolders].contains[<[Player]>]||false>:
                        - define ChunkHolders:->:<[Player]>
                    - define <[Player]>ChunksLoaded:++
                    - define ChunksLoaded:++
                    - wait 1t
                    #- stop
            - wait 1t
        - debug approval "<&e>Total loaded chunks<&6>: <[ChunksLoaded]>"
        - foreach <[ChunkHolders]> as:Player:
            - debug approval "<&b><[Player].name><&6>'<&e>s loaded chunks<&6>: <[<[Player]>ChunksLoaded]>"
        - debug approval "<&e>ChunkHolders<&6>: <&a><[ChunkHolders].parse[name].comma_separated.replace[,].with[<&6>, <&a>]>"
