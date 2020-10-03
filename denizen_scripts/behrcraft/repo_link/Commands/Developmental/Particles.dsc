RuntimeScript:
    type: task
    debug: false
    script:
        - if <server.has_flag[Behrry.Development.RunTimeTest]>:
            - if <queue.exists[<server.flag[Behrry.Development.RunTimeTest]||null>]>:
                - queue <server.flag[Behrry.Development.RunTimeTest].as_queue> clear
            - flag server Behrry.Development.RunTimeTest:!
        - flag server Behrry.Development.RunTimeTest:<queue.id>

        - while <player.is_online> && <server.has_flag[Behrry.Development.RunTimeTest]>:
            #- run Particle2 def:<npc[189]>
            - run hyporadiusParticle2 Def:<npc[242]>
            - wait 1s
ObsticleManagement:
    type: data
    debug: true
    events:
        on player right clicks dark_oak_button in:ParticleRunTimeTestButton:
            - if <server.has_flag[Behrry.Development.RunTimeTest]>:
                - if <queue.exists[<server.flag[Behrry.Development.RunTimeTest]||null>]>:
                    - queue <server.flag[Behrry.Development.RunTimeTest].as_queue> clear
                - flag server Behrry.Development.RunTimeTest:!
                - narrate "<&c>Stopping"
                - reload
                - stop
            - else:
                - narrate "<&a>Starting"
                - run RunTimeScript
        on player right clicks dark_oak_button in:ParticleTestingButtons:
            - define X <context.location.x>
            - choose <[X]>:
                - case 277:
                    - define DLocs <util.list_numbers_to[5].parse[add[718]]>
                - case 282:
                    - define DLocs <util.list_numbers_to[5].parse[add[718]]>
                - case 287:
                    - define DLocs <util.list_numbers_to[5].parse[add[718]]>
                - default:
                    - stop

            - choose <context.location.z.round_up>:
                - case 715:
                    - define ObstacleType 5Players
                - case 716:
                    - define ObstacleType 1Player
                - case 717:
                    - define ObstacleType Wall
                - default:
                    - stop

            - inject locally Clear Instantly
            - choose <[ObstacleType]>:
                - case 5Players:
                    - repeat 5:
                        - narrate format:colorize_green "Player Obstacles at <[X]> mark added."
                        - create Test<[Value]> Player <location[<[X]>,150,<[DLocs].get[<[Value]>]>,Hub].add[0.5,1,0.5]> save:Npc
                        - flag server Behrry.Development.NpcTestList<[X]>:->:<entry[Npc].created_npc.id>
                        - adjust <entry[Npc].created_npc> skin_blob:<server.flag[Behrry.Meeseeks.Skin.Tester]>

                - case 1Player:
                    - create Test Player <location[<[X]>,150,<[DLocs].last>,Hub].add[0.5,1,0.5]> save:Npc
                    - flag server Behrry.Development.NpcTestList<[X]>:->:<entry[Npc].created_npc.id>
                    - narrate format:colorize_green "Player Obstacle at <[X]> mark added."
                    - adjust <entry[Npc].created_npc> skin_blob:<server.flag[Behrry.Meeseeks.Skin.Tester]>

                - case Wall:
                    - flag server Behrry.Development.ParticleWallObstacle<[X]>
                    - modifyblock <[Loc]> Quartz_Block
                    - narrate format:colorize_green "Wall Obstacle at <[X]> mark created."
    Clear:
        - define Loc <cuboid[<location[<[X]>,151,<[DLocs].last>,Hub]>|<location[<[X]>,152,<[DLocs].last>,Hub]>]>
        - if <server.has_flag[Behrry.Development.ParticleWallObstacle<[X]>]>:
            - narrate format:colorize_green "Wall Obstacle at <[X]> mark removed."
            - flag server Behrry.Development.ParticleWallObstacle<[X]>:!
            - modifyblock <[Loc]> air
            - stop

        - else if <server.has_flag[Behrry.Development.NpcTestList<[X]>]>:
            - narrate format:colorize_green "Player Obstacles at <[X]> mark removed."
            - foreach <server.flag[Behrry.Development.NpcTestList<[X]>]> as:NPC:
                - flag server Behrry.Development.NpcTestList<[X]>:<-:<[NPC]>
                - remove <npc[<[NPC]>]>
            - stop

