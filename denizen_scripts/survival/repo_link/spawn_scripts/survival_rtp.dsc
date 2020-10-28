survival_rtp:
  type: task
  debug: false
  minimum: 25000
  maximum: 34000
  world: mainland
  script:
    - define min <script.data_key[minimum]>
    - define max <script.data_key[maximum]>
    - define world <script.data_key[world]>
    - define x <util.random.int[<[min]>].to[<[max]>].mul[<list[1|-1].random>]>
    - define z <util.random.int[<[min]>].to[<[max]>].mul[<list[1|-1].random>]>
    - chunkload <location[<[x]>,200,<[z]>,<[world]>].chunk> duration:10s
    - wait 5t
    - narrate "<&a>You have 1 minute of no fall damage."
    - teleport <location[<[x]>,300,<[z]>,<[world]>]>
    - flag player no_fall:true duration:1m
  #^  - if !<yaml[global.player.<player.uuid>].contains[titles.unlocked.explorer]>:
    - if !<yaml[global.player.<player.uuid>].read[titles.unlocked].contains[Explorer]||false>:
      - define id First_RTP
      - inject achievement_give
    - wait 1m
    - narrate "<&c>You now take fall damage as normal."

survival_falloff_rtp:
  type: world
  debug: false
  events:
    after player enters spawn_below:
    - if !<player.has_flag[RecentRTP]>:
      - inject survival_rtp
      - if <location[home_<player.uuid>]||null> != null:
        - flag <player> RecentRTP duration:10m
      - flag <player> RecentRTP duration:60s
      - stop

    - else if <location[home_<player.uuid>]||null> != null:
      - teleport <location[home_<player.uuid>]>
      - narrate "<&a>You have been teleported home! Please wait <player.flag[RecentRTP].expiration.formatted> more before teleportation!"
      - stop

    - teleport spawn
    - narrate "Please wait <player.flag[RecentRTP].expiration.formatted> seconds before teleporting again"

survival_rtp_portal:
  type: world
  debug: false
  events:
    on player enters spawn_cuboid:
      - flag server people_in_spawn:->:<player>
      - time player reset
      - if !<server.has_flag[spawn_portal_running]>:
        - flag server spawn_portal_running:true
        - run spawn_effects_handler
        - run spawn_speed_handler
      - wait 5t
      - inject spawn_sound_effects_handler
    after player exits spawn_cuboid:
      - flag server people_in_spawn:<-:<player>
      - if <server.has_flag[spawn_portal_running]> && <cuboid[spawn_cuboid].players.is_empty>:
        - flag server spawn_portal_running:!
    on player quits:
      - flag server people_in_spawn:<-:<player>
    on server start:
      - flag server spawn_portal_running:!
      - flag server people_in_spawn:!

spawn_effects_handler:
  type: task
  debug: false
  script:
    - while <server.has_flag[spawn_portal_running]> && <server.has_flag[people_in_spawn]>:
      - playeffect totem <server.flag[spawn_totem_locations].random[50]> quantity:1 targets:<server.flag[people_in_spawn]>
      - playeffect redstone at:<server.flag[spawn_cosmetics_blocks].random[3]> special_data:<util.random.decimal[1.5].to[2.5]>|<server.flag[spawn_cosmetics_colors].random> quantity:3 offset:0.25 targets:<server.flag[people_in_spawn]>
      - playeffect soul at:<server.flag[spawn_soul_forge_effects].random[10]> offset:0.2 quantity:1 data:0.2 targets:<server.flag[people_in_spawn]>
      - playeffect soul_fire_flame at:<server.flag[spawn_soul_forge_effects].random[3]> quantity:1 data:0.01 offset:0.25 targets:<server.flag[people_in_spawn]>
      - wait 1t

spawn_speed_handler:
  type: task
  debug: false
  script:
    - while <server.has_flag[spawn_portal_running]> && <server.has_flag[people_in_spawn]>:
      - cast speed duration:3s <server.flag[people_in_spawn].filter[is_online]> hide_particles
      - wait 2s

spawn_sound_effects_handler:
  type: task
  debug: false
  script:
    - adjust <player> stop_sound
    - wait 1t
    - playsound <player> sound:<list[MUSIC_DISC_STRAD|MUSIC_DISC_FAR|MUSIC_DISC_MALL].random> volume:150 sound_category:music
