CastleWars_NotableLocations:
  type: data
  Hub:
    Blue:
      FlagDir: NORTH_West
      FlagLoc: <location[808,169,59,Hub]>
    Red:
      FlagDir: SOUTH_EAST
      FlagLoc: <location[691,169,-58,Hub]>

  Real:
    Blue:
      FlagLoc: <location[870,93,1858,Runescape50px1]>
    Red:
      FlagLoc: <location[753,93,1741,Runescape50px1]>

FlagSpawn_Event:
  type: task
  definitions: Team
  debug: false
  script:
    - choose <[Team]>:
      - case blue:
        - define Dir NORTH_West
        - define Loc <location[870,93,1858,Runescape50px1]>
        - define OpTeamFlag <server.flag[Behrry.Event.CastleWars.SaradominFlag].as_item>
      - case red:
        - define Dir SOUTH_EAST
        - define Loc <location[753,93,1741,Runescape50px1]>
        - define OpTeamFlag <server.flag[Behrry.Event.CastleWars.ZamorakianFlag].as_item>
      - default:
        - stop
    - flag player Behrry.Event.CastleWars.FlagHolder:!
    - define cLoc <[Loc].center.below[1.5]>
    - define Density 8
    - repeat <element[650].div[<[Density]>]>:
      - define Radius <[value].power[1.1].div[90]>
      - define yOffset <[value].div[20]>
      - define ySpiral <[value].to_radians.mul[<[Density]>]>
      - playeffect at:<[cLoc].add[<location[<[Radius]>,<[yOffset]>,0].rotate_around_y[<[ySpiral]>]>]> effect:redstone special_data:1.2|<[Team]> visibility:250 offset:0
      - playeffect at:<[cLoc].add[<location[-<[Radius]>,<[yOffset]>,0].rotate_around_y[<[ySpiral]>]>]> effect:redstone special_data:1.2|<[Team]> visibility:250 offset:0
      - playeffect at:<[cLoc].add[<location[0,<[yOffset]>,-<[Radius]>].rotate_around_y[<[ySpiral]>]>]> effect:redstone special_data:1.2|<[Team]> visibility:250 offset:0
      - playeffect at:<[cLoc].add[<location[0,<[yOffset]>,<[Radius]>].rotate_around_y[<[ySpiral]>]>]> effect:redstone special_data:1.2|<[Team]> visibility:250 offset:0
      - if <[value].mod[15]> == 0:
        - playeffect at:<[cLoc].add[<location[0,<[yOffset]>,<[Radius].mul[2]>].rotate_around_y[<[ySpiral]>]>]> effect:crit visibility:250 offset:0.5 quantity:2
        - playeffect at:<[cLoc].add[<location[<[Radius].mul[-2]>,<[yOffset]>,0].rotate_around_y[<[ySpiral]>]>]> effect:crit visibility:250 offset:0.5 quantity:2
        - playeffect at:<[cLoc].add[<location[0,<[yOffset]>,<[Radius].mul[-2]>].rotate_around_y[<[ySpiral]>]>]> effect:crit visibility:250 offset:0.5 quantity:2
        - playeffect at:<[cLoc].add[<location[0,<[yOffset]>,<[Radius].mul[2]>].rotate_around_y[<[ySpiral]>]>]> effect:crit visibility:250 offset:0.5 quantity:2
        - playsound <[Loc]> ENTITY_PHANTOM_FLAP volume:2
        - wait 1t

    - modifyblock <[Loc]> <[Team]>_banner[direction=<[Dir]>]
    - adjust <[Loc]> patterns:<[OpTeamFlag].patterns>