Particle1:
    type: task
    debug: false
    script:
        - define Player <npc[189]>
        - define TargetLoc <location[295.5,152.5,723.5,Hub]>

        - define Path <[Player].location.add[0,1.5,0].points_between[<[TargetLoc]>].distance[0.1]>
        
        - look <[Player]> <[TargetLoc]> duration:2s
        - animate <[Player]> animation:<list[ARM_SWING|ARM_SWING_OFFHAND].random>

        - foreach <[Path]> as:Loc:
            - if <[Loc].material.is_solid>:
                - foreach stop
            - if !<[Loc].add[0.1,0.1,0.1].to_cuboid[<[Loc].sub[0.1,1,0.1]>].entities.exclude[<[Player]>].is_empty>:
                - ActionBar "<&6>Entity Struck!<&e>: <&2><[Loc].add[0.1,0.1,0.1].to_cuboid[<[Loc].sub[0.1,1,0.1]>].entities.exclude[<[Player]>].parse[name].comma_separated>" targets:<[Player].location.find.players.within[50]>
                - foreach stop
            - playeffect effect:CLOUD at:<[Loc]> quantity:1 data:0.1 offset:0.0 visibility:100 special_data:2.5|black
            - playeffect effect:REDSTONE at:<[Loc]> quantity:1 data:0.2 offset:0.1 visibility:100 special_data:2.5|black
            - playeffect effect:REDSTONE at:<[Loc]> quantity:1 data:0.2 offset:0.1 visibility:100 special_data:2.5|purple
            - if <[Loop_Index].mod[75]> == 0:
                - wait 1t
        - repeat 3:
            - playeffect effect:EXPLOSION_LARGE at:<[Loc]> visibility:100 quantity:3 offset:1
            - wait 2t
Particle1a:
    #- trying to fixate the Y to pass to Particle1B
    type: task
    debug: false
    script:
        - define player <npc[242]>
        - define Loc <[Player].eye_location>

        - define TargetLoc <[Player].location.forward[20]>
        - define Distance <[Player].location.distance[<[TargetLoc]>]>
        - define MaxHeight 3

        - while <[Loc].material.name> == air:
            - if <[Loop_Index]> > <[Distance]>:
                - define y <[Loop_Index].div[<[Distance].add[<[Loop_Index]>]>]>
            - else:
                - define y -<[Loop_Index].div[<[Distance].add[<[Loop_Index]>]>]>
            - define Loc <[Loc].forward[1].up[<[y]>]>
            - playeffect effect:REDSTONE at:<[Loc]> quantity:1 data:0.2 offset:0.1 visibility:100 special_data:2.5|black

            - if <[Loop_Index].mod[10]> == 0:
                - wait 1t

        #^- define Player <npc[242]>
        #^- define TargetLoc <location[295.5,152.5,723.5,Hub]>
        #^
        #^- define Path <[Player].location.add[0,1.5,0].points_between[<[TargetLoc]>].distance[0.1]>
        #^
        #^- look <[Player]> <[TargetLoc]> duration:2s
        #^- animate <[Player]> animation:<list[ARM_SWING|ARM_SWING_OFFHAND].random>
        #^
        #^- foreach <[Path]> as:Loc:
        #^    - if <[Loc].material.is_solid>:
        #^        - foreach stop
        #^    - if !<cuboid[<[Loc].add[0.1,0.1,0.1]>|<[Loc].sub[0.1,1,0.1]>].entities.exclude[<[Player]>].is_empty>:
        #^        - ActionBar "<&6>Entity Struck!<&e>: <&2><cuboid[<[Loc].add[0.1,0.1,0.1]>|<[Loc].sub[0.1,1,0.1]>].entities.exclude[<[Player]>].parse[name].comma_separated>" targets:<[Player].location.find.players.within[50]>
        #^        - foreach stop
        #^    - playeffect effect:CLOUD at:<[Loc]> quantity:1 data:0.1 offset:0.0 visibility:100 special_data:2.5|black
        #^    - playeffect effect:REDSTONE at:<[Loc]> quantity:1 data:0.2 offset:0.1 visibility:100 special_data:2.5|black
        #^    - playeffect effect:REDSTONE at:<[Loc]> quantity:1 data:0.2 offset:0.1 visibility:100 special_data:2.5|purple
        #^    - if <[Loop_Index].mod[75]> == 0:
        #^        - wait 1t
        #^- repeat 3:
        #^    - playeffect effect:EXPLOSION_LARGE at:<[Loc]> visibility:100 quantity:3 offset:1
        #^    - wait 2t
