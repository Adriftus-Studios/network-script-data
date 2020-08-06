Tile_indicator_While_old:
    type: task
    debug: false
    definitions: RLocations|BLocations
    script:
        - define RLocations <[RLocations].unescaped.as_list>
        - define BLocations <[BLocations].unescaped.as_list>
        - if <player.has_flag[GielinorDevelopment.TileIndicator.Queue]>:
            - if <queue.exists[<player.flag[GielinorDevelopment.TileIndicator.Queue]>]>:
                - queue <player.flag[GielinorDevelopment.TileIndicator.Queue].as_queue> clear
            - flag player GielinorDevelopment.TileIndicator.Queue:!

        - flag <player> GielinorDevelopment.TileIndicator.Queue:<queue.id>
        - if <player.has_flag[GielinorDevelopment.TileIndicator.Monitor]>:
            - define BlackList <list[air|grass|fern|tall_grass|large_fern]>
            - repeat 1:
                - define REffectList:!
                - foreach <[RLocations]> as:RLocation:
                    - if <[Blacklist].contains[<[RLocation].material.name>]>:
                        - while true:
                            - if <[Blacklist].contains[<[RLocation].add[0,-10,0].add[0,<[loop_index]>,0].material.name>]>:
                                - define H <element[-10].add[<[Loop_index]>]>
                                - while stop
                    - else if <[Blacklist].contains[<[RLocation].add[0,1,0].material.name>]>:
                        - define H 1
                    - else if <[Blacklist].contains[<[RLocation].add[0,2,0].material.name>]>:
                        - define H 2
                    - else:
                        - foreach next
                    - define REffectList:->:<[RLocation].add[0,<[h]>,0]>

                - define BEffectList:!
                - foreach <[BLocations]> as:BLocation:
                    - if <[Blacklist].contains[<[BLocation].material.name>]>:
                        - while true:
                            - if <[Blacklist].contains[<[BLocation].add[0,-10,0].add[0,<[loop_index]>,0].material.name>]>:
                                - define H <element[-10].add[<[Loop_index]>]>
                                - while stop
                    - else if <[Blacklist].contains[<[BLocation].add[0,1,0].material.name>]>:
                        - define H 1
                    - else if <[Blacklist].contains[<[BLocation].add[0,2,0].material.name>]>:
                        - define H 2
                    - else:
                        - foreach next
                    - define BEffectList:->:<[BLocation].add[0,<[h]>,0]>

                - playeffect effect:redstone at:<[REffectList]> offset:0 quantity:1 data:0 special_data:0.75|255,125,0
                - playeffect effect:redstone at:<[BEffectList]> offset:0 quantity:1 data:0 special_data:0.75|0,125,255
            - wait 1t
            - run Tile_Indicator_Task Instantly def:<[RLocations].escaped>|<[BLocations].escaped>

