Fakeit:
    type: task
    debug: false
    definitions: origin|height
    script:
        #@ Origin/height?
        - if <[Origin]||null> == null:
            - define Origin 5
        - if !<[Height]||null> == null:
            - define Height 6

        #@ Main Definitions
        - define PreciousMaterials <list[iron_ore|coal_ore|diamond_ore|lapis_ore|emerald_ore|redstone_ore|gold_ore]>
        - define Chunk <player.location.chunk>
        - define Cuboid <[Chunk].cuboid>

        #@ Main Room
        - define P1 <[Cuboid].min.with_y[<[Origin]>]>
        - define P2 <[Cuboid].max.with_y[<[Origin].add[<[Height]>]>]>
        - define PC <[P1].to_cuboid[<[P2]>]>
        - define ClearList:|:<[PC].blocks>

        #@ Floor
        - define F1 <[Cuboid].min.with_y[<[Origin]>]>
        - define F2 <[Cuboid].max.with_y[<[Origin]>]>
        - define FC <[F1].to_cuboid[<[F2]>]>
        - define TL <[FC].blocks.filter[x.round_up.abs.mod[4].is[==].to[2]].filter[z.round_up.abs.mod[4].is[==].to[0]]>
        - define FloorSpace:|:<[FC].blocks.exclude[<[TL]>]>

        #@ OuterShell1
        - define L1 <[P1].sub[1,1,1]>
        - define L2 <[p2].add[1,1,1]>
        - define LC <[L1].to_cuboid[<[L2]>]>
        - define FLL <[LC].blocks.exclude[<[ClearList]>].filter[material.name.contains_any[water|lava]]>
        - define FLLL <[FLL].filter[material.name.contains[lava]]>
        - define MaterialClaimList:|:<[FLLL].parse[material.name]>
        
        #@ OuterShell2
        - define S1 <[P1].sub[3,3,3]>
        - define S2 <[p2].add[3,3,3]>
        - define SC <[S1].to_cuboid[<[S2]>]>
        - define CL <[SC].blocks.exclude[<[ClearList]>]>
        - define FCL <[CL].filter[material.contains_any[<[PreciousMaterials]>]]>

        #@ DOorways
        - define CC <[Cuboid].center.with_y[<[Origin]>]>
        - define d1 <list[8,0,0|-9,0,0|0,0,8|0,0,-9]>
        - define d2 <list[8,2,-1|-9,2,-1|-1,2,8|-1,2,-9]>
        - repeat 4:
            - define C1 <[CC].add[<[d1].get[<[Value]>]>]>
            - define C2 <[CC].add[<[d2].get[<[value]>]>]>
            - define DC <[C1].to_cuboid[<[C2]>]>
            - define Doorways:|:<[DC].blocks>

        #@ Build MaterialList
        - define MaterialClaimList:|:<[ClearList].parse[material.name]>
        - define MaterialClaimList:|:<[FCL].parse[material.name]>

        #@ Replace All
        - if <[PC].blocks.parse[material.name].contains_any[Chest|Torch]>:
            - foreach <[PC].blocks.filter[material.name.contains[Chest]].parse[inventory]> as:Chest:
                - define MaterialClaimList:|:<[Chest].list_contents>

        ##@ Lets shove the dropped items in, too
        #^- if <[PC].list_entities.filter[entity_type.contains[dropped_item]].size> > 0:
        #^    - define DroppedItems <[PC].list_entities.filter[entity_type.contains[dropped_item]].parse[item]>
        #^- remove <[PC].list_entities.filter[entity_type.contains[dropped_item]]>

        - modifyblock <[PC]> air
        - foreach <[Doorways]> as:Door:
            - modifyblock <[Door]> air
        - foreach <[TL]> as:Torch:
            - modifyblock <[TL]> Torch
        - foreach <[FCL]> as:Block:
            - repeat 5:
                - define FallBlock <[Block].add[0,<[Value].sub[1]>,0]>
                - if <[FallBlock].material.name.contains_any[sand|gravel]>:
                    - define GravelList:|:<[FallBlock]>
                    - define MaterialClaimList:|:<[FallBlock].material.name]>
                    - modifyblock <[FallBlock]> air
                - else:
                    - repeat stop
            - modifyblock <[Block]> cobblestone
        - if !<[FLL].is_empty>:
            - foreach <[FLL]> as:block:
                - modifyblock <[block]> glass
        #- if <[GravelList]||null> != null:

        #@ goodies
        - define item <item[torch].with[quantity=<util.random.int[1].to[20]>]>
        - inject Locally ChestStuff
        - define ChestList:->:<[NewChest]>

        - foreach <[MaterialClaimList].exclude[Air]> as:Item:
            - if <[Item]> == lava:
                - define Item Lava_Bucket
                - if <[LavaChests]||null> != null:
                    - foreach <[LavaChests]> as:Chest:
                        - if <[Chest].can_fit[<[Item]>]>:
                            - give <[Item]> to:<[NewChest]>
                            - foreach stop
                        - if <[Loop_Index]> != <[LavaChests].size>:
                            - foreach next
                        - inject Locally ChestStuff
                        - define LavaChests:->:<[NewChest]>
                - else:
                    - inject Locally ChestStuff
                    - define LavaChests:->:<[NewChest]>
                - foreach next

            - foreach <[ChestList]> as:Chest:
                - if <[Chest].can_fit[<[Item]>]>:
                    - give <[Item]> to:<[Chest]>
                    - foreach stop
                - if <[Loop_Index]> != <[ChestList].size>:
                    - foreach next
                - inject Locally ChestStuff
                - define ChestList:->:<[NewChest]>
                - give <[Item]> to:<[NewChest]>

                - run add_xp def:<[MaterialClaimList].size.mul[5]>|Mining instantly
    ChestStuff:
        #- Test Run - run Fakeit path:ChestStuff
        #^- define Chunk <player.location.chunk>
        #^- define Cuboid <[Chunk].cuboid>
        #^- define F1 <[Cuboid].min.with_y[5]>
        #^- define F2 <[Cuboid].max.with_y[5]>
        #^- define FC <cuboid[<[F1]>|<[F2]>]>
        #^- define Floorspace <[FC].blocks>
        #------------------------------------------------------------
        - define Loc <[FloorSpace].random>
        - define Directions <list[North|East|South|West]>
        - define RandomDirection <[Directions].random>
        #------------------------------------------------------------
        #^- choose <[RandomDirection]>:
        #^    - case north south:
        #^        - define Sides <cuboid[<[Loc].add[1,0,0]>|<[Loc].sub[1,0,0]>]>
        #^        - if <[RandomDirection]> == north:
        #^            - define Halves <list[right|left]>
        #^        - else:
        #^            - define Halves <list[left|right]>
        #^    - case east west:
        #^        - define Sides <cuboid[<[Loc].add[0,0,1]>|<[Loc].sub[0,0,1]>]>
        #^        - if <[RandomDirection]> == east:
        #^            - define Halves <list[right|left]>
        #^        - else:
        #^            - define Halves <list[left|right]>
        #^- if !<[Sides].blocks.exclude[<[Loc]>].parse[material].contains[<material[air]>]>:
        #^    - define Safety:++
        #^    - if <[Safety]> >= 2:
        #^        - narrate "oop"
        #^        - stop
        #^    - inject Locally ChestCreate
        #^- define Loc2 <[Sides].blocks.exclude[<[Loc]>].filter[material.contains[<material[air]>]].random>
        #------------------------------------------------------------
        - define FloorSpace:<-:<[Loc]>
        #------------------------------------------------------------
        #^- define FloorSpace:<-:<[Loc2]>
        #------------------------------------------------------------
        - modifyblock <[Loc]> chest[direction=<[RandomDirection]>]
        #------------------------------------------------------------
        #^- adjustblock <[Loc]> half:<[Halves].first>
        #^- modifyblock <[Loc2]> chest[direction=<[RandomDirection]>]
        #^- adjustblock <[Loc2]> half:<[Halves].get[2]>
        #------------------------------------------------------------
        - define NewChest <[Loc].inventory>
        - give <[Item]> to:<[NewChest]>