Particle1b:
    #- does 1 but spiral
    type: task
    debug: false
    definitions: player
    script:
        - define TargetLoc <location[295.5,152.5,723.5,Hub]>
        - define Density 20
        - define pitch <[Player].location.pitch.add[90].to_radians>
        - define yaw <[Player].location.yaw.mul[-1].to_radians>
        - define AV <util.random.decimal[0].to[<util.tau>]>
        - define speed 100
        
        - define y1 <[Player].location.y>
        - define y2 <[TargetLoc].y>
        - define r2 -<[y1].sub[<[y2]>].power[2]>

        #- repeat <[q]>:
        - define Points <[Player].location.above[1].points_between[<[TargetLoc]>].distance[0.35]>
        - define PointCt <[Points].size>
        - define M <cuboid[<[Player].location>|<[TargetLoc]>].center>
        #$ replace ending [1] with distance multiplied
        - define MaxY <element[1].add[<[Player].location.y.sub[<[TargetLoc].y>]>].min[3].add[2]>
        - foreach <[Points]> as:Loc:
            - define i1 <[loop_index]>
            - define x <location[0.75,0,0].rotate_around_y[<[i1].mul[<element[360].div[<[Density]>]>].to_radians.add[<[AV]>]>].rotate_around_x[<[pitch]>].rotate_around_y[<[yaw]>]>
            - define y 0
            - define LocSp <[Loc].add[<[x].above[<[y]>]>]>
        #_ collision
            - if <[LocSp].material.is_solid>:
                - foreach stop
            - if !<[Loc].add[0.1,0.1,0.1].to_cuboid[<[Loc].sub[0.1,1,0.1]>].entities.exclude[<[Player]>].is_empty>:
                - ActionBar "<&6>Entity Struck!<&e>: <&2><[Loc].add[0.1,0.1,0.1].to_cuboid[<[Loc].sub[0.1,1,0.1]>].entities.exclude[<[Player]>].parse[name].comma_separated>" targets:<[Player].location.find.players.within[50]>
                - foreach stop
        #_
            - playeffect effect:CLOUD at:<[Locsp]> quantity:1 data:0.1 offset:0.0 visibility:100 special_data:2.5|black
            - playeffect effect:REDSTONE at:<[LocSp]> quantity:1 data:0.2 offset:0 visibility:100 special_data:3.5|black
            - playeffect effect:REDSTONE at:<[LocSp]> quantity:1 data:0.2 offset:0 visibility:100 special_data:3.0|<color[<util.random.int[200].to[255]>,<util.random.int[100].to[165]>,0]>

            - if <[i1].mod[<[Speed]>]> == 0:
                - wait 1t
                - playeffect effect:flame at:<[Locsp]> quantity:5 data:0.1 offset:0.0 visibility:100
        - playeffect effect:lava at:<[LocSp]> quantity:20 data:0.2 offset:0 visibility:100
        #- narrate <[y]>
        #- narrate <[Loc]>
        #- narrate <[axis1]>


hyporadiusParticle2:
    type: task
    debug: false
    definitions: player
    script:
        #- 11/16 - atomic swirl
        #- 10/18 - neat swirls
        #- 10/3 - the doughnut
        #- 3/1 - the chains
        #- 3/4 - the helicopter
        #- 4/11 - The Cogwheel
        #- 15.0001 / 21.2 - Neat Swirl
        #- 25/24 - Cognive Spiral
        #- 10/22 - good circling spiral
        - define a <server.flag[test.a]>
        - define b <server.flag[test.b]>
        - define speed 10

        - repeat <element[360]>:
            - define i <[value]>
            - define x <[a].mul[<[i].cos>].sub[<[a].mul[<[b].mul[<[i]>]>].cos.mul[<[b]>]>].div[3]>
            - define y 1
            - define z <[a].mul[<[i].sin>].sub[<[a].mul[<[b].mul[<[i]>]>].sin.mul[<[b]>]>].div[3]>

            - playeffect effect:REDSTONE at:<[Player].location.add[<[x]>,<[y]>,<[z]>]> quantity:1 data:0.2 offset:0 visibility:100 special_data:1.15|black
            - playeffect effect:REDSTONE at:<[Player].location.add[<[x]>,<[y]>,<[z]>]> quantity:1 data:0.2 offset:0 visibility:100 special_data:1.15|<color[<util.random.int[70].to[140]>,0,<util.random.int[70].to[140]>]>
            - if <[i].mod[<[Speed]>]> == 0:
                - wait 1t
