large_blood_raid:
  type: task
  debug: false
  definitions: town
  script:
    # Reset flags
    - flag <[town]> blood_raid:!

    # Get the home chunk
    - if <[town].has_flag[center]>:
      - define base <[town].flag[center]>
    - else:
      - define base <[town].spawn.with_pose[0,0]>

    # Determine valid chunks in range
    - foreach <[town].plots> as:chunk:
      - if <[loop_index].mod[10]> == 0:
        - wait 1t
      - if <[chunk].cuboid.center.distance[<[base]>]> < 200:
        - define valid_chunks:->:<[chunk]>

    # get town corners
    - define lowest_x <[town].spawn.chunk.x>
    - define lowest_z <[town].spawn.chunk.z>
    - define highest_x <[town].spawn.chunk.x>
    - define highest_z <[town].spawn.chunk.z>
    - foreach <[town].plots> as:chunk:
      - if <[chunk].x> < <[lowest_x]>:
        - define lowest_x <[chunk].x>
      - if <[chunk].z> < <[lowest_z]>:
        - define lowest_z <[chunk].z>
      - if <[chunk].x> > <[highest_x]>:
        - define highest_x <[chunk].x>
      - if <[chunk].z> > <[highest_z]>:
        - define highest_z <[chunk].z>
      - wait 1t

    # get all the chunks for fake biomes
    - define biome_chunk_list <list>
    - define start_x <[lowest_x].sub[10]>
    - define start_z <[lowest_z].sub[10]>
    - define x_loop_size <[highest_x].add[10].sub[<[start_x]>]>
    - define z_loop_size <[highest_z].add[10].sub[<[start_z]>]>
    - repeat <[x_loop_size]> as:x:
      - repeat <[z_loop_size]> as:z:
        - define biome_chunk_list:->:<chunk[<[start_x].add[<[x]>]>,<[start_z].add[<[z]>]>,<[base].world.name>]>

    # Define surface blocks
    - foreach <[valid_chunks]>:
      - define all_surface_blocks:|:<[value].surface_blocks.random.above>
      - wait 1t

    # blood sigil start, end, and points between
    #- repeat 5:
    #  - define yaw_add <element[72].mul[<[value]>]>
    #  - define blood_sigil_<[value]>_start <[base].with_yaw[<[yaw_add]>].forward[8]>
    #  - wait 1t
    #- repeat 5:
    #  - define yaw_add <element[72].mul[<[value]>]>
    #  - define blood_sigil_<[value]>_end <[base].with_yaw[<[yaw_add]>].forward[25]>
    #  - wait 1t
    #- repeat 5:
    #  - define blood_sigil_<[value]>_points <proc[define_curve1].context[<[blood_sigil_<[value]>_start]>|<[blood_sigil_<[value]>_end]>|1|0|1]>
    #  - wait 1t

    # Define Sigil subtitle text
    - define sigil_1_subtitle "<&4>Blood Skeletons"
    - define sigil_2_subtitle "<&4>Blood Creepers"
    - define sigil_3_subtitle "<&4>Blood Mist"
    - define sigil_4_subtitle "<&4>Blood Bombs"
    - define sigil_5_subtitle "<&4>Blood Lord"
    - wait 1t

    # Set Gamerules
    - gamerule <world[herocraft]> doMobSpawning false
    - gamerule <world[herocraft]> doWeatherCycle false
    - gamerule <world[herocraft]> doDaylightCycle false
    - wait 1t

    # Fast Forward to Midnight
    - if <[base].world.moon_phase> != 5:
      - adjust <[base].world> full_time:<[base].world.time.add[<element[24000].mul[<element[5].sub[<[base].world.moon_phase>]>]>].round>
    - announce "<&e>A magical force takes hold of the skies..."
    - define increment <[base].world.time.sub[18000].abs.div[240].round_up>
    - repeat 240:
      - adjust <[base].world> time:<[base].world.time.add[<[increment]>]>
      - wait 1t


    # Bossbar Intro
    - if !<server.current_bossbars.contains[Blood_Raid_<[town].name>]>:
      - bossbar create Blood_Raid_<[town].name> players:<server.online_players> progress:0 "title:<&4>Blood Raid<&co><&e> Incoming" color:red
    - else if:
      - bossbar update Blood_Raid_<[town].name> players:<server.online_players> progress:0 "title:<&4>Blood Raid<&co><&e> Incoming" color:red

    # Flag the Town for the raid
    - flag <[town]> blood_raid.stage:1
    - flag <[town]> blood_raid.portal:5
    - flag server blood_raid:<[town]>

    # Sky Animation
    - ~run large_blood_raid_start_sky def:<[town]>

    # Start the blood ground animation
    - run large_blood_raid_ground_blood def.town:<[town]> def.valid_chunks:<[valid_chunks]>

    # Let the ground animation run
    - wait 10s

    # Determine iterations
    - if <[all_surface_blocks].size> < 5:
      - define iterations 6
    - else if <[all_surface_blocks].size> < 6:
      - define iterations 5
    - else if <[all_surface_blocks].size> < 8:
      - define iterations 4
    - else if <[all_surface_blocks].size> < 14:
      - define iterations 3
    - else if <[all_surface_blocks].size> < 25:
      - define iterations 2
    - else:
      - define iterations 1

    # Launch Arcs
    - repeat <[iterations]>:
      - foreach <[all_surface_blocks].random[1000]> as:loc:
        - run large_blood_raid_shoot_arc def.town:<[town]> def.start:<[loc]>
        - wait 14t

    # Wait for Arcs
    - waituntil <[town].flag[blood_raid.portal].equals[30]> rate:1s

    - title title:<&color[#990000]><&font[adriftus:overlay]><&chr[0004]><&chr[F801]><&chr[0004]> fade_in:6s stay:5s fade_out:6s targets:<server.online_players>

    # Wait for Overlay to near full occlusion
    - wait 5s

    # Set time to day for shader support on biome sky color
    - foreach <server.online_players> as:__player:
      - time player 29100 freeze
    - wait 1t

    # PLAY EXPLOSION SOUNDS
    - run set_fake_biome def.town:<[town]> def.chunks:<[biome_chunk_list]> def.state:true

    # Spawn Blood Sigils
    - flag <[town]> blood_raid.stage:2
    - run blood_sigil_spawn def:<[town]>

    - wait 15s
    - run blood_raid_mob_watcher def:<[town]>
    - repeat 5:
      - ~run blood_raid_sigil_activate def.town:<[town]> def.sigil_number:<[value]>
      - title "title:<&4>Sigil <[value]> Activated" subtitle:<[sigil_<[value]>_subtitle]> targets:<server.online_players> fade_in:10t stay:4s fade_out:10t
      - bossbar update Blood_Raid_<[town].name> players:<server.online_players> progress:<element[20].mul[<[value]>].div[100]> "title:<&4>Blood Raid<&co><&e> Stage <[value]>" color:red
      - wait 60s

    # DEVELOPMENT FROM HERE DOWN
    - waituntil <[town].flag[blood_raid.stage].equals[6]> rate:1s
    - adjust <server.online_players.filter[location.town.equals[<[town]>]]> velocity:0,0.5,0
    - wait 5s
    - remove <[town].flag[blood_raid.mobs].filter[is_spawned]>
    #CLEANUP - DEBUG
    - bossbar remove Blood_Raid_<[town].name>
    - title title:<&color[#FFFFFF]><&font[adriftus:overlay]><&chr[0004]><&chr[F801]><&chr[0004]> fade_in:6s stay:5s fade_out:6s targets:<server.online_players>
    - wait 5s
    - foreach <server.online_players.filter[location.town.equals[<[town]>]]> as:__player:
      - run actor_weapon_blood_raid_scythe_cancel_effect
    - rotate <[town].flag[blood_raid.sigils]> cancel
    - wait 1t
    - remove <[town].flag[blood_raid.sigils]>
    - flag <[town]> blood_raid:!
    - flag server blood_raid:!
    - run set_fake_biome def.town:<[town]> def.chunks:<[biome_chunk_list]> def.state:false
    - gamerule <world[herocraft]> doMobSpawning true
    - gamerule <world[herocraft]> doWeatherCycle true
    - gamerule <world[herocraft]> doDaylightCycle true
    - define increment <[base].world.time.sub[29000].abs.div[120].round_up>
    - repeat 120:
      - adjust <[base].world> time:<[base].world.time.add[<[increment]>]>
      - wait 1t
    - foreach <server.online_players> as:__player:
      - time player reset

# Ground Blood During Raid
large_blood_raid_ground_blood:
  type: task
  debug: false
  definitions: town|valid_chunks
  script:
    - if <[town].has_flag[center]>:
      - define base <[town].flag[center]>
    - else:
      - define base <[town].spawn>
    # play blood animation
    - while <[town].has_flag[blood_raid]> && <[town].flag[blood_raid.stage]> == 1:
      - playeffect at:<[base]> effect:redstone special_data:1|#990000 offset:120,1,120 quantity:200 targets:<server.online_players>
      - wait 2t

large_blood_raid_shoot_arc:
  type: task
  debug: false
  definitions: town|start
  script:
    - if <[town].has_flag[center]>:
      - define base <[town].flag[center]>
    - else:
      - define base <[town].spawn>
    - define location <[base].above[40]>
    - define locations <proc[define_curve1].context[<[start]>|<[location]>|<util.random.int[5].to[25]>|<util.random.int[25].to[75]>|1]>
    - wait 1t
    - repeat 10:
      - playeffect at:<[start].center.above[0.55]> effect:redstone special_data:10|#990000 offset:1,0,1 quantity:5 targets:<server.online_players>
      - wait 2t
    - foreach <[locations]> as:loc:
        - playeffect at:<[loc]> effect:redstone special_data:10|#990000 offset:0.25 quantity:5 targets:<server.online_players>
        - wait 2t
    - if <[town].flag[blood_raid.portal]> < 30:
      - flag <[town]> blood_raid.portal:+:1

large_blood_raid_start_sky:
  type: task
  debug: false
  definitions: town
  script:
    - if <[town].has_flag[center]>:
      - define base <[town].flag[center]>
    - else:
      - define base <[town].spawn>
    # Build the initial points coming from far
    - repeat 5:
      - define yaw_add <element[72].mul[<[value]>]>
      - define location_<[value]> <[base].with_yaw[<[yaw_add]>].above[40].forward[160]>
      - define points_<[value]> <[location_<[value]>].points_between[<[base].above[40]>]>
      - wait 1t
    - define size <[points_1].size>
    - define final_points1 <list>
    - repeat <[size]>:
      - define final_points1 <[final_points1].include_single[<[points_1].get[<[value]>]>|<[points_2].get[<[value]>]>|<[points_3].get[<[value]>]>|<[points_4].get[<[value]>]>|<[points_5].get[<[value]>]>]>
      - wait 1t
    # Build the spiral to the ground
    - repeat 5:
      - define yaw_add <element[72].mul[<[value]>]>
      - define points_<[value]> <proc[define_spiral].context[<[base].above[40]>|<[base].below>|1.25|<[yaw_add]>]>
      - wait 1t
    - define size <[points_1].size>
    - define final_points2 <list>
    - repeat <[size]>:
      - define final_points2 <[final_points2].include_single[<[points_1].get[<[value]>]>|<[points_2].get[<[value]>]>|<[points_3].get[<[value]>]>|<[points_4].get[<[value]>]>|<[points_5].get[<[value]>]>]>
      - wait 1t

    # Play the straight particles with the lists generated above
    - foreach <[final_points1]> as:locations:
      - playeffect at:<[locations]> effect:redstone special_data:10|#990000 offset:0.1 quantity:10 targets:<server.online_players>
      - wait 1t

    # Start the big Sky Portal
    - run large_blood_raid_big_portal def:<[town]>

    # Play the spiral particles with the lists generated above
    - foreach <[final_points2]> as:locations:
      - playeffect at:<[locations]> effect:redstone special_data:3|#990000 offset:0.0 quantity:2 targets:<server.online_players>
      - wait 1t

#<proc[define_spiral].context[<player.location.above[30].forward[5]>|<player.location.forward[5]>|0.75|10]>

large_blood_raid_big_portal:
  type: task
  debug: false
  definitions: town
  script:
    - if <[town].has_flag[center]>:
      - define base <[town].flag[center]>
    - else:
      - define base <[town].spawn>
    - define location <[base].above[40]>
    - while <[town].has_flag[blood_raid]> && <[town].flag[blood_raid.stage]> == 1:
      - playeffect at:<[location]> effect:redstone special_data:10|#990000 offset:<[town].flag[blood_raid.portal].mul[0.05]> quantity:<[town].flag[blood_raid.portal].mul[3]> targets:<server.online_players>
      - wait 3t
    - waituntil <[town].has_flag[blood_raid.sigils_active_locations]> rate:10t
    - while <[town].has_flag[blood_raid]> && <[town].flag[blood_raid.stage]> == 2:
      - playeffect at:<[town].flag[blood_raid.sigils_active_locations]> effect:redstone special_data:5|#990000 offset:0 quantity:5 targets:<server.online_players>
      - wait 8t
    - waituntil <[town].flag[blood_raid.stage].equals[3]> rate:10t
    - ~run blood_sigil_5_blood_arc def:<[town]>
    - while <[town].has_flag[blood_raid]> && <[town].flag[blood_raid.stage]> == 3:
      - playeffect at:<[town].flag[center].above[30]> effect:redstone special_data:5|#990000 offset:1 quantity:10 targets:<server.online_players>
      - if <[loop_index].mod[10]> == 0:
        - run blood_sigil_5_blood_arc def:<[town]>
      - wait 2t

# Set the fake biome
set_fake_biome:
  type: task
  debug: false
  definitions: town|chunks|state
  script:
    - if <[state]>:
      - define time 5h
    - else:
      - define time 1t
    - foreach <[chunks]> as:chunk:
      - if <[loop_index].mod[30]> == 0:
        - wait 1t
      - fakebiome biome:<biome[adriftus:blood_raid]> players:<server.online_players> chunk:<[chunk]> duration:<[time]>
    - foreach <[chunks]> as:chunk:
      - if <[loop_index].mod[30]> == 0:
        - wait 1t
      - adjust <[chunk]> refresh_chunk

## BLOOD SIGILS
# Activate a Sigil
blood_raid_sigil_activate:
  type: task
  debug: false
  definitions: town|sigil_number
  script:
    - define sigil <[town].flag[blood_raid.sigils].get[<[sigil_number]>]>
    - flag <[town]> blood_raid.sigils_active_locations:->:<[sigil].location.above[5]>
    - repeat 14:
      - rotate <[sigil]> yaw:<[value]> duration:1s
      - wait 1s
    - rotate <[sigil]> yaw:15 infinite
    - run blood_sigil_effect_<[sigil_number]> def:<[town]>

#Spawn the 5 Sigils
blood_sigil_spawn:
  type: task
  debug: false
  definitions: town
  script:
    - if <[town].has_flag[center]>:
      - define base <[town].flag[center]>
    - else:
      - define base <[town].spawn>
    - repeat 5:
      - define yaw_add <element[72].mul[<[value]>]>
      - spawn blood_sigil_<[value]> <[base].above[40].with_yaw[<[yaw_add]>].forward[25]> save:ent
      - flag <[town]> blood_raid.sigils:->:<entry[ent].spawned_entity>
      - wait 1t

##Blood Sigil 1
blood_sigil_1:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    visible: false
    marker: true
    equipment:
      - air
      - air
      - air
      - leather_horse_armor[custom_model_data=300]
    glowing: true

#First sigil effect
blood_sigil_effect_1:
  type: task
  debug: false
  definitions: town
  script:
    - flag <[town]> blood_raid.sigil_mobs.1:<list>
    - while <list[2|5].contains[<[town].flag[blood_raid.stage]>]>:
      - flag <[town]> blood_raid.sigil_mobs.1:<[town].flag[blood_raid.sigil_mobs.1].filter[is_spawned]>
      - if <[town].flag[blood_raid.sigil_mobs.1].size> <= <element[2].mul[<[town].flag[blood_raid.stage]>]>:
        - run blood_sigil_effect_1_spawn def:<[town]>
      - wait 5s

# Sigil Spawner
blood_sigil_effect_1_spawn:
  type: task
  debug: false
  definitions: town
  script:
    - define sigil <[town].flag[blood_raid.sigils].first>
    - define start <[sigil].location.above[5]>
    - define location <[start].find_players_within[220].random.location>
    - define locations <proc[define_curve1].context[<[start]>|<[location]>|<util.random.int[5].to[15]>|<util.random.int[75].to[125]>|1]>
    - wait 1t
    - repeat 5:
      - playeffect at:<[start]> effect:redstone special_data:5|#990000 offset:0.5,0,0.5 quantity:5 targets:<server.online_players>
      - wait 2t
    - wait 1t
    - foreach <[locations]> as:loc:
        - playeffect at:<[loc]> effect:redstone special_data:10|#990000 offset:0.25 quantity:5 targets:<server.online_players>
        - wait 1t
    - spawn blood_raid_raider_1 <[locations].last> save:ent
    - wait 1t
    - if <entry[ent].spawned_entity.is_spawned>:
      - flag <[town]> blood_raid.sigil_mobs.1:->:<entry[ent].spawned_entity>
      - flag <[town]> blood_raid.mobs:->:<entry[ent].spawned_entity>
    - else:
      - explode <[locations].last> power:5

blood_raid_raider_1:
  type: entity
  debug: false
  entity_type: skeleton
  mechanisms:
    health_data: 100/100
    custom_name: <&c>Blood Skeleton
    custom_name_visible: true
  flags:
    on_targetting: only_target_players
    on_shoots_bow: blood_raid_bow_shot

blood_raid_bow_shot:
  type: task
  debug: false
  script:
    - wait 1t
    - flag <context.projectile> on_hit_entity:blood_raid_bow_damage
    - while <context.projectile.is_spawned>:
      - playeffect at:<context.projectile.location> effect:redstone special_data:5|#990000 offset:0 quantity:2 targets:<server.online_players>
      - wait 1t
      - if <[loop_index]> > 80:
        - while stop

# blood skeleton task
blood_raid_bow_damage:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - if <context.hit_entity.has_Flag[blood_drain]>:
      - stop
    - flag <context.hit_entity> blood_drain
    - repeat 5:
      - if !<context.hit_entity.is_spawned>:
        - repeat stop
      - hurt <context.hit_entity> 2
      - wait 1s
    - flag <context.hit_entity> blood_drain:!

##Blood Sigil 2
blood_sigil_2:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    visible: false
    marker: true
    equipment:
      - air
      - air
      - air
      - leather_horse_armor[custom_model_data=301]
    glowing: true

#Second sigil effect
blood_sigil_effect_2:
  type: task
  debug: false
  definitions: town
  script:
    - flag <[town]> blood_raid.sigil_mobs.2:<list>
    - while <list[2|5].contains[<[town].flag[blood_raid.stage]>]>:
      - flag <[town]> blood_raid.sigil_mobs.2:<[town].flag[blood_raid.sigil_mobs.2].filter[is_spawned]>
      - if <[town].flag[blood_raid.sigil_mobs.2].size> <= <element[2].mul[<[town].flag[blood_raid.stage]>]>:
        - run blood_sigil_effect_2_spawn def:<[town]>
      - wait 5s

# Sigil Spawner
blood_sigil_effect_2_spawn:
  type: task
  debug: false
  definitions: town
  script:
    - define sigil <[town].flag[blood_raid.sigils].get[2]>
    - define start <[sigil].location.above[5]>
    - define location <[start].find_players_within[220].random.location>
    - define locations <proc[define_curve1].context[<[start]>|<[location]>|<util.random.int[5].to[15]>|<util.random.int[75].to[125]>|1]>
    - wait 1t
    - repeat 5:
      - playeffect at:<[start]> effect:redstone special_data:5|#990000 offset:0.5,0,0.5 quantity:5 targets:<server.online_players>
      - wait 2t
    - wait 1t
    - foreach <[locations]> as:loc:
        - playeffect at:<[loc]> effect:redstone special_data:10|#990000 offset:0.25 quantity:5 targets:<server.online_players>
        - wait 1t
    - spawn blood_raid_raider_2 <[locations].last> save:ent
    - wait 1t
    - if <entry[ent].spawned_entity.is_spawned>:
      - flag <[town]> blood_raid.sigil_mobs.2:->:<entry[ent].spawned_entity>
      - flag <[town]> blood_raid.mobs:->:<entry[ent].spawned_entity>
    - else:
      - explode <[locations].last> power:5

blood_raid_raider_2:
  type: entity
  debug: false
  entity_type: creeper
  mechanisms:
    health_data: 100/100
    custom_name: <&c>Blood Creeper
    custom_name_visible: true
    potion_effects:
      type: CONFUSION
      duration: 30s
      ambient: false
      particles: false
      icon: false
    flags:
      on_damage: blood_raid_creeper_damage

blood_raid_creeper_damage:
  type: task
  debug: false
  script:
    - flag <context.entity> no_heal expire:10s

##Third Blood Sigil
blood_sigil_3:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    visible: false
    marker: true
    equipment:
      - air
      - air
      - air
      - leather_horse_armor[custom_model_data=302]
    glowing: true

#Third sigil effect
blood_sigil_effect_3:
  type: task
  debug: false
  definitions: town
  script:
    - if <[town].has_flag[center]>:
      - define base <[town].flag[center]>
    - else:
      - define base <[town].spawn>
    # play blood animation
    - if <[town].flag[blood_raid.stage]> == 2:
      - define coefficient 2
    - else:
      - define coefficient 1
    - while <[town].has_flag[blood_raid]> && <list[2|5].contains[<[town].flag[blood_raid.stage]>]>:
      - if <[loop_index].mod[10]> == 0:
        - hurt <element[1].mul[<[coefficient]>]> <[base].find_players_within[120]>
      - playeffect at:<[base]> effect:redstone special_data:10|#990000 offset:120,1,120 quantity:100 targets:<server.online_players>
      - wait 2t

##Fourth Blood Sigil
blood_sigil_4:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    visible: false
    marker: true
    equipment:
      - air
      - air
      - air
      - leather_horse_armor[custom_model_data=303]
    glowing: true

#Fourth sigil effect
blood_sigil_effect_4:
  type: task
  debug: false
  definitions: town
  script:
    - if <[town].has_flag[center]>:
      - define base <[town].flag[center]>
    - else:
      - define base <[town].spawn>
    - foreach <[town].plots> as:chunk:
      - if <[loop_index].mod[10]> == 0:
        - wait 1t
      - if <[chunk].cuboid.center.distance[<[base]>]> < 200:
        - define chunks:->:<[chunk]>
    - while <[town].has_flag[blood_raid.stage]> && <list[2|5].contains[<[town].flag[blood_raid.stage]>]>:
      - run blood_sigil_effect_4_task def:<[town]>|<[chunks].random>
      - wait <element[3].div[<[town].flag[blood_raid.stage]>]>s

blood_sigil_effect_4_task:
  type: task
  debug: false
  definitions: town|chunk
  script:
    - define sigil <[town].flag[blood_raid.sigils].get[4]>
    - define start <[sigil].location.above[5]>
    - if <util.random_chance[90]>:
      - define location <[chunk].surface_blocks.random>
    - else:
      - define location <server.online_players.filter[location.town.equals[<[town]>]].random.location>
    - define locations <proc[define_curve1].context[<[start]>|<[location]>|<util.random.int[10].to[25]>|90|1]>
    - wait 5t
    - repeat 5:
      - playeffect at:<[start]> effect:redstone special_data:5|#990000 offset:0.5,0,0.5 quantity:5 targets:<server.online_players>
      - wait 2t
    - wait 1t
    - foreach <[locations]> as:loc:
      - playeffect at:<[loc]> effect:redstone special_data:10|#990000 offset:0.25 quantity:5 targets:<server.online_players>
      - wait 1t
    - define loc <[locations].last>
    - define blocks <[loc].find_blocks.within[3]>
    - repeat 5:
      - explode <[blocks].random> power:5 fire
      - wait 1t
    - modifyblock <[loc].above.find_blocks.within[3]> air naturally:netherite_pickaxe

blood_sigil_5:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    visible: false
    marker: true
    equipment:
      - air
      - air
      - air
      - leather_horse_armor[custom_model_data=304]
    glowing: true

blood_sigil_effect_5:
  type: task
  debug: false
  definitions: town
  script:
    - stop if:<[town].flag[blood_raid.stage].equals[5]>
    - remove <[town].flag[blood_raid.mobs].filter[is_spawned]>
    - define blood_lord <server.match_player[Drunken_scot]>
    - flag <[town]> blood_raid.sigils_active_locations:!
    - give actor_weapon_blood_raid_scythe to:<[blood_lord].inventory> slot:1
    - run mask_wear def:adriftus_blood_lord player:<[blood_lord]>
    - wait 2s
    - flag <[town]> blood_raid.stage:3
    - rotate <[town].flag[blood_raid.sigils]> cancel
    - define points <proc[define_star].context[<player.town.flag[center].above[46].with_pose[90,0]>|25|18|5]>
    - repeat 120:
      - playeffect at:<[points]> effect:redstone special_data:5|#990000 offset:0 quantity:1 targets:<server.online_players>
      - wait 2t
    - flag <[town]> blood_raid.stage:4
    - teleport <[blood_lord]> <[town].flag[center].above[30]>

blood_sigil_5_blood_arc:
  type: task
  debug: false
  definitions: town
  script:
    - flag <[town]> blood_raid.blood_arcs:+:1
    - define sigil <[town].flag[blood_raid.sigils].get[<[town].flag[blood_raid.blood_arcs].mod[5]>]>
    - define points <proc[define_curve1].context[<[sigil].above[5]>|<[town].flag[center].above[30]>|<util.random.int[5].to[15]>|<util.random.int[75].to[125]>|1]>
    - foreach <[points]> as:loc:
      - playeffect at:<[loc]> effect:redstone special_data:10|#990000 offset:0.1 quantity:5 targets:<server.online_players>
      - wait 1t

# MOB WATCHER
blood_raid_mob_watcher:
  type: task
  debug: false
  definitions: town
  script:
    - while <[town].has_flag[blood_raid]>:
      - if <[town].has_flag[blood_raid.mobs]>:
        - foreach <[town].flag[blood_raid.mobs]> as:mob:
          - if !<[mob].is_spawned>:
            - flag <[town]> blood_raid.mobs:<-:<[mob]>
          - else if !<[mob].target.exists>:
            - run blood_raid_focus_mob def:<[mob]>
          - wait 1t
      - wait 1s

blood_raid_focus_mob:
  type: task
  debug: false
  definitions: mob
  script:
    - wait 1t
    - define target <[mob].location.find_players_within[32].filter[gamemode.equals[survival]].get[1].if_null[null]>
    - wait 1t
    - if <[target]> == null:
      - repeat 10:
        - playeffect at:<[mob].location.above> effect:redstone special_data:1|#990000 offset:0.5,1,0.5 quantity:10 targets:<server.online_players>
        - wait 2t
      - remove <[mob]>
    - else:
      - attack <[mob]> target:<[target]>

blood_raid_sigil_overdrive:
  type: task
  debug: false
  definitions: town
  script:
    - flag <[town]> blood_raid.stage:5
    - bossbar update Blood_Raid_<[town].name> players:<server.online_players> progress:100 "title:<&4>Blood Raid<&co> Overdrive" color:red
    - repeat 5:
      - run blood_raid_sigil_activate def.town:<[town]> def.sigil_number:<[value]>
      - wait 5t

test_animation:
  type: task
  debug: false
  definitions: location|entity
  script:
    - define location <player.cursor_on.center.above[0.5].with_pitch[-90].with_yaw[0]>
    - spawn armor_stand[visible=false;marker=true;equipment=air|air|air|leather_horse_armor[custom_model_data=305]] <[location]> save:center_armor_stand
    - rotate <entry[center_armor_stand].spawned_entity> duration:360t frequency:1t yaw:9

    - spawn <entity[armor_stand].with[visible=false;marker=true;equipment=air|air|air|leather_horse_armor[custom_model_data=307]].repeat_as_list[5]> <[location]> save:outer_armor_stands

    - foreach 0|72|144|216|288 as:rotation:
      - define origin_location <[location].with_yaw[<[location].yaw.add[<[rotation]>]>]>
      - run test_animation.animation def:<[origin_location]>|<entry[outer_armor_stands].spawned_entities.get[<[loop_index]>]>

    - repeat 600:
      - playeffect at:<[location].add[<location[5,0,0].rotate_around_y[<[value].mul[8].to_radians>]>]> effect:flame offset:0.2 quantity:3
      - if <[value].mod[4]> == 0:
        - wait 1t
    - remove <entry[center_armor_stand].spawned_entity>

  animation:
    - define locations <[location].proc[define_star].context[3|0|5]>
    - foreach <[locations]> as:point:
      - teleport <[entity]> <[point].with_y[<[entity].location.y>].with_yaw[<[loop_index].mul[36]>]>
      - playeffect at:<[point].with_y[<[entity].location.y>].above[1.1]> offset:0.2 effect:redstone quantity:10 special_data:<util.random.decimal[0.5].to[0.9]>|<color[<util.random.int[200].to[100]>,0,0]>
      #- playeffect at:<[point].with_y[<[entity].location.y>].above[1.1]> offset:1 effect:sweep_attack quantity:1
      - wait 2t
    - teleport <[entity]> <[location].above[5]>
    - run test_animation.lazy_wait def.entity:<[entity]>

    - repeat 360:
      - playeffect at:<[location].above[5].points_between[<[location].above[50]>].distance[1]> offset:0.2 effect:redstone quantity:10 special_data:<util.random.decimal[0.5].to[0.9]>|<color[<util.random.int[200].to[100]>,0,0]>  visibility:100
      - playeffect at:<[location].above[5]> offset:1 effect:redstone quantity:20 special_data:<util.random.int[1].to[2]>|<color[<util.random.int[200].to[100]>,0,0]> visibility:100
      - wait 2t
    - wait 5t
  lazy_wait:
    - wait 5t
    - remove <[entity]>

#306 -> start

arcane_ashes:
  type: item
  debug: false
  material: feather
  display name: arcane ashes
  mechanisms:
    custom_model_data: 105

binding_raegent:
  type: item
  debug: false
  material: feather
  display name: Binding Raegent
  mechanisms:
    custom_model_data: 106

shit_handler:
  type: world
  debug: false
  events:
    on player right clicks block with:arcane_ashes:
      - spawn armor_stand[visible=false;marker=true;equipment=air|air|air|leather_horse_armor[custom_model_data=306]] <player.cursor_on.center.above[0.5]> save:arcane_something
      - flag server arcane_thing:<entry[arcane_something].spawned_entity> expire:10m
    on player right clicks block with:binding_raegent server_flagged:arcane_thing:
      - define location <context.location.if_null[<player.cursor_on.if_null[<player.location.forward_flat[2]>]>]>
      - flag <context.location.town> center:<[location].center>
      - run test_animation def:<[location]>
      - run large_blood_raid def:<context.location.town>
      - remove <server.flag[arcane_thing]>
    on player dies server_flagged:blood_raid bukkit_priority:LOWEST:
      - if <player.location.town> == <server.flag[blood_raid]>:
        - determine passively cancelled
        - title title:<&color[#FFFFFF]><&font[adriftus:overlay]><&chr[0004]><&chr[F801]><&chr[0004]> "subtitle:<&color[#000000]>It is not your time yet..." fade_in:10t stay:1s fade_out:10t targets:<player>
        - wait 10t
        - teleport <player> <player.location.town.spawn>