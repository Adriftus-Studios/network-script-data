koth_config:
  type: data
  messages:
    start: "<&b>Start"
    announce_location: "<&a>New KOTH Location <[location_name]>!"
    winner: "<[winner].name> has won!"
  # KOTH Area size
  koth_radius: 6

koth_events:
  type: world
  debug: false
  events:
    after server start:
      - if !<server.worlds.parse[name].contains[orient]>:
        - createworld orient
        - wait 10s
      - run koth_start
      - run koth_spawn_launcher_particles
    on player joins:
      - if !<player.has_flag[no_fall_damage]>:
        - flag <player> no_fall_damage
      - if !<player.has_flag[koth.current]>:
        - flag player koth.current.points:0
        - flag player koth.current.direction:<&sp>
      - if !<player.has_flag[koth.global]>:
        - flag player koth.global.points:0
        - flag player koth.global.kills:0
        - flag player koth.global.deaths:0
        - flag player koth.global.wins:0
      - wait 5t
      - if <server.current_bossbars.contains[current_koth]>:
        - bossbar update current_koth players:<server.online_players>
      - else if <server.current_bossbars.contains[countdown]>:
        - bossbar update countdown players:<server.online_players>
      - adjust <player> can_fly:false if:<player.can_fly>
      - adjust <player> gamemode:adventure if:<player.gamemode.equals[adventure].not>
    on player jumps flagged:koth_liftoff:
      - define location <player.location>
      - if <[location].pitch> < -75:
        - if <player.location.highest.y> > <player.location.y>:
          - narrate "<&c>You need a clear view of the sky."
          - stop
        - wait 1t
        - run koth_launcher def:true
    on player dies in:orient bukkit_priority:MONITOR:
      - flag player koth.global.deaths:++
      - if <context.damager.exists>:
        - flag <context.damager> koth.global.kills:++
    on player respawns:
      - determine passively <location[spawn_location]>
      - flag <player> no_damage
      - wait 1t
      - worldborder reset <player>
    on player dies bukkit_priority:HIGHEST:
      - determine NO_DROPS
    on player enters koth_area:
      - flag <player> no_damage:!
      - flag <player> koth_liftoff:!
      - adjust <player> gliding:false if:<player.gliding>
    after player enters spawn_launcher:
      - ratelimit <player> 5s
      - inject koth_launcher
    after player exits spawn:
      - flag <player> koth_hop
      - if <ellipsoid[current_koth].exists> && <player.is_online>:
        - worldborder <player> center:<ellipsoid[current_koth].location> size:50

koth_start:
  type: task
  debug: false
  definitions: immediate
  script:
    - while <world[orient].players.is_empty>:
      - wait 1s
    - if !<server.has_flag[koth.current.leader]>:
      - flag server koth.current.leader.name:<&6>Awaiting...
      - flag server koth.current.leader.points:<&6>Awaiting...
    - flag server koth.current.koth_location:<&6>Awaiting...
    - ~run koth_countdown if:<[immediate].not||true>
    - teleport <server.online_players> spawn_location
    - announce <script[koth_config].parsed_key[messages.start]>
    - flag <server.players_flagged[koth.current.points]> koth.current.points:0
    - run koth_update_directions
    - adjust <server.online_players.filter[can_fly]> can_fly:false
    - flag <server.online_players> koth_liftoff:!
    - repeat 3:
      - ~run koth_run_area def:<[value]>
      - wait 1s
    - note remove as:current_koth
    - flag server koth.current.last_hill:!
    - heal <server.online_players>
    - adjust <server.online_players> can_fly:true
    - flag server flying_on:!|:<server.online_players>
    - narrate "<&a>Flight has been enabled for Countdown." targets:<server.online_players>
    - flag <server.online_players> no_damage
    - if <server.online_players_flagged[koth.current.points].size> > 0:
      - define winner <server.online_players_flagged[koth.current.points].sort_by_number[flag[koth.current.points]].last>
      - flag <[winner]> koth.global.wins:++
      - announce <script[koth_config].parsed_key[messages.winner]>
      - run koth_win_events def:<[win_sounds]>
    - run koth_start

koth_countdown:
  type: task
  debug: false
  script:
    - flag <server.players_flagged[koth.current.direction]> koth.current.direction:<&sp>
    - bossbar create countdown "title:Countdown <duration[300s].formatted>" progress:1 color:green players:<server.online_players>
    - repeat 300:
      - define color <list[green|yellow|red].get[<[value].div[100].round_up>]>
      - define color_symbol <list[<&a>|<&e>|<&c>].get[<[value].div[100].round_up>]>
      - define time <duration[300s].sub[<[value]>s].formatted>
      - bossbar update countdown "title:<[color_symbol]>Countdown <[time]>" progress:<element[300].sub[<[value]>].div[300]> color:<[color]>
      - wait 1s
    - bossbar remove countdown