hyporadiusParticle3:
    type: task
    debug: false
    definitions: player
    script:
        #- 0.1/0.9 - looks kinda like a halo
        #- 5/0.9
        - define a <server.flag[test.a]>
        - define b <server.flag[test.b]>
        - define speed 10

        - repeat <element[360]>:
            - define i <[value]>
            - define x <[a].mul[<[i].cos>].sub[<[a].mul[<[b].mul[<[i]>]>].cos.mul[<[b]>]>].div[3]>
            - define z <[a].mul[<[i].sin>].sub[<[a].mul[<[b].mul[<[i]>]>].sin.mul[<[b]>]>].div[3]>
            - define y <[x].power[2].add[<[z].power[2]>].sqrt.cos.mul[<[a].div[4]>].add[2]>

            - playeffect effect:REDSTONE at:<[Player].location.add[<[x]>,<[y]>,<[z]>]> quantity:1 data:0.2 offset:0 visibility:100 special_data:1.14|black
            - playeffect effect:REDSTONE at:<[Player].location.add[<[x]>,<[y]>,<[z]>]> quantity:1 data:0.2 offset:0 visibility:100 special_data:1.14|<color[255,<util.random.int[0].to[50]>,<util.random.int[0].to[50]>]>
            #- playeffect effect:REDSTONE at:<[Player].location.add[<[x]>,<[y]>,<[z]>]> quantity:1 data:0.2 offset:0 visibility:100 special_data:0.4|<color[<util.random.int[70].to[140]>,0,<util.random.int[70].to[140]>]>
            - if <[i].mod[<[Speed]>]> == 0:
                - wait 1t

flamingcylinder:
    type: task
    debug: false
    definitions: player
    script:
        - define a <server.flag[test.a]>
        - define b <server.flag[test.b]>
        - define speed 5

        - repeat 30:
            - define i <[value]>
            - define x <location[2.5,0,0].rotate_around_y[<[i]>].x>
            - define z <location[2.5,0,0].rotate_around_y[<[i]>].z>
            - repeat 30:
                - define i2 <[value]>
                - define y <location[0,2.5,0].rotate_around_x[<[i2]>].y>
                - playeffect effect:flame at:<[Player].location.add[<[x]>,<[y]>,<[z]>]> quantity:1 offset:0 visibility:100
            - if <[i].mod[<[Speed]>]> == 0:
                - wait 1t

smallspiralparticle4:
    type: task
    debug: false
    definitions: player
    script:

        - define TargetLoc <location[295.5,152.5,723.5,Hub]>
        - define Density 20
        - define pitch <[Player].location.pitch.add[90].to_radians>
        - define yaw <[Player].location.yaw.mul[-1].to_radians>
        - define speed 200
        
        - define y1 <[Player].location.y>
        - define y2 <[TargetLoc].y>
        - define r2 -<[y1].sub[<[y2]>].power[2]>

        #- repeat <[q]>:
        - define Points <[Player].location.above[1].points_between[<[TargetLoc]>].distance[0.05]>
        - define PointCt <[Points].size>
        - define M <[Player].location.to_cuboid[<[TargetLoc]>].center>
        #$ replace ending [1] with distance multiplied
        - define MaxY <element[1].add[<[Player].location.y.sub[<[TargetLoc].y>]>].min[3].add[2]>
        - foreach <[Points]> as:Loc:
            - define i1 <[loop_index]>
            - define x <location[0.5,0,0].rotate_around_y[<[i1].mul[<element[360].div[<[Density]>]>].to_radians>].rotate_around_x[<[pitch]>].rotate_around_y[<[yaw]>]>
            - define y 0
            #- playeffect effect:flame at:<[Player].location.add[<[x]>].above[1]> quantity:1 offset:0 visibility:100
            - playeffect effect:REDSTONE at:<[Loc].add[<[x].above[<[y]>]>]> quantity:1 data:0.2 offset:0 visibility:100 special_data:0.75|black
            - playeffect effect:REDSTONE at:<[Loc].add[<[x].above[<[y]>]>]> quantity:1 data:0.2 offset:0 visibility:100 special_data:0.5|purple

            - if <[i1].mod[<[Speed]>]> == 0:
                - wait 1t
        - narrate <[y]>
        - narrate <[Loc]>
        #- narrate <[axis1]>