DuoWuo:
    type: task
    debug: true
    script:
        #- foreach <list[North|South|East|west]> as:Direction:
        #    - foreach <list[Top|Bottom]> as:Half:
        #        - execute as_op "/replace minecraft:quartz_stairs[facing=<[Direction]>,half=<[half]>] polished_diorite_stairs[facing=<[Direction]>,half=<[half]>]"
        #        - execute as_op "/replace minecraft:sandstone_stairs[facing=<[Direction]>,half=<[half]>] diorite_stairs[facing=<[Direction]>,half=<[half]>]"
        - execute as_op "/replace minecraft:quartz_stairs[facing=south,half=top] minecraft:polished_diorite_stairs[facing=south,half=top]"
        - execute as_op "/replace minecraft:quartz_stairs[facing=west,half=top] minecraft:polished_diorite_stairs[facing=west,half=top]"
        - execute as_op "/replace minecraft:quartz_stairs[facing=east,half=top] minecraft:polished_diorite_stairs[facing=east,half=top]"
        - execute as_op "/replace minecraft:quartz_stairs[facing=north,half=top] minecraft:polished_diorite_stairs[facing=north,half=top]"
        - execute as_op "/replace minecraft:quartz_stairs[facing=south,half=bottom] minecraft:polished_diorite_stairs[facing=south,half=bottom]"
        - execute as_op "/replace minecraft:quartz_stairs[facing=west,half=bottom] minecraft:polished_diorite_stairs[facing=west,half=bottom]"
        - execute as_op "/replace minecraft:quartz_stairs[facing=east,half=bottom] minecraft:polished_diorite_stairs[facing=east,half=bottom]"
        - execute as_op "/replace minecraft:quartz_stairs[facing=north,half=bottom] minecraft:polished_diorite_stairs[facing=north,half=bottom]"
        - execute as_op "/replace minecraft:sandstone_stairs[facing=south,half=top] minecraft:diorite_stairs[facing=south,half=top]"
        - execute as_op "/replace minecraft:sandstone_stairs[facing=west,half=top] minecraft:diorite_stairs[facing=west,half=top]"
        - execute as_op "/replace minecraft:sandstone_stairs[facing=east,half=top] minecraft:diorite_stairs[facing=east,half=top]"
        - execute as_op "/replace minecraft:sandstone_stairs[facing=north,half=top] minecraft:diorite_stairs[facing=north,half=top]"
        - execute as_op "/replace minecraft:sandstone_stairs[facing=south,half=bottom] minecraft:diorite_stairs[facing=south,half=bottom]"
        - execute as_op "/replace minecraft:sandstone_stairs[facing=west,half=bottom] minecraft:diorite_stairs[facing=west,half=bottom]"
        - execute as_op "/replace minecraft:sandstone_stairs[facing=east,half=bottom] minecraft:diorite_stairs[facing=east,half=bottom]"
        - execute as_op "/replace minecraft:sandstone_stairs[facing=north,half=bottom] minecraft:diorite_stairs[facing=north,half=bottom]"

        - execute as_op "/replace minecraft:sandstone_slab[type=top] minecraft:diorite_slab[type=top]"
        - execute as_op "/replace minecraft:sandstone_slab[type=bottom] minecraft:diorite_slab[type=bottom]"

        - execute as_op "/replace minecraft:quartz_slab[type=top] minecraft:polished_diorite_slab[type=top]"
        - execute as_op "/replace minecraft:quartz_slab[type=bottom] minecraft:polished_diorite_slab[type=bottom]"


        - execute as_op "/replace gold_block redstone_block"
        - execute as_op "/replace cobblestone_wall diorite_wall"
        - execute as_op "/replace glass red_stained_glass"
        - execute as_op "/replace prismarine cobblestone"
        - execute as_op "/replace chiseled_sandstone diorite"
        - execute as_op "/replace black_wool air"
        - execute as_op "/replace quartz_slab[type=top] polished_diorite_slab[type=top]"
        - execute as_op "/replace chiseled_quartz_block,quartz_pillar,quartz_slab[type=double] polished_diorite"
    


