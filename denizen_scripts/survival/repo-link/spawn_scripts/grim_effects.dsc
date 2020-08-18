grim_area_effects:
  type: world
  events:
    on player enters spawn_grim_cuboid:
      - cast blindness duration:40t no_ambient hide_particles
      - time player 14000
      - execute as_server "stopsound <player.name> music" silent
      - wait 1t
      - playsound <player> sound:MUSIC_DRAGON pitch:1 volume:150 sound_category:master
      - playsound <player> sound:custom.death_graveyard sound_category:master volume:0.4 custom
    on player exits spawn_grim_cuboid:
      - cast blindness duration:40t no_ambient hide_particles
      - time player reset
      - execute as_server "stopsound <player.name> music" silent
      - wait 1t
    - playsound <player> sound:<list[MUSIC_DISC_STRAD|MUSIC_DISC_FAR|MUSIC_DISC_MALL].random> volume:150 sound_category:music
