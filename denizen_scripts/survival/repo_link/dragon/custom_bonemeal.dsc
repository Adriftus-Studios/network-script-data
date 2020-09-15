custom_grass_bonemeal_handler:
    type: world
    events:
        on player right clicks brown_mushroom_block with:bone_meal in:End_dimension:
        - if <context.location.material.faces> == <list[east|south|west|up]>:
            - foreach <context.location.add[-2,0,-2].to_cuboid[<context.location.add[2,0,2]>].blocks[brown_mushroom_block].parse[above[1]].filter[material.name.is[==].to[air]]>:
                - choose <util.random.int[1].to[10]>:
                    - case 1 2 3:
                        - modifyblock <[value]> tall_grass[half=bottom] no_physics
                        - modifyblock <[value].above[1]> tall_grass[half=top] no_physics
                    - case 4 5 6 7 8 9:
                        - modifyblock <[value]> grass no_physics
        