FlagGrab_Event:
  type: task
  #- Definition is the Team Taking The Flag
  definitions: team
  debug: false
  script:
    #@ Define Main Definitions
    - choose <[Team]>:
      - case Red:
        - define OpTeam Blue
        - define OpTeamFlag <server.flag[Behrry.Event.CastleWars.SaradominFlag].as_item>
        - define Loc <location[870,93,1858,Runescape50px1]>
        - define Offset <location[0.299,-1.699,0.3,0,137,Runescape50px1]>
      - case Blue:
        - define OpTeam Red
        - define OpTeamFlag <server.flag[Behrry.Event.CastleWars.ZamorakianFlag].as_item>
        - define Loc <location[753,93,1741,Runescape50px1]>
        - define Offset <location[0,0,0,Runescape50px1]>
      - default:
        - stop

    #@ Adjust Player
    - modifyblock <[Loc]> air
    - spawn armor_stand[equipment=air|air|air|<[OpTeamFlag]>;visible=false] <[Loc].add[<[Offset]>].with_yaw[137]> save:FlagAnimation
    - define FlagEntity <entry[FlagAnimation].spawned_entity>
    - repeat 10:
      - if <player.location.yaw.sub[<[FlagEntity].location.yaw>]> > 180:
        - rotate <[FlagEntity]> d:1t yaw:<[FlagEntity].location.yaw.sub[<player.location.yaw>].div[10]>
      - else:
        - rotate <[FlagEntity]> d:1t yaw:<player.location.yaw.sub[<[FlagEntity].location.yaw>].div[10]>
      - define Step <[Loc].below[1].points_between[<player.location>].distance[<[Loc].below[1].points_between[<player.location>].distance[0.1].size.div[100]>].get[<[value]>]>
      - playeffect at:<[FlagEntity].location.above[1.8]> effect:redstone special_data:1.2|<[OpTeam]> visibility:250 offset:0.1 quantity:10
      - playeffect at:<[Step].above[3.5]> effect:redstone special_data:1.2|<[OpTeam]> visibility:250 offset:0.1 quantity:10

      - wait 1t
      - adjust <[FlagEntity]> move:<[Step].sub[<[FlagEntity].location>]>
    - equip <player> head:<[OpTeamFlag]>
    - flag player Behrry.Event.CastleWars.FlagHolder
    - wait 2t
    - remove <entry[FlagAnimation].spawned_entity>

    #@ Play Effects While Flagholder
    - while <player.has_flag[Behrry.Event.CastleWars.FlagHolder]> && <player.is_online> && !<player.is_sneaking>:
      - define Pitch <player.location.pitch.to_radians>
      - define Yaw <player.location.yaw.mul[-1].to_radians>
      - define ySpiral <[Loop_Index].to_radians.mul[8]>
      - define DirRotate <location[0,1.75,0].rotate_around_x[<[Pitch]>].rotate_around_y[<[Yaw]>]>

      - playeffect at:<player.eye_location.above[0.1].add[<[DirRotate]>].add[<location[0.25,0,0,world].rotate_around_y[<[ySpiral]>]>]> effect:redstone special_data:1.2|<[OpTeam]> visibility:250 offset:0.0 quantity:0
      - playeffect at:<player.eye_location.above[0.1].add[<[DirRotate]>].add[<location[-0.25,0,0,world].rotate_around_y[<[ySpiral]>]>]> effect:redstone special_data:1.2|<[OpTeam]> visibility:250 offset:0.0 quantity:0
      ##- playeffect offset:0.0 quantity:0 at:<player.location.above[3.25].add[<location[0.25,0,0,world].rotate_around_y[<[ySpiral]>]>]> effect:redstone special_data:1.2|<[OpTeam]> visibility:250
      ##- playeffect offset:0.0 quantity:0 at:<player.location.above[3.25].add[<location[-0.25,0,0,world].rotate_around_y[<[ySpiral]>]>]> effect:redstone special_data:1.2|<[OpTeam]> visibility:250
      
      - playeffect at:<player.location.above[17].add[<location[0.25,0,0,world].rotate_around_y[<[ySpiral]>]>]> effect:redstone special_data:1.2|<[OpTeam]> visibility:250 offset:0.0 quantity:0
      - playeffect at:<player.location.above[17].add[<location[-0.25,0,0,world].rotate_around_y[<[ySpiral]>]>]> effect:redstone special_data:1.2|<[OpTeam]> visibility:250 offset:0.0 quantity:0

      - wait 1t
    
    #@ Re-Adjust Player
    - run FlagSpawn_Event def:<[OpTeam]>
    - equip <player> head:air

Event_Timer:
  type: task
  script:



CastleWars_Event:
  type: task
  debug: false
  script:
    - while <server.has_flag[Behrry.Event.CastleWars.Status]>
    - Choose <[Behrry.Event.CastleWars.Status]>:
      - case Starting:
        - define Hover "click to join game"
        - define Text "[chek]"
        - define Command "event join"
        - define Accept <proc[CmdMsg].context[<[Hover]>|<[Text]>|<[Command]>]>
        - narrate "<[Accept]> <&b>| game starting aa errbody join"
      - case Queuing:
      - case Running:
      - case Pause:
        - if !<server.has_flag[Behrry.Event.CastleWars.PauseNotice]>:
          - flag server Behrry.Event.CastleWars.PauseNotice duration:30m
          - announce "<&c>Castle Wars Game Paused."
        - define Blep <element[*].repeat[<[Loop_Index].mod[4].add[1]>]>
        - actionbar "<&a><[Blep]><&e>Game Paused<&a><[Blep]>"
        - wait 1s
      - case Stop:
        - announce "<&c>Castle Wars Game was stopped."