narratetest:
    type: task
    debug: false
    script:
    - define Density 2
    - repeat <element[360]>:
        - define a 11
        - define b 6

particlefluctuatetest:
    type: command
    name: ptester
    permission: test
    script:
        - if <context.args.first> == add:
            - if <context.args.get[2]> == a:
                - if <context.args.size> == 3:
                    - flag server test.a:+:<context.args.get[3]>
                - else:
                    - flag server test.a:++
            - else:
                - if <context.args.size> == 3:
                    - flag server test.b:+:<context.args.get[3]>
                - else:
                    - flag server test.b:++

        - else if <context.args.first> == sub:
            - if <context.args.get[2]> == a:
                - if <context.args.size> == 3:
                    - flag server test.a:-:<context.args.get[3]>
                - else:
                    - flag server test.a:--
            - else:
                - if <context.args.size> == 3:
                    - flag server test.b:-:<context.args.get[3]>
                - else:
                    - flag server test.b:--

        - else if <context.args.first> == set:
            - if <context.args.get[2]> == a:
                - flag server test.a:<context.args.get[3]>
            - else:
                - flag server test.b:<context.args.get[3]>
        - inject locally Message Instantly

    Message:
        - define Hover0 "<&a>Add 1"
        - define Hover1 "<&c>Sub 1"
        - define Text0 <&7>[<&a><&l>+<&7>]
        - define Text1 <&7>[<&c><&l>-<&7>]
        - define Command0 "ptester add a"
        - define Command1 "ptester sub a"
        - define Add0 <proc[msg_cmd].context[<[Hover0]>|<[Text0]>|<[Command0]>]>
        - define Sub0 <proc[msg_cmd].context[<[Hover1]>|<[Text1]>|<[Command1]>]>
        
        - define Hover0 "<&a>Add 1"
        - define Hover1 "<&c>Sub 1"
        - define Text0 <&7>[<&a><&l>+<&7>]
        - define Text1 <&7>[<&c><&l>-<&7>]
        - define Command0 "ptester add b"
        - define Command1 "ptester sub b"
        - define Add1 <proc[msg_cmd].context[<[Hover0]>|<[Text0]>|<[Command0]>]>
        - define Sub1 <proc[msg_cmd].context[<[Hover1]>|<[Text1]>|<[Command1]>]>
        - narrate "<[Add0]> <&e>A<&6>: <&a><server.flag[test.a]> <[Sub0]> <&b>| <[Add1]> <&e>B<&6>: <&a><server.flag[test.b]> <[Sub1]>"



Particle2m:
    type: task
    debug: false
    script:
        - define Player <npc[189]>
        - define TargetLoc <location[295.5,152.5,723.5,Hub]>

        - define Path <[Player].location.add[0,1.5,0].points_between[<[TargetLoc]>].distance[0.1]>
        
        - look <[Player]> <[TargetLoc]> duration:2s
        - animate <[Player]> animation:<list[ARM_SWING|ARM_SWING_OFFHAND].random>

    #$ Morphan1 Source
        - define length 0
        - define angularVelocity <util.pi.div[16]>
        - define pitchAngle <[Player].location.pitch.add[90].to_radians>
        - define yawAngle <[Player].location.yaw.mul[-1].to_radians>
        - define rotation <util.random.decimal[0].to[<util.tau>]>
        - define radius 1

        - foreach <[Path]> as:Loc:
            - if <[Loc].material.is_solid>:
                - foreach stop
            - if !<[Loc].add[0.1,0.1,0.1].to_cuboid[<[Loc].sub[0.1,1,0.1]>].entities.exclude[<[Player]>].is_empty>:
                - ActionBar "<&6>Entity Struck!<&e>: <&2><cuboid[<[Loc].add[0.1,0.1,0.1]>|<[Loc].sub[0.1,1,0.1]>].entities.exclude[<[Player]>].parse[name].comma_separated>"
                - foreach stop


            #$ Morphan1 Source
            - define vector <location[<[rotation].cos.mul[<[radius]>]>,<[length]>,<[rotation].sin.mul[<[radius]>]>]>
            - define Loc <[Loc].add[<[vector].rotate_around_x[<[pitchAngle]>].rotate_around_y[<[yawAngle]>]>]>
            - define rotation <[rotation].add[<[angularVelocity]>]>
            - define length <[length].add[0.05]>

            - playeffect effect:CLOUD at:<[Loc]> quantity:1 data:0.1 offset:0.0 visibility:100
            - playeffect effect:REDSTONE at:<[Loc]> quantity:1 data:0.2 offset:0.1 visibility:100 special_data:2.5|black
            - playeffect effect:REDSTONE at:<[Loc]> quantity:1 data:0.2 offset:0.1 visibility:100 special_data:2.5|purple
            - if <[Loop_Index].mod[75]> == 0:
                - wait 1t
        - repeat 3:
            - playeffect effect:EXPLOSION_LARGE at:<[Loc]> visibility:100 quantity:3 offset:1
            - wait 2t