Tile_Indicator_Task_old:
    type: task
    debug: false
    script:
        - define X <player.location.x.round_down>
        - define Z <player.location.z.round_down>
        
        - if <[X].mod[2]> == 1 && <[Z].mod[2]> == 0:
            - define Offset 0,0,0
        - else if <[X].mod[2]> == 0 && <[Z].mod[2]> == 0:
            - define Offset -1,0,0
        - else if <[X].mod[2]> == 1 && <[Z].mod[2]> == 1:
            - define Offset 0,0,-1
        - else if <[X].mod[2]> == 0 && <[Z].mod[2]> == 1:
            - define Offset -1,0,-1
        - define Radius <element[1].mul[3]>
        - define Loc <player.location.add[<[Offset]>].simple.as_location>
        - define cuboid <cuboid[<[Loc].add[<[Radius]>,0,<[Radius]>]>|<[Loc].sub[<[Radius]>,0,<[Radius]>]>]>
        
        - foreach <[Cuboid].blocks.filter[x.mod[2].is[==].to[1]].filter[z.mod[2].is[==].to[0]]> as:Loc:
            - define RLocations li@
            - define BLocations li@
            #-Red Bars
            #@ AirCheck
            - if <[Loc].material.name> == air:
                - define RH 0
            - else if <[Loc].add[0,1,0].material.name> == air:
                - define RH 1
            - else if <[Loc].add[0,2,0].material.name> == air:
                - define RH 2
            - else:
                - define RH 3
            - if <[RH]> != 0:
                - define RLocations <[RLocations].include[<[Loc].add[1,0,1].points_between[<[Loc].add[1,<[RH]>,1]>].distance[0.19]>]>
                - define RLocations <[RLocations].include[<[Loc].add[1,0,0].points_between[<[Loc].add[1,<[RH]>,0]>].distance[0.19]>]>
                - define RLocations <[RLocations].include[<[Loc].add[0,0,1].points_between[<[Loc].add[0,<[RH]>,1]>].distance[0.19]>]>
            #@ top
            - define RLoc1 <[Loc].add[0,0,0].points_between[<[Loc].add[1,0,0]>].distance[0.19].parse[add[0,<[RH]>,0]]>
            #@ side
            - define RLoc2 <[Loc].add[0,0,0].points_between[<[Loc].add[0,0,1]>].distance[0.19].parse[add[0,<[RH]>,0]]>
            #@ top mid
            - define RLoc3 <[Loc].add[1,0,0].points_between[<[Loc].add[1,0,1]>].distance[0.19].parse[add[0,<[RH]>,0]]>
            #@ side mid
            - define RLoc4 <[Loc].add[0,0,1].points_between[<[Loc].add[1,0,1]>].distance[0.19].parse[add[0,<[RH]>,0]]>
            #-Blue Bars
            #@ top
            - define BLoc1 <[Loc].add[1,0,0].points_between[<[Loc].add[1.99,0,0]>].distance[0.19]>
            #@ side
            - define BLoc2 <[Loc].add[0,0,1].points_between[<[Loc].add[0,0,1.99]>].distance[0.19]>
            #@ top mid
            - define BLoc3 <[Loc].add[1.99,0,0].points_between[<[Loc].add[1.99,0,1.99]>].distance[0.19]>
            #@ side mid
            - define BLoc4 <[Loc].add[0,0,1.99].points_between[<[Loc].add[1.99,0,1.99]>].distance[0.19]>
            - repeat 4:
                #@ red bars
                - define RLocations <[RLocations].include[<[RLoc<[Value]>]>]>
                #@ blue bars
                - define BLocations <[BLocations].include[<[BLoc<[Value]>]>]>
    #
    #
            - run Tile_indicator_While instantly def:<[RLocations].escaped>|<[BLocations].escaped>


teststck:
  type: item
  material: blaze_rod


TempWand1:
  type: item
  material: golden_axe
  display name: <&b>D<&3>evelopmental <&b>A<&3>xe