Event_Commandy:
  type: command
  name: eventy
  usage: /event <&gt>>EventName<&lt> (Queue/Pause/Stop/Manage (AddTime/SlowTime/Settings))
  description: Manages Event Queues.
  tab complete:
    - define SubCommands <list[Queue|Pause|Stop]>
    - define Events <server.scripts.filter[ends_with[Event]]>
    - if <context.args.size> == 0:
      - determine <[SubCommands]>
    - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
      - determine <[SubCommands].filter[starts_with[<context.args.last>]]>
    - if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
      - choose <context.args.first>:
        - case Queue:
          - determine <[Events]>
        - case Pause Stop:
          - if <server.has_flag[Behrry.Event.ActiveEvents]>:
            - determine <server.flag[Behrry.Event.ActiveEvents]>
    - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
      - choose <context.args.first>:
        - case Queue:
          - determine <[Events]>
        - case Pause Stop:
          - if <server.has_flag[Behrry.Event.ActiveEvents]>:
            - determine <server.flag[Behrry.Event.ActiveEvents]>
  script:
    #@ Verify Args
    - if <context.args.size> != 2:
      - inject Command_Syntax Instantly
    
    - define Event <context.args.first>
    - define Command <context.args.get[2]>
    
    #@ Determine Arg
    - choose <[Command]>:
      - case Queue:
        - if !<server.has_flag[Behrry.Event.ActiveEvents]>:
          - flag server Behrry.Event.ActiveEvents:|:<emtpy>
        - if <server.flag[Behrry.Event.ActiveEvents].contains[<[Event]>]>:
          - narrate format:Colorize_Red "Event already Queued."
          - stop
        - flag server Behrry.Event.ActiveEvents:->:CastleWars
        - flag server Behrry.Event.<[Event]>.Status:Starting
        - ~run CastleWars_Event
        - flag server Behrry.Event.ActiveEvents:<-:CastleWars
        - flag server Behrry.Event.<[Event]>.Status:!
      - case Pause Stop:
        - flag server Behrry.Event.<[Event]>.Status:<[Command]>
      - case Manage:
        - narrate "hello"
      - default:
        - narrate "<proc[Colorize_Red].context[|red]>"





throwtestthandler:
  type: data
  debug: false
  events:
    on player clicks air with teststck:
      - define location <player.location.above[1]>
      - define vector <[location].direction.vector.above[0.25].div[1.25]>

      - define Step <[location]>
      - define Loc <[Step].add[<[vector]>]>
      - while <list[Air|Void_Air].contains[<[Step].material.name>]>:
          - playeffect effect:flame at:<[Step]> offset:0 visibility:150

          - define Loc <[Loc].add[<[vector]>]>
          - define Slope <[Loop_Index].div[8].power[1.6]>
          - define Step <[Loc].below[<[Slope]>]>
          - if <[Loop_Index].mod[4]> == 0:
              - wait 1t
    on player shoots teststck2:
      - while <server.entity_is_spawned[<context.projectile>]>:
        - define StartLoc <player.location.above[1]>
        - define LastLoc <context.projectile.location>
        - foreach <[StartLoc].points_between[<[LastLoc]>].distance[0.25]> as:Loc:
          - playeffect effect:crit at:<[Loc]> offset:0.0
        - if <context.projectile.is_on_ground>:
          - while stop
        - wait 1t

        
      
teststck2:
  type: item
  material: bow

  
#Script: 1.0.0
#Author: Icecapade
#Date 2020-05-12