Entity_Particle_RadiusSwirl_Layered2:
    type: task
    debug: false
    definitions: Target|WhileFlag|Radius|Density|Speed|Layers|Particle|Offset
    script:
        #@ Definition Check & Defaults [ 1-2 / 8 ]
        - if <[Target]||null> == null:
            - narrate format:Colorize_Red "Missing Target"
            - stop
        - if <[WhileFlag]||null> == null:
            - define Flag Test

        #@ Check for active queue to remove & replace
        - if <[Target].has_flag[<[WhileFlag]>]>:
            - if <queue.exists[<[Target].flag[<[WhileFlag]>].as_queue.id||null>]>:
                - queue <[Target].flag[<[WhileFlag]>].as_queue> clear
        - flag <[Target]> <[WhileFlag]>:<queue>

        #@ Definition Check & Defaults [ 3-8 / 8 ]
        #- Check defs?
        #^- define Definitions <list[Radius|Density|Speed|Layers|Particle|Offset]>
        #^- define Defaults <list[4|4|4|3|Villager_Happy|0,0.45,0]>
        - if <[Radius]||null> == null:
            - define Radius 4
        - if <[Density]||null> == null:
            - define Density 4
        - if <[Speed]||null> == null:
            - define Speed 4
        - if <[Layers]||null> == null:
            - define Layers 3
        - if <[Particle]||null> == null:
            - define Particle Villager_Happy
        - if <[Offset]||null> == null:
            - define Offset 0,0.45,0

        #@ Display Particles
        - while <[Target].has_flag[<[WhileFlag]>]>:
            - repeat <element[360].div[<[Density]>]>:
                - define Int1 <[value]>
                - repeat <[Layers]>:
                    - playeffect offset:0 at:<[Target].location.add[<location[<[Radius]>,<[Value].sub[1].add[<[Offset]>]>,0].rotate_around_y[<[Int1].to_radians.mul[<[Density]>]>]>]> effect:<[Particle]>
                    - playeffect offset:0 at:<[Target].location.add[<location[-<[Radius]>,<[Value].sub[1].add[<[Offset]>]>,0].rotate_around_y[<[Int1].to_radians.mul[<[Density]>]>]>]> effect:<[Particle]>
                    - playeffect offset:0 at:<[Target].location.add[<location[0,<[Value].sub[1].add[<[Offset]>]>,-<[Radius]>].rotate_around_y[<[Int1].to_radians.mul[<[Density]>]>]>]> effect:<[Particle]>
                    - playeffect offset:0 at:<[Target].location.add[<location[0,<[Value].sub[1].add[<[Offset]>]>,<[Radius]>].rotate_around_y[<[Int1].to_radians.mul[<[Density]>]>]>]> effect:<[Particle]>
                - wait <[Speed]>t

taskme:
    type: task
    debug: false
    script:
        - spawn armor_stand <player.location.add[0.5,0,3]> save:as
        - define as <entry[as].spawned_entity>
        - repeat 360:
            - adjust <[as]> velocity:<location[0.5,0,0].rotate_around_y[<def[value].to_radians>]>
            - rotate <[as]> yaw:-1 duration:1t
            - if <[value].mod[10]> == 9:
                - wait 1t
        - remove <[as]>

