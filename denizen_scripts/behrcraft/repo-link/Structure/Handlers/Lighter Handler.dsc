Lighter:
    type: item
    debug: false
    material: blaze_rod
    display name: <&6>L<&e>ighter

Lighter_Handler:
    type: world
    debug: false
    events:
        on player right clicks block with:Lighter:
            - if <player.has_permission[Behrry.Constructor.Light]>:
                - define Loc <player.location.cursor_on>
                - define Chunk <player.location.chunk.x>,<player.location.chunk.z>,<player.world>
                - if !<server.has_flag[LighterChunks.<[Chunk]>]>:
                    - flag server LighterChunks.<[Chunk]>:->:<[Loc]>
                - else if !<server.flag[LighterChunks.<[Chunk]>].contains[<[Loc]>]>:
                    - flag server LighterChunks.<[Chunk]>:->:<[Loc]>
                - else:
                    - stop
                - define ClosePlayers <[Loc].find.players.within[16]>
                - define FarPlayers <[Loc].find.players.within[80].exclude[<[ClosePlayers]>]>
                - playsound <[ClosePlayers]> ENTITY_TNT_PRIMED volume:1 pitch:<util.random.decimal.add[0.5]>
                - playsound <[ClosePlayers]> ENTITY_FIREWORK_ROCKET_TWINKLE volume:1 pitch:<util.random.decimal.add[0.5]>
                - playsound <[FarPlayers]> ENTITY_FIREWORK_ROCKET_TWINKLE_FAR pitch:<util.random.decimal.add[0.5]> volume:5
                - playsound <[FarPlayers]> ENTITY_FIREWORK_ROCKET_LARGE_BLAST_FAR pitch:<util.random.decimal.add[0.5]> volume:5
                - repeat 2:
                    - playeffect effect:CLOUD at:<[Loc].center> quantity:20 data:0.05 offset:0.0 visibility:96
                - repeat 5:
                    - playeffect effect:FLAME at:<[Loc].center> quantity:20 data:0.015 visibility:96 offset:0.5
                - narrate "<proc[Colorize].context[Illuminated Block:|green]> <&6>[<&e><[Loc].x><&6>, <&e><[Loc].y><&6>, <&e><[Loc].z><&6>]"
                - light <[Loc]> 15
