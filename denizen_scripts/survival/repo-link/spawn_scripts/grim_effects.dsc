grim_area_effects:
  type: world
  events:
    on player enters spawn_grim_cuboid:
      # $ ---- Debugging ------------------------ #
      - inject player_enters_area_debugging.wrapper
      # $ ---- ---------------------------------- #
      - cast blindness duration:40t no_ambient hide_particles
      - time player 14000
      - adjust <player> stop_sound:music
      - wait 1t
      - playsound <player> sound:MUSIC_DRAGON pitch:1 volume:150 sound_category:music
    on player exits spawn_grim_cuboid:
      # $ ---- Debugging ------------------------ #
      - inject player_enters_area_debugging.wrapper
      # $ ---- ---------------------------------- #
      - cast blindness duration:40t no_ambient hide_particles
      - time player reset
      - adjust <player> stop_sound:music
      - wait 1t
      - playsound <player> sound:<script[spawn_sound_effects_handler].data_key[sounds].as_list.random> pitch:1 volume:150 sound_category:music
