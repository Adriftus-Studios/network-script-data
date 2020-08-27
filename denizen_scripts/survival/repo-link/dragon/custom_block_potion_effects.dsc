custom_block_potion_effects:
    type: world
    events:
        on player steps on brown_mushroom_block in:End_dimension:
        # Faces go here
        #- if <context.location.material.faces> == <list[]>:
            - burn <player> duration:20s
            - cast poison duration:30s
            - while <player.location.center> == <context.location.center>:
                - cast confusion duration:1s
                - cast slow duration:1s
                - wait 10t
        on player steps on water in:End_dimension:
        - while <player.location.material.name> == water:
            - cast slow duration:1s
            - if <queue.time_ran.in_seconds> >= 10:
                - hurt 2
                - cast confusion duration:1s
            - wait 10t
        on player steps on block in:End_dimension:
        - while <player.location.add[-1,-1,-1].to_cuboid[<player.location.add[1,1,1]>].blocks[water].is_empty.not>:
            - if <queue.time_ran.in_seconds> >= 15:
                - cast poison duration:2s
            - wait 1s
            