Spiral_Around_Y:
    type: task
    debug: false
    script:
        - define Density 10
        - narrate "<&2>[<&a>1<&2>] <&e>A Small<&6>,<&e> Basic Circle"
        - repeat <element[360].div[<[Density]>]>:
            - define Loc <player.location.above[1.8]>
            - define Angle <location[0,0,1].rotate_around_y[<[value].to_radians.mul[<[Density]>]>]>
            - playeffect effect:flame at:<[Loc].add[<[Angle]>]> offset:0
            - wait 1t

        - narrate "<&2>[<&a>1<&2>] <&e>A Small Circle"
        - repeat <element[360].div[<[Density]>]>:
            - define Loc <player.location.above[1.8]>
            - define Angle <location[0,0,1].rotate_around_y[<[value].to_radians.mul[<[Density]>]>]>
            - playeffect effect:flame at:<[Loc].add[<[Angle]>]> offset:0
            - wait 1t

Spiral_Around_X_or_Z:
    type: task
    debug: false
    script:
        - define Density 10
        - repeat <element[360].div[<[Density]>]>:
            - define Loc <player.location.above[1.8]>
            - define Angle <location[0,1,0].rotate_around_Z[<[value].to_radians.mul[<[Density]>]>]>
            - playeffect effect:flame at:<[Loc].add[<[Angle]>]> offset:0
            - wait 1t
        - repeat <element[360].div[<[Density]>]>:
            - define Loc <player.location.above[1.8]>
            - define Angle <location[0,1,0].rotate_around_X[<[value].to_radians.mul[<[Density]>]>]>
            - playeffect effect:flame at:<[Loc].add[<[Angle]>]> offset:0
            - wait 1t

#$ Plays Particles rotated with your pitch when facing South
Spiral_With_Pitch:
    type: task
    debug: false
    script:
        - define Density 10
        - repeat 100:
            - define Pitch <player.location.pitch.to_radians>
            - define Loc <player.location.above[1.8]>
            - define Angle <location[0,1,0].rotate_around_X[<[Pitch]>]>
            - playeffect effect:flame at:<[Loc].add[<[Angle]>]> offset:0
            - wait 1t



CommitToNotUsingRawObjectNotationInScripts:
    type: command
    name: enablehalo
    usage: /enablehalo
    description: Enables your Halo for being a good Denizzle!
    aliases:
        - PraiseDenizen
    script:
        - if <player.has_flag[GoodDenizzle]>:
            - flag player GoodDenizzle:!
            - narrate "<&c>Your Halo disapears!"
        - else:
            - flag player GoodDenizzle
            - narrate "<&a>You become a good Denizzle!"
            - run GoodDenizzleGoingToHeaven

GoodDenizzleGoingToHeaven:
    type: task
    debug: false
    script:
        - define HaloColor <color[255,255,0]>
        - while <player.has_flag[GoodDenizzle]> && <player.is_online>:
            - define Pitch <player.location.pitch.to_radians>
            - define Yaw <player.location.yaw.mul[-1].to_radians>
            - define Loc <player.eye_location.below[0.2]>
            - define Angle <location[0,0.6,0.25].rotate_around_y[<[Loop_Index].to_radians.mul[<element[10].add[72]>]>].rotate_around_x[<[Pitch]>].rotate_around_y[<[Yaw]>]>
            - playeffect effect:redstone at:<[Loc].add[<[Angle]>]> offset:0 special_data:0.5|<[HaloColor]>
            - if <[Loop_Index].mod[4]> == 0:
                - wait 1t
        - flag player GoodDenizzle:!
        - narrate "<&c>Your Halo disapears!"


#$ Tag Breakdown
## Halo's Center point: <player.eye_location.below[0.2]>
## Particle Distance from the Center Location is Y:0.6 Z:0.25
#- Y:0.6 puts the location just above your head,
#- based on the bottom of your head (the <[Loc]> location)
#- This rotates with your Pitch in radians: <player.location.pitch.to_radians>

## .rotate_around_y[<[Loop_Index].to_radians.mul[<element[10].add[72]>]>]
#- This rotates the above tag around the Y axis by the Index, as a radian
#- Multiplying that radian increases the spacing between the particles
#- if you want a particle at all 360 angles of the spiral, you wouldn't multiply anything
#- if you want a particle half as dense, you'd multiply by two to double the spacing
#- if you want a particle at 10 points around the circle, you'd multiply by 10
#- to create the illusion that you're spiraling at four points at a time each cycle,
#-    you could 