testcmdr:
  type: command
  name: test
  permission: test
  usage: no
  description: no
  debug: false
  aliases:
    - t
    - tcopy
  tab complete:
    - if <player.name.contains[behr]>:
      - define Arg1 <list[TreePlanter|CuboidSchematicSave|CuboidCopy|Replicate|TeleOver|CuboidExpandsiveSelector|RepeatySet|RepeatySetMaterialSet|SkeletonFixCuboid|SkeletonFixSphere|TileMonitor|GetAxe|StonePather]>
      - inject MultiArg_Command_Tabcomplete Instantly
  script:
    - choose <context.args.first||<context.alias||null>>:
      #- Used to test the axe
      - case AxeTester:
        - if <player.flag[GielinorDevelopment.AxeMode]> != AxeTester:
          - flag player GielinorDevelopment.AxeMode:AxeTester
          - narrate "<&e>Axe Mode Set<&6>: <&a>AxeTester"
          - stop
        - if <context.args.size> == 1:
          - narrate "<&c>Axe Mode Currently Set."
          - stop
        
        - narrate <&a>Success

      - case GetAxe:
        - give TempWand1
      - case TileMonitor:
        - if <player.has_flag[GielinorDevelopment.TileIndicator.Monitor]>:
          - flag player GielinorDevelopment.TileIndicator.Monitor:!
          - narrate "<&e>Tile Indicator<&6>: <&c>disabled"
          - stop
        - flag player GielinorDevelopment.TileIndicator.Monitor
        - narrate "<&e>Tile Indicator<&6>: <&a>enabled"

        - define Size <context.args.get[2]||3>
        - while <player.has_flag[GielinorDevelopment.TileIndicator.Monitor]>:
          - define Center <player.location.round_down>
          - define X <[Center].x>
          - define Y <[Center].y>
          - define Z <[Center].z>
          - define RedTiles:!
          - define BlueTiles:!
          - define RedLines:!
          - define BlueLines:!

          #% Find the Center
          - if <[X].is_odd> && <[Z].is_odd>:
            - define CenterTile:<[Center]>
          - else if <[X].is_odd> && <[Z].is_even>:
            - define CenterTile:<[Center].sub[0,0,1]>
          - else if <[X].is_even> && <[Z].is_even>:
            - define CenterTile:<[Center].sub[1,0,1]>
          - else if <[X].is_even> && <[Z].is_odd>:
            - define CenterTile:<[Center].sub[1,0,0]>

          #% Create the Grid
          - define Grid <cuboid[<[CenterTile].add[<[Size]>,0,<[Size]>]>|<[CenterTile].sub[<[Size]>,0,<[Size]>]>]>
          #% Define the Red Tiles of the grid
          - define RedGrid <[Grid].blocks.filter[x.is_odd].filter[z.is_odd]>
          - foreach <[RedGrid]> as:Tile:
            - define yOffset 0
            - repeat 10:
              - if <list[air|grass|fern|large_fern|tall_grass].contains[<[Tile].above[<[yOffset]>].material.name>]>:
                - define yOffset:--
                - if <[Value]> == 10:
                  - define RedTiles:|:<[Tile].above[<[yOffset]>]>
                - repeat next
              - define RedTiles:|:<[Tile].above[<[yOffset]>].above[1]>
              - repeat stop

          - foreach <[RedTiles]> as:Tile:
            #% Define the Red Lines
            - foreach <list[0,0,0/1,0,0|0,0,0/0,0,1|1,0,0/1,0,1|0,0,1/1,0,1]> as:Set:
              - define RedLines:|:<[Tile].add[<[Set].before[/]>].points_between[<[Tile].add[<[Set].after[/]>]>].distance[0.15]>
            #% Define the Blue Tiles of the grid
            - foreach <list[0,0,1|1,0,1|1,0,0]> as:Offset:
              - define yOffset 0
              - repeat 10:
                - if <list[air|grass|fern|large_fern|tall_grass].contains[<[Tile].add[<[Offset]>].above[<[yOffset]>].material.name>]>:
                  - define yOffset:--
                  - if <[Value]> == 10:
                    - define BlueTile <[Tile].add[<[Offset]>].above[<[yOffset]>]>
                  - repeat next
                - define BlueTile <[Tile].add[<[Offset]>].above[<[yOffset]>].above[1]>
                - repeat stop


              - define BlueTiles:|:<[BlueTile]>
              #% Define the Blue Lines
              - choose <[Loop_Index]>:
                - case 1:
                  - define BlueLines:|:<[BlueTile].points_between[<[BlueTile].add[0,0,1]>].distance[0.15]>
                - case 2:
                  - foreach <list[0,0,1/1,0,1|1,0,1/1,0,0]> as:Set:
                    - define BlueLines:|:<[BlueTile].add[<[Set].before[/]>].points_between[<[BlueTile].add[<[Set].after[/]>]>].distance[0.15]>
                - case 3:
                  - foreach <list[0,0,0/1,0,0|1,0,0/1,0,1]> as:Set:
                    - define BlueLines:|:<[BlueTile].add[<[Set].before[/]>].points_between[<[BlueTile].add[<[Set].after[/]>]>].distance[0.15]>

          - playeffect effect:redstone at:<[RedLines]> offset:0 quantity:1 data:0 special_data:0.75|255,125,0
          - playeffect effect:redstone at:<[BlueLines].exclude[<[RedLines]>].deduplicate> offset:0 quantity:1 data:0 special_data:0.75|0,125,255
          - wait 3t

      #- Used to paste a schematic from the random tree repo
      - case TreePlanter:
        - if <player.flag[GielinorDevelopment.AxeMode]> != TreePlanter:
          - flag player GielinorDevelopment.AxeMode:TreePlanter
          - narrate "<&e>Axe Mode Set<&6>: <&a>TreePlanter"
          - stop
        - if <context.args.size> == 1:
          - narrate "<&c>Axe Mode Currently Set."
          - stop

        - choose <context.args.get[2]>:
          - case right left:
            - define Loc <player.cursor_on>
            - if !<player.has_flag[GielinorDevelopment.TreePlanterMode]>:
              - narrate "<&a>No Tree Selected."
              - stop
            - define Tree <player.flag[GielinorDevelopment.TreePlanterMode]>
            - if !<server.has_flag[GielinorDevelopment.TreeCollection.<[Tree]>]>:
              - narrate "<&c>no tree saved"
              - stop
            - define Index <util.random.int[1].to[<server.flag[GielinorDevelopment.TreeCollection.<[Tree]>].size>]>
            - if !<schematic.list.contains[<[Tree]>Tree<[Index]>]>:
              - schematic load name:<[Tree]>Tree<[Index]> filename:<[Tree]>/<[Tree]>Tree<[Index]>

            - schematic rotate name:<[Tree]>Tree<[Index]> angle:<list[90|180|270|360].random>
            - choose <util.random.int[1].to[3]>:
              - case 1:
                - schematic paste name:<[Tree]>Tree<[Index]> o:<[Loc]> noair
              - case 2:
                - schematic flip_x name:<[Tree]>Tree<[Index]>
                - schematic paste name:<[Tree]>Tree<[Index]> o:<[Loc]> noair
              - case 3:
                - schematic flip_z name:<[Tree]>Tree<[Index]>
                - schematic paste name:<[Tree]>Tree<[Index]> o:<[Loc]> noair
          - case Bush Regular Oak:
            - flag player GielinorDevelopment.TreePlanterMode:<context.args.get[2]>
            - narrate "<&a>Tree Planting Mode: <&e><context.args.get[2]>"
          - default:
            - narrate "<&c>Invalid Usage."
      #- select multiple cuboids
      - case MultiCuboidSelection:
        - if <player.flag[GielinorDevelopment.AxeMode]> != MultiCuboidSelection:
          - flag player GielinorDevelopment.AxeMode:MultiCuboidSelection
          - narrate "<&e>Axe Mode Set<&6>: <&a>MultiCuboidSelection"
          - stop
        - if <context.args.size> == 1:
          - narrate "<&c>Axe Mode Currently Set."
          - stop

        - choose <context.args.get[2]>:
          - case left:
            - if <player.is_sneaking>:
              - if !<player.has_flag[GielinorDevelopment.Selection]>:
                - narrate "<&c>No Selection Set."
                - stop
              - define Hover "<&e>Click to Insert:<&nl><&a><player.flag[GielinorDevelopment.Selection]>"
              - define Text "<&a>Shift-Click to Insert:<&a> <&6>[<&e>Selection<&6>]"
              - define Insert "<&lt>player.flag[GielinorDevelopment.Selection]<&gt>"
              - narrate <proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Insert]>]>
            - else:
              - define SelIndex 1
              - define Selection <cuboid[<[Loc]>|<[Loc]>]>
              - flag <player> GielinorDevelopment.Selection:<[Selection]> duration:10m
              - execute as_op "/pos1 <player.flag[GielinorDevelopment.Selection].as_cuboid.min.xyz.replace[.0].with[]>" silent
              - inject locally CuboidSelection
          - case right:
            - if <player.is_sneaking>:
              - flag <player> GielinorDevelopment.Selection:!
              - narrate "<&c>Selection Cleared."
            - else:
              - define SelIndex 2
              - if <player.has_flag[GielinorDevelopment.Selection]>:
                - define Selection <player.flag[GielinorDevelopment.Selection].as_cuboid.include[<[Loc]>]>
                - flag <player> GielinorDevelopment.Selection:<[Selection]> duration:10m
                - execute as_op "/pos2 <player.flag[GielinorDevelopment.Selection].as_cuboid.max.xyz.replace[.0].with[]>" silent
                - inject locally CuboidSelection
              - else:
                - define Selection <cuboid[<[Loc]>|<[Loc]>]>
                - flag <player> GielinorDevelopment.Selection:<[Selection]> duration:10m
                - execute as_op "/pos2 <player.flag[GielinorDevelopment.Selection].as_cuboid.max.xyz.replace[.0].with[]>" silent
                - inject locally CuboidSelection
      #- Used to save a schematic to the random tree repo
      - case CuboidSchematicSave:
        - if !<player.has_flag[GielinorDevelopment.Selection]>:
          - narrate "No Selection Active."
          - stop
        - choose <context.args.get[2]||null>:
          - case Regular:
            - define Tree Regular
          - case Oak:
            - define Tree Oak
          - case Bush:
            - define tree Bush
          - default:
            - narrate "<&c>No or Invalid Tree-type Specified."
            - stop

        - define Index <server.flag[GielinorDevelopment.TreeCollection.<[Tree]>].size.add[1]||1>
        - flag server GielinorDevelopment.TreeCollection.<[Tree]>:->:Tree<[Index]>
        - narrate "<&a>Added tree to collection named<&4>:<&e><[Tree]> <&6>#<&e><[Index]>"
        - schematic create name:<[Tree]>Tree<[Index]> <player.flag[GielinorDevelopment.Selection].as_cuboid> o:<player.cursor_on> noair
        - schematic save name:<[Tree]>Tree<[Index]> filename:<[Tree]>/<[Tree]>Tree<[Index]>
      #- Used to copy the expanding cuboid
      - case CuboidCopy tcopy:
        - execute as_op "/pos1 <player.flag[GielinorDevelopment.Selection].as_cuboid.min.xyz.replace[.0].with[]>" silent
        - execute as_op "/pos2 <player.flag[GielinorDevelopment.Selection].as_cuboid.max.xyz.replace[.0].with[]>" silent
        - execute as_op "/copy"
      #- Used for selecting expanding cuboids
      - case CuboidExpandsiveSelector:
        - if <player.flag[GielinorDevelopment.AxeMode]> != CuboidExpandsiveSelector:
          - flag player GielinorDevelopment.AxeMode:CuboidExpandsiveSelector
          - narrate "<&e>Axe Mode Set<&6>: <&a>CuboidExpandsiveSelector"
          - stop
        - if <context.args.size> == 1:
          - narrate "<&c>Axe Mode Currently Set."
          - stop
        
        - define Loc <player.cursor_on>
        - choose <context.args.get[2]>:
          - case left:
            - if <player.is_sneaking>:
              - if !<player.has_flag[GielinorDevelopment.Selection]>:
                - narrate "<&c>No Selection Set."
                - stop
              - define Hover "<&e>Click to Insert:<&nl><&a><player.flag[GielinorDevelopment.Selection]>"
              - define Text "<&a>Shift-Click to Insert:<&a> <&6>[<&e>Selection<&6>]"
              - define Insert "<&lt>player.flag[GielinorDevelopment.Selection]<&gt>"
              - narrate <proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Insert]>]>
            - else:
              - define SelIndex 1
              - define Selection <cuboid[<[Loc]>|<[Loc]>]>
              - flag <player> GielinorDevelopment.Selection:<[Selection]> duration:10m
              - execute as_op "/pos1 <player.flag[GielinorDevelopment.Selection].as_cuboid.min.xyz.replace[.0].with[]>" silent
              - inject locally CuboidSelection
          - case right:
            - if <player.is_sneaking>:
              - flag <player> GielinorDevelopment.Selection:!
              - narrate "<&c>Selection Cleared."
            - else:
              - define SelIndex 2
              - if <player.has_flag[GielinorDevelopment.Selection]>:
                - define Selection <player.flag[GielinorDevelopment.Selection].as_cuboid.include[<[Loc]>]>
                - flag <player> GielinorDevelopment.Selection:<[Selection]> duration:10m
                - execute as_op "/pos2 <player.flag[GielinorDevelopment.Selection].as_cuboid.max.xyz.replace[.0].with[]>" silent
                - inject locally CuboidSelection
              - else:
                - define Selection <cuboid[<[Loc]>|<[Loc]>]>
                - flag <player> GielinorDevelopment.Selection:<[Selection]> duration:10m
                - execute as_op "/pos2 <player.flag[GielinorDevelopment.Selection].as_cuboid.max.xyz.replace[.0].with[]>" silent
                - inject locally CuboidSelection
      
      #- Used for repeating the //set nonsense but on rightclicks
      - case RepeatySetMaterialSet:
        - if <context.args.size> != 2:
          - narrate "<&c>Specify a material."
          - stop
        - narrate "<&a>RepeatyMaterial Set to: <&e><context.args.get[2]>"
        - flag player GielinorDevelopment.RepeatySet.StackMaterial:<context.args.get[2]>
      - case RepeatySet:
        - if <player.flag[GielinorDevelopment.AxeMode]> != RepeatySet:
          - flag player GielinorDevelopment.AxeMode:RepeatySet
          - narrate "<&e>Axe Mode Set<&6>: <&a>RepeatySet"
          - execute as_op "/sel cuboid"
          - stop
        - if <context.args.size> == 1:
          - narrate "<&c>Axe Mode Currently Set."
          - stop
        - choose <context.args.get[2]>:
          - case left:
            - execute as_op "/pos1 <player.cursor_on.xyz.replace[.0].with[]>"
          - case right:
            - execute as_op "/pos2 <player.cursor_on.xyz.replace[.0].with[]>"
            - if !<player.has_flag[GielinorDevelopment.RepeatySet.StackMaterial]>:
              - narrate "<&c>No StackMaterial Set."
              - stop
            - execute as_op "/set <player.flag[GielinorDevelopment.RepeatySet.StackMaterial]>"
      #- Used for converting lone stone into a path, removes stone above wall and door markers
      - case StonePather:
        - if <player.flag[GielinorDevelopment.AxeMode]> != StonePather:
          - flag player GielinorDevelopment.AxeMode:StonePather
          - narrate "<&e>Axe Mode Set<&6>: <&a>StonePather"
          - execute as_op "/sel cuboid"
          - stop
        - if <context.args.size> == 1:
          - narrate "<&c>Axe Mode Currently Set."
          - stop
        - choose <context.args.get[2]>:
          - case left:
            - execute as_op "/pos1 <player.cursor_on.below[4].xyz.replace[.0].with[]>"
          - case right:
            - execute as_op "/pos2 <player.cursor_on.above[6].xyz.replace[.0].with[]>"
            - foreach <list[stone]> as:BaseBlock:
              - foreach <player.we_selection.blocks.filter[material.name.is[==].to[<[BaseBlock]>]]> as:block:
                - if <server.flag[GielinorDevelopment.StonePather].contains[<[Block].above[1]>]>:
                  - foreach next
                - modifyblock <[Block]> air
                - if !<list[Iron_Block|Red_Wool].contains[<[Block].below[1].material.name>]>:
                  - modifyblock <[Block].below[1]> stone
                  - flag server GielinorDevelopment.StonePather:->:<[Block]>
              
                - define wait:++
                - if <[wait].mod[100]> == 0:
                  - wait 1t
            - execute as_op "/replace stone 1<&pc>Cobblestone_Stairs[facing=north,shape=inner_left],1<&pc>Cobblestone_Stairs[facing=north,shape=inner_left],1<&pc>Cobblestone_Stairs[facing=south,shape=inner_left],1<&pc>Cobblestone_Stairs[facing=south,shape=inner_left],1<&pc>mossy_Cobblestone_Stairs[facing=east,shape=inner_right],1<&pc>mossy_Cobblestone_Stairs[facing=east,shape=inner_right],1<&pc>mossy_Cobblestone_Stairs[facing=west,shape=inner_right],1<&pc>mossy_Cobblestone_Stairs[facing=west,shape=inner_right],1<&pc>Cobblestone_Slab,11<&pc>coarse_dirt,15<&pc>cracked_stone_bricks,12<&pc>cobblestone,12<&pc>mossy_cobblestone,41<&pc>stone"


      #- Used for fanning iron blocks gravitated down to replace
      - case SkeletonFixCuboid:
        - if <player.flag[GielinorDevelopment.AxeMode]> != SkeletonFixCuboid:
          - flag player GielinorDevelopment.AxeMode:SkeletonFixCuboid
          - narrate "<&e>Axe Mode Set<&6>: <&a>SkeletonFixCuboid"
          - execute as_op "/sel cuboid"
          - stop
        - if <context.args.size> == 1:
          - narrate "<&c>Axe Mode Currently Set."
          - stop
        - choose <context.args.get[2]>:
          - case left:
            - execute as_op "/pos1 <player.cursor_on.below[4].xyz.replace[.0].with[]>"
          - case right:
            - execute as_op "/pos2 <player.cursor_on.above[6].xyz.replace[.0].with[]>"
            - foreach <list[red_wool|stone|iron_block]> as:BaseBlock:
              - foreach <player.we_selection.blocks.filter[material.name.is[==].to[<[BaseBlock]>]]> as:block:
                - define wait:++
                - define d:0
                - repeat 3:
                  - if <list[fern|grass].contains[<[Block].below[<[d]>].material.name>]>:
                    - modifyblock <[Block].below[<[d]>]> <[BaseBlock]>
                    - modifyblock <[Block]> air
                    - foreach next
                  - if <list[large_fern|tall_grass].contains[<[Block].below[<[d]>].material.name>]>:
                    - modifyblock <[Block].below[<[d].add[1]>]> <[BaseBlock]>
                    - modifyblock <cuboid[<[Block]>|<[Block].below[<[d].sub[1]>]>]> air
                    - foreach next
                  - define d:++
                - if <[wait].mod[100]> == 0:
                  - wait 1t
      - case SkeletonFixSphere:
        - if <player.flag[GielinorDevelopment.AxeMode]> != SkeletonFixSphere:
          - flag player GielinorDevelopment.AxeMode:SkeletonFixSphere
          - narrate "<&e>Axe Mode Set<&6>: <&a>SkeletonFixSphere"
          - execute as_op "/sel sphere"
          - stop
        - if <context.args.size> == 1:
          - narrate "<&c>Axe Mode Currently Set."
          - stop

        - choose <context.args.get[2]>:
          - case left:
            - define Size 5
          - case right:
            - define Size 10

        - execute as_op "/pos1 <player.cursor_on.xyz.replace[.0].with[]>"
        - execute as_op "/pos2 <player.cursor_on.left[<[Size]>].xyz.replace[.0].with[]>"
        - foreach <list[red_wool|stone|iron_block|brown_wool]> as:BaseBlock:
          - foreach <player.we_selection.blocks.filter[material.name.is[==].to[<[BaseBlock]>]]> as:block:
            - define wait:++
            - define d:0
            - repeat 3:
              - if <list[fern|grass].contains[<[Block].below[<[d]>].material.name>]>:
                - modifyblock <[Block].below[<[d]>]> <[BaseBlock]>
                - modifyblock <[Block]> air
                - foreach next
              - if <list[large_fern|tall_grass].contains[<[Block].below[<[d]>].material.name>]>:
                - modifyblock <[Block].below[<[d].add[1]>]> <[BaseBlock]>
                - modifyblock <cuboid[<[Block]>|<[Block].below[<[d].sub[1]>]>]> air
                - foreach next
              - define d:++
            - if <[wait].mod[100]> == 0:
              - wait 1t
      #- Used for copying over worlds inline from other worlds from worldpainter
      - case Replicate:
        - if !<player.has_flag[GielinorDevelopment.AxeMode]> || <player.flag[GielinorDevelopment.AxeMode]> != Replicate:
          - flag player GielinorDevelopment.AxeMode:Replicate
          - narrate "<&e>Axe Mode Set<&6>: <&a>Replicate"
          - stop
        - if <context.args.size> == 1:
          - narrate "<&c>Axe Mode Currently Set."
          - stop

        - define world DeepOcean
        - if <player.is_sneaking>:
          - define world Ocean
        - choose <context.args.get[2]>:
          - case left:
            #- left clicking will replicate this one chunk from the world.
            - define Loc1 <player.cursor_on.chunk.cuboid.with_world[<[World]>]>
            - define Loc2 <player.cursor_on.with_world[<[World]>]>
            - define Loc3 <player.cursor_on>
            - define uuid <util.random.uuid>
            - schematic create name:<[uuid]> <[Loc1]> o:<[Loc2]>
            - wait 3t
            - schematic paste name:<[uuid]> o:<[Loc3]> noair
            - schematic paste name:<[uuid]> o:<[Loc3].above[8]> noair
            - wait 3t
            - schematic unload name:<[uuid]>
          - case right:
            - if <player.we_selection||null> == null:
              - narrate "<&c>No Selection Made."
              - stop
            #- right clicking will cycle betweene very chunk in contained in the selection
            - define MaxCount <player.we_selection.list_partial_chunks.size>
            - foreach <player.we_selection.list_partial_chunks> as:Chunk:
              - define Center <[Chunk].cuboid.center>
              - define Loc1 <[Center].chunk.cuboid.with_world[<[World]>]>
              - define Loc2 <[Center].with_world[<[World]>]>
              - define Loc3 <[Center]>
              - define uuid <util.random.uuid>
              - schematic create name:<[uuid]> <[Loc1]> o:<[Loc2]>
              - wait 1t
              #- schematic paste name:<[uuid]> o:<[Loc3]> noair
              - schematic paste name:<[uuid]> o:<[Loc3].above[8]> noair
              #- waituntil rate:5t <server.recent_tps.first> > 17
              - schematic unload name:<[uuid]>
              - announce to_console "<&a><[Loop_Index]>/<[MaxCount]> Complete"

      - case TeleOver:
        - define world Ocean
        - if <player.world.name> == <[World]>:
          - teleport <player> <player.location.with_world[Runescape50px1]>
        - else if <player.world.name> == Runescape50px1:
          - teleport <player> <player.location.with_world[<[World]>]>

    

  CuboidSelection:
    - flag player GielinorDevelopment.SelectionQueue:<queue.id> duration:10m
    - define Loc <player.cursor_on>
    - define ClickType <context.args.get[2]>
    - inject SelectionDisplay
    - while <player.has_flag[GielinorDevelopment.Selection]> && <player.flag[GielinorDevelopment.SelectionQueue]> == <queue.id>:
      - playeffect effect:barrier at:<[Selection].outline.parse[center]> offset:0 visibility:100
      #&& !<player.is_sneaking>
      #targets:<player>
      - wait 3s