ReplaceMaterials_Command:
    type: command
    name: ReplaceMaterials
    debug: false
    usage: /ReplaceMaterials Stairs/Slabs/TrapDoors (Material1) (Material2)
    description: Swaps the two materials with all the correct directions, halves and switches
    permission: test
    aliases:
        - /replacematerial
    tab complete:
        - define Arg1 <list[slab|stairs|fence|trapdoor|wall]>
        - if <context.args.size> != 0:
            - choose <context.args.first>:
                - case slabs slab:
                    - define SlabMaterials <server.material_types.parse[name].filter[contains[_slab]].parse[before[_slab]]>
                    - define Arg2 <[SlabMaterials]>
                    - define Arg3 <[SlabMaterials]>
                - case stairs stair:
                    - define StairsMaterials <server.material_types.parse[name].filter[contains[_stairs]].parse[before[_stairs]]>
                    - define Arg2 <[StairsMaterials]>
                    - define Arg3 <[StairsMaterials]>
                - case fence:
                    - define FenceMaterials <server.material_types.parse[name].filter[contains[_fence]].parse[before[_fence]]>
                    - define Arg2 <[FenceMaterials]>
                    - define Arg3 <[FenceMaterials]>
                - case trapdoor trapdoors:
                    - define TrapdoorMaterials <server.material_types.parse[name].filter[contains[_trapdoor]].parse[before[_trapdoor]]>
                    - define Arg2 <[TrapdoorMaterials]>
                    - define Arg3 <[TrapdoorMaterials]>
                - case wall walls:
                    - define WallMaterials <server.material_types.parse[name].filter[contains[_wall]].filter[contains_any[banner|torch|bubble|coral|sign|creeper|skeleton|zombie|head].not].parse[before[_wall]]>
                    - define Arg2 <[WallMaterials]>
                    - define Arg3 <[WallMaterials]>
        - inject MultiArg_Command_Tabcomplete Instantly
    script:
        - if <context.args.size> != 3:
            - narrate format:Colorize_Red "Need two materials"
            - inject Command_Syntax Instantly

        - define ReplaceFrom <context.args.get[2]>
        - define ReplaceTo <context.args.get[3]>

        - choose <context.args.first>:
            - case stairs stair:
                - if !<server.material_types.parse[name].filter[contains[_stairs]].contains[<[ReplaceFrom]>_stairs|<[Replaceto]>_stairs]>:
                    - narrate format:Colorize_Red "Invalid material."
                    - inject CommanD_Syntax Instantly
                - foreach <list[north|south|east|west]> as:Direction:
                    - foreach <list[top|bottom]> as:Half:
                        - define arg1 "<[ReplaceFrom]>_stairs[facing=<[Direction]>,half=<[Half]>]"
                        - define arg2 "<[ReplaceTo]>_stairs[facing=<[Direction]>,half=<[Half]>]"
                        - execute as_op "/replace <[arg1]> <[arg2]>"

            - case slabs slab:
                - if !<server.material_types.parse[name].filter[contains[_slab]].contains[<[ReplaceFrom]>_slab|<[Replaceto]>_slab]>:
                    - narrate format:Colorize_Red "Invalid material."
                - foreach <list[top|bottom|double]> as:Half:
                    - define arg1 "<[ReplaceFrom]>_slab[type=<[Half]>]"
                    - define arg2 "<[ReplaceTo]>_slab[type=<[Half]>]"
                    - execute as_op "/replace <[arg1]> <[arg2]>"
            
            - case fence:
                - if !<server.material_types.parse[name].filter[contains[_fence]].contains[<[ReplaceFrom]>_fence|<[Replaceto]>_fence]>:
                    - narrate format:Colorize_Red "Invalid material."

                - define Fences <player.we_selection.blocks.filter[material.name.contains[<[ReplaceFrom]>_fence]]>
                - foreach <[Fences]> as:Fence:
                    - define Faces <[Fence].material.faces>
                    - modifyblock <[Fence]> <material[<[ReplaceTo]>_fence].with[faces=<[Faces]>]>
            - case wall:
                - if !<server.material_types.parse[name].filter[contains[_fence]].contains[<[ReplaceFrom]>_fence|<[Replaceto]>_fence]>:
                    - narrate format:Colorize_Red "Invalid material."

                - define Walls <player.we_selection.blocks.filter[material.name.contains[<[ReplaceFrom]>_wall]]>
                - foreach <[Walls]> as:Wall:
                    - define Faces <[Wall].material.faces>
                    - modifyblock <[Wall]> <material[<[ReplaceTo]>_wall].with[faces=<[Faces]>]>

            - case trapdoor trapdoors:
                - foreach <list[north|south|east|west]> as:Direction:
                    - foreach <list[top|bottom]> as:Half:
                        - foreach <list[true|false]> as:Boolean:
                            - foreach <list[true|false]> as:Powered:
                                - define arg1 "<[ReplaceFrom]>_trapdoor[facing=<[Direction]>,half=<[Half]>,open=<[Boolean]>,powered=<[Powered]>]"
                                - define arg2 "<[ReplaceTo]>_trapdoor[facing=<[Direction]>,half=<[Half]>,open=<[Boolean]>,powered=<[Powered]>]"
                                - execute as_op "/replace <[arg1]> <[arg2]>"

            - default:
                - inject Command_Syntax Instantly