BehrsPreChunker:
  type: command
  debug: false
  name: behrprechunk
  description: Pregenerate your world around you
  usage: /behrprechunk [Chunks]
  permission: test
  script:
    - if <player.name.contains[behr_riley]>:
      - define x <player.location.chunk.x>
      - define y <player.location.chunk.z>
      - define World <player.world>

      #- define Diff <element[14].add[<[ChunkRadius].sub[2].mul[8]>]>
      - define ChunkRadius <context.args.first>
      - repeat <[ChunkRadius]>:
        - define TotalChunks:+:<[Value].mul[4].sub[2].add[<[Value].mul[4]>]>

      - define StringLength <[TotalChunks].length>

      #- if <server.has_flag[Behrry.Chunkload.<[World]>.Progress]>:
      #  - define run <server.flag[Behrry.Chunkload.<[World]>.Progress].first>
      #  - define x <server.flag[Behrry.Chunkload.<[World]>.Progress].get[2]>
      #  - define y <server.flag[Behrry.Chunkload.<[World]>.Progress].get[3]>
      #- else:
      #  - define run 1
      - define run 1

      - repeat <[ChunkRadius]>:
        - flag server Behrry.Chunkload.<[World]>.MaxDepth:<server.flag[Behrry.Chunkload.<[World]>.MaxDepth].max[<[ChunkRadius]>]||<[ChunkRadius]>>
        - repeat <[run]>:
          - define x:--
          - inject locally Chonk
        - repeat <[Run]>:
          - define y:--
          - inject locally Chonk
        - define Run:+:1

        - repeat <[Run]>:
          - define x:++
          - inject locally Chonk
        - repeat <[Run]>:
          - define y:++
          - inject locally Chonk
        - define Run:+:1
  Chonk:
    - define CurrentChunk:++
    - if !<server.flag[Behrry.Chunkload.<[World]>.chunksloaded].contains[<chunk[<[X]>,<[Y]>,<[World]>]>]||false>:
      - Chunkload <chunk[<[X]>,<[Y]>,<[World]>]> duration:1t
      - flag server Behrry.Chunkload.<[World]>.chunksloaded:->:<chunk[<[X]>,<[Y]>,<[World]>]>
      - if <[CurrentChunk].is_even>:
        - wait 1t

    - if <[CurrentChunk].mod[100]> == 0:
      - announce to_console "<&b>C<&3>hunk<&b>L<&3>oad <&b>S<&3>tatus<&b>: <&6>[<&a><[CurrentChunk].pad_left[<[StringLength]>].with[Q].replace[Q].with[<&8>0<&a>]><&e>/<&a><[TotalChunks]><&6>] <&b>| <&6>[<&a><element[<[CurrentChunk]>].div[<[TotalChunks]>].mul[100].format_number[00.00]><&e><&pc><&6>]"
      - define Estimation <duration[<queue.time_ran.in_ticks.mul[<element[1].sub[<[CurrentChunk].div[<[TotalChunks]>]>]>]>].formatted>
      - announce to_console "<&e>Estimated Time Left: <&a><[Estimation]>"
    - flag server Behrry.Chunkload.<[World]>.Progress:!|:<[Run]>|<[x]>|<[y]>

    - waituntil rate:5t <server.recent_tps.first> > 17
        
itemscript:
  type: item
  material: potion
  mechanism:
    color: 0,0,0

IcecapadePreChunk:
    type: command
    debug: false
    name: prechunk
    description: Pre generate your world!
    usage: /prechunk [size] [world]
    permission: test
    permission message: <&3>You need the permission <&b><permission> <&3>to use that command!
    tab complete:
    - if <context.args.is_empty>:
        - determine <list[16|32|64|128|256]>
    - else if <context.args.size> == 1 && "!<context.raw_args.ends_with[ ]>":
        - determine <list[16|32|64|128|256].filter[starts_with[<context.args.first>]]>
    - else if <context.args.size> < 2:
        - determine <server.worlds.parse[name]>
    - else if <context.args.size> == 2 && "!<context.raw_args.ends_with[ ]>":
        - determine <server.worlds.parse[name].filter[starts_with[<context.args.last>]]>
    script:
    - if <context.args.size> == 2 && <context.args.first.is_integer> && <context.args.first> >= 4 && <server.worlds.parse[name].contains[<context.args.last>]>:
        - narrate "<&3>[PreChunk] Generation started! See console for information."
        - define world <context.args.get[2]>
        #- define X <context.args.first.mul[-1]>
        #- define Y <context.args.first.mul[-1]>
        - define X <player.location.chunk.x>
        - define Y <player.location.chunk.z>
        - define loops <[X].mul[-2].abs>
        - repeat <[loops]>:
            - chunkload <chunk[<[X]>,<[Y]>,<[world]>]> d:1t
            - repeat <[loops]>:
                - chunkload <chunk[<[X]>,<[Y]>,<[world]>]> d:1t
                - announce to_console <[X]>/<[Y]>
                - define Y:++
                - waituntil rate:5t <server.recent_tps.first> > 15
                #Change the wait time, if you're receiving much lag. Good waiting period would be 5t or 10t. NEVER set to 0t.
                - wait 1t
            - define X:++
            - define Y <context.args.first.mul[-1]>
            - define a:++
            - announce to_console "<[a]>/<[loops]> rows loaded!"
        - announce to_console "<&3>[PreChunk] Generation finished in <queue.time_ran.formatted>! Have a good day!"
    - else:
        - narrate "<&3>[PreChunk] Usage: <&7>/prechunk [size] [world] <&nl><&3>The size is measured in chunks. A size of 64 would be a map with 128x128 Chunks. (2048x2048 blocks)."