TempWand1Hanf:
  type: world
  debug: false
  debug: false
  events:
    on player right clicks block with:TempWand1 bukkit_priority:lowest:
      - determine passively cancelled
      - execute as_player "test <player.flag[GielinorDevelopment.AxeMode]> right"
    on player left clicks block with:TempWand1 bukkit_priority:lowest:
      - determine passively cancelled
      - execute as_player "test <player.flag[GielinorDevelopment.AxeMode]> left"


onetimebiome:
  type: task
  debug: false
  script:
    - define Sel <player.we_selection>
    - define Biomes <server.biome_types.parse[name]>
    - foreach <[Sel].blocks.filter[material.name.is[==].to[chiseled_stone_bricks]]> as:StartLoc:
      - define i:++
      - if <[i]> == <[Biomes].size>:
        - stop
      - define Biome <[Biomes].get[<[i]>]>
      - modifyblock <[StartLoc]> spruce_fence
      - modifyblock <[StartLoc].above[1]> oak_sign[direction=SOUTH]
      - adjust <[StartLoc].above[1]> sign_contents:<list[<empty>|<[Biome]>]>
      - modifyblock <[StartLoc].above[2]> lantern
      - define Cuboid <cuboid[<[StartLoc].below[1]>|<[StartLoc].sub[10,1,-8]>]>

      - foreach <[Cuboid].blocks> as:Loc:
        - adjust <[Loc]> biome:<[Biome]>
      - announce to_console "<&6><[Biome]> <&e>Set | <&a><[i]> <&3>/ <&a><[Biomes].size>"
      - wait 2t