koth_run_area:
  type: task
  debug: false
  definitions: round
  script:
    - define last_hill <server.flag[koth.current.last_hill]||null>
    - define location_id <server.flag[koth.global.koth_location].keys.exclude[<[last_hill]>].random>
    - define location <server.flag[koth.global.koth_location.<[location_id]>.location]>
    - define location_name <server.flag[koth.global.koth_location.<[location_id]>.name]>
    - flag server koth.current.koth_location:<[location_name]>
    - if <server.has_flag[koth.global.koth_location.<[location_id]>.beacon_glass]>:
      - modifyblock <server.flag[koth.global.koth_location.<[location_id]>.beacon_glass]> green_stained_glass
    - define radius <script[koth_config].data_key[koth_radius]>
    - note <[location].to_ellipsoid[<[radius]>,<[radius]>,<[radius]>]> as:current_koth
    - note <[location].sub[50,200,50].to_cuboid[<[location].add[50,50,50]>]> as:koth_area
    - worldborder <world[orient].players.filter[location.is_in[spawn].not]> center:<[location]> size:50
    - announce <script[koth_config].parsed_key[messages.announce_location]>
    # 6,000t is 5 minutes
    - bossbar create current_koth "title:<[location_name]> (<[round]>/3)" progress:1 color:green players:<server.online_players>
    - define particles <ellipsoid[current_koth].shell.filter[material.name.equals[air]]>
    - repeat 6000:
      - if <[value].mod[20]> == 0:
        - define color <list[green|yellow|red].get[<[value].div[2000].round_up>]>
        - bossbar update current_koth color:<[color]> progress:<element[300].sub[<[value].div[20].round>].div[300]>
        - playeffect at:<[particles]> effect:dragon_breath quantity:1 targets:<server.online_players> offset:0.05
        - flag <ellipsoid[current_koth].players> koth.current.points:++
        - flag <ellipsoid[current_koth].players> koth.global.points:++
      - if !<server.online_players_flagged[koth.current].is_empty>:
        - define leader <server.online_players_flagged[koth.current.points].sort_by_number[flag[koth.current.points]].last>
        - flag server koth.current.leader.name:<[leader].display_name>
        - flag server koth.current.leader.points:<[leader].flag[koth.current.points]>
      - wait 1t
    - bossbar remove current_koth
    - note remove as:koth_area
    - if <[round]> != 3:
      - flag <world[orient].players.filter[location.is_in[spawn].not]> koth_liftoff
      - announce to_flagged:koth_liftoff "<&e>Look straight up and jump to activate flight."
    - flag server koth.current.last_hill:<[location_id]>
    - worldborder <server.online_players> reset
    - if <server.has_flag[koth.global.koth_location.<[location_id]>.beacon_glass]>:
      - modifyblock <server.has_flag[koth.global.koth_location.<[location_id]>.beacon_glass]> red_stained_glass

koth_update_directions:
  type: task
  debug: false
  data:
    font_map:
      "-360": <&chr[6911]>
      "-315": <&chr[6912]>
      "-270": <&chr[6913]>
      "-225": <&chr[6914]>
      "-180": <&chr[6915]>
      "-135": <&chr[6916]>
      "-90": <&chr[6909]>
      "-45": <&chr[6910]>
      "0": <&chr[6911]>
      "45": <&chr[6912]>
      "90": <&chr[6913]>
      "135": <&chr[6914]>
      "180": <&chr[6915]>
      "225": <&chr[6916]>
      "270": <&chr[6909]>
      "315": <&chr[6910]>
      "360": <&chr[6911]>
  script:
    - wait 2t
    - while <ellipsoid[current_koth].exists>:
      - foreach <server.online_players> as:target:
        - if !<[target].is_online>:
          - foreach next
        - define yaw <[target].location.direction[<ellipsoid[current_koth].location>].yaw.sub[<[target].location.yaw>].round_to_precision[45]>
        - flag <[target]> koth.current.direction:<script.parsed_key[data.font_map.<[yaw]>]>
        - if <[loop_index].mod[10]> == 0:
          - wait 1t
      - wait 2t

koth_launcher:
  type: task
  debug: false
  definitions: not_spawn
  script:
    - playsound <player> sound:ENTITY_ENDER_DRAGON_FLAP volume:1
    - look <ellipsoid[current_koth].location.with_y[275]> if:<ellipsoid[current_koth].exists>
    - if <[not_spawn]||false>:
      - adjust <player> gravity:false
      - while <player.has_flag[koth_liftoff]> && <player.is_online> && <player.location.y> < 300:
        - adjust <player> velocity:0,1,0
        - wait 1s
      - adjust <player> gravity:true
    - else:
      - adjust <player> velocity:0,10,0
      - wait 1.5s
    - if !<player.is_online>:
      - stop
    - if <[not_spawn].is_truthy> && !<player.has_flag[koth_liftoff]>:
      - stop
    - define chest <player.equipment.get[3]||air>
    - fakeequip <player> chest:<[chest]> for:<server.online_players>
    - equip <player> chest:elytra
    - adjust <player> velocity:<player.location.direction.vector>
    - wait 1t
    - adjust <player> gliding:true
    - while <player.is_online> && <player.gliding>:
      - wait 1s
    - if <player.is_online>:
      - equip <player> chest:<[chest]>
      - fakeequip <player> reset for:<server.online_players>

koth_win_events:
  type: task
  debug: false
  script:

    # Need to teleport all players to a specific point, and face them towards the winner/winners(on live)
    #   then inject the win treasure drops (the items, like gold, emerald, diamond, etc flying all over them)
    # Noted location at the top of the palace in the throne room

    - define win_sounds <list[ENTITY_FIREWORK_ROCKET_LARGE_BLAST|ENTITY_FIREWORK_ROCKET_BLAST_FAR|ENTITY_FIREWORK_ROCKET_TWINKLE|ENTITY_FIREWORK_ROCKET_LAUNCH]>
    - repeat 6 as:koth_win:
      - playsound <server.online_players> sound:<[win_sounds].random> volume:1
      - wait 5t

koth_spawn_launcher_particles:
  type: task
  debug: false
  script:
    - define blocks <cuboid[spawn_launcher].blocks.filter[y.is[less].than[266]].parse[center]>
    - while <cuboid[spawn_launcher].exists>:
      - playeffect at:<[blocks]> effect:dragon_breath quantity:1 offset:1 velocity:0,0.2,0 targets:<server.online_players>
      - wait 2t