CastleWarsPortals:
  type: task
  debug: false
  definitions: Team
  script:
    - define zOffset 1
    - define yOffset 0
    - Choose <[Team]>:
      - case red:
        - define Loc <location[886,76,1842,Runescape50px1]>
        - define color <color[<util.random.int[200].to[255]>,0,0]>
      - case green:
        - define Loc <location[886,76,1828,Runescape50px1]>
        - define color <color[0,<util.random.int[200].to[255]>,0]>
      - case blue:
        - define Loc <location[886,76,1814,Runescape50px1]>
        - define color <color[0,0,<util.random.int[200].to[255]>]>
    - repeat 360:
      - if !<server.has_flag[Behrry.Event.CastleWars.EntranceLit]>:
        - stop
      - wait 2t
      - if <[Value].mod[50]> == 0:
        - define zOffset:+:0.15
        - define yOffset:+:0.1
      - define Offset <location[0,<[yOffset]>,<[zOffset]>].rotate_around_y[<[value].to_radians.mul[7.5]>]>
      - playeffect effect:redstone at:<[Loc].add[<[Offset]>]> offset:0.0 special_data:1.5|<[Color]> visibility:50

CastleWars_Handler:
  type: data
  debug: false
  events:
    on player enters CastleWarsVarrockPortal:
      - if <server.has_flag[Behrry.Event.CastleWars.WaitQueue]>:
        - playsound sound:BLOCK_BEACON_ACTIVATE <player>
        - teleport <player> <cuboid[<location[813,21,1798,Runescape50px1]>|<location[808,22,1802,Runescape50px1]>].blocks.random>
    on player enters CastleWarsGuthixPortal:
      - if <server.has_flag[Behrry.Event.CastleWars.WaitQueue]>:
        - playsound sound:BLOCK_BEACON_ACTIVATE <player>
        - teleport <player> <cuboid[<location[813,21,1798,Runescape50px1]>|<location[808,22,1802,Runescape50px1]>].blocks.random>
    on player enters CastleWarsSaradominPortal:
      - if <server.has_flag[Behrry.Event.CastleWars.WaitQueue]>:
        - playsound sound:BLOCK_BEACON_ACTIVATE <player>
        - teleport <player> <cuboid[<location[813,21,1798,Runescape50px1]>|<location[808,22,1802,Runescape50px1]>].blocks.random>
    on player enters CastleWarsEntrance:
      - wait 1t
      - if !<server.has_flag[Behrry.Event.CastleWars.EntranceLit]>:
        - flag server Behrry.Event.CastleWars.EntranceLit
        - while <server.has_flag[Behrry.Event.CastleWars.EntranceLit]> && <cuboid[CastleWarsEntrance].players.size> > 0:
          - foreach <list[red|green|blue]> as:Team:
            - run CastleWarsPortals def:<[Team]>
          - wait 3s
    on player exits CastleWarsEntrance:
      - flag server Behrry.Event.CastleWars.EntranceLit:!
    on player clicks block with:diamond_axe bukkit_priority:lowest in:Runescape50px1:
      - flag player GielinorDevelopment.SelectionQueue:<queue.id> duration:10m
      - if <player.we_selection||null> != null:
        - if <player.is_sneaking>:
          - if <queue.exists[<player.flag[GielinorDevelopment.SelectionQueue]||null>]>:
            - queue <player.flag[GielinorDevelopment.SelectionQueue].as_queue||null> clear
            - narrate "<&a>Cleared Particle Display"
            - stop
        - while <player.we_selection||null> != null && <player.flag[GielinorDevelopment.SelectionQueue]||null> == <queue.id>:
          - playeffect at:<player.we_selection.outline.parse[center]> effect:barrier visibility:100 offset:0
          #- playeffect at:<player.we_selection.outline.parse[center]> effect:barrier visibility:100 offset:0
          - wait 3s
