graves_config:
  type: data
  # Causes include: BLOCK_EXPLOSION, CONTACT, CRAMMING, CUSTOM, DRAGON_BREATH, DROWNING, DRYOUT, ENTITY_ATTACK, ENTITY_EXPLOSION, ENTITY_SWEEP_ATTACK, FALL, FALLING_BLOCK, FIRE, FIRE_TICK, FLY_INTO_WALL, FREEZE, HOT_FLOOR, LAVA, LIGHTNING, MAGIC, MELTING, POISON, PROJECTILE, STARVATION, SUFFOCATION, SUICIDE, THORNS, VOID, and WITHER
  # Explainations of causes can be found here:
  # https://hub.spigotmc.org/javadocs/spigot/org/bukkit/event/entity/EntityDamageEvent.DamageCause.html
  # leave empty to use all causes
  excluded_causes:
    - LAVA
    - SUFFOCATION
  # If you want any worlds to use the normal drop system
  # You can specify them here
  # (The example worlds can be left here without any real concern)
  excluded_worlds:
    - some_random_world
    - another_world
  # This is how long before a grave pops
  # (All the items drop on the ground)
  # NOTE: This only affects future graves, and not ones already created.
  grave_max_duration: 2h
  # Hologram settings
  hologram:
    # Set this to false to disable them
    enabled: true
    # This is the message displayed by the hologram
    # Any Denizen tags can be used here, and any context from "on player dies" event is available.
    # Color codes will automatically be parsed.
    display: "&c<player.name>'s Gravestone."
    # enabling the timer will show how long till a head naturally pops
    # This creates a second hologram.
    timer: true
    # The timer display message can contains colors
    # You can also use any tags
    # <[time]> is the placeholder for the time left.
    timer_display: "&eTime Left: &b<[time]>"
  # Below are the messages output by the script
  messages:
    not_your_grave: "&cYou cannot break someone else's gravestone."
    retrieved_grave: "&aYou have retrieved your gravestone."

hologram:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    marker: true
    visible: false
    custom_name_visible: true

graves_handler:
  type: world
  debug: false
  events:
    after delta time secondly:
      # % ██ [ update grave timers               ] ██
      # todo : test this snippet to replace the foreach
      #- define truthy_holograms <server.flag[graves].filter_tag[<[filter_value].flag[grave.hologram.timer].is_truthy>]>
      #- adjust <[truthy_holograms].parse[flag[grave.hologram.timer]]> custom_name:<[truthy_holograms].parse[flag_expiration[grave.hologram.timer].from_now.formatted]>
      - foreach <server.flag[graves].filter_tag[<[filter_value].flag[grave.hologram.timer].is_truthy>]> as:grave:
        - define time <[grave].flag_expiration[grave]>
        - adjust <[grave].flag[grave.hologram.timer]> custom_name:<script[graves_config].data_key[hologram.timer_display].parse_color.parsed>

    after delta time secondly every:10:
      # % ██ [ remove expired graves             ] ██
      - foreach <server.flag[graves].filter_tag[<[filter_key].chunk.is_loaded>].filter_tag[<[filter_key].flag[grave.hologram.timer].is_truthy>]> as:grave:
        - if <server.flag_expiration[grave].is_after[<util.time_now>]>:
          - chunkload <[grave].chunk> duration:20s if:!<[grave].chunk.is_loaded>
          - remove <[grave].flag[grave.hologram.player_name_display]> if:<[grave].flag[grave.hologram.player_name_display].is_truthy>
          - remove <[grave].flag[grave.hologram.timer]> if:<[grave].flag[grave.hologram.timer].is_truthy>
          - modifyblock <[grave]> air
          - drop <[grave].flag[grave.items]> <[grave]>

    on player dies bukkit_priority:HIGHEST:
      # % ██ [ check if script is to run         ] ██
      - stop if:<script[graves_config].data_key[excluded_causes].contains[<context.cause>]>
      - stop if:<script[graves_config].data_key[excluded_worlds].contains[<player.location.world.name>]>
      - stop if:<context.drops.is_empty>

      # % ██ [ remove drops, create definitions  ] ██
      - define items <context.drops>
      - determine passively NO_DROPS
      - define location <player.location>
      - define duration <script[graves_config].data_key[grave_max_duration]>
      - wait 5t

      # % ██ [ find the lowest air block         ] ██
      - while <[location].below.material.name> == air:
        - define location <[location].below>
      - while <[location].material.name> != air:
        - define location <[location].above>

      # % ██ [ create the gravestone             ] ██
      - modifyblock <[location]> player_head
      - playeffect at:<[location]> effect:LAVA quantity:10 offset:0.2 data:0.1
      - playsound sound:BLOCK_LAVA_EXTINGUISH at:<[location]>
      - adjust <[location]> skull_skin:<player.skull_skin>

      # % ██ [ save the gravestone               ] ██
      - definemap grave:
          items: <[items]>
          owner: <player>
      - flag server graves.<[location]> expire:<[duration]>
      - flag <[location]> grave:<[grave]> expire:<[duration]>

      # % ██ [ create the hologram               ] ██
      - if <script[graves_config].data_key[hologram.enabled]>:
        - spawn hologram[custom_name=<script[graves_config].data_key[hologram.display].parse_color.parsed>] <[location].center.above[0.75]> save:player_name
        - flag <[location]> grave.hologram.player_name_display:<entry[player_name].spawned_entity> expire:<[duration]>

      # % ██ [ create the hologram timer         ] ██
      - if <script[graves_config].data_key[hologram.timer]>:
        - define time <duration[<[duration]>].formatted>
        - spawn hologram[custom_name=<script[graves_config].data_key[hologram.timer_display].parse_color.parsed>] <[location].center.above[0.5]> save:timer_display
        - flag <[location]> grave.hologram.timer:<entry[timer_display].spawned_entity> expire:<[duration]>

    on player breaks player_head location_flagged:grave bukkit_priority:LOWEST:
      # % ██ [ verify owner breaking grave       ] ██
      - if <context.location.flag[grave.owner].uuid> != <player.uuid>:
        - narrate <script[graves_config].data_key[messages.not_your_grave].parse_color.parsed>
        - determine cancelled

      # % ██ [ remove the holograms              ] ██
      - remove <context.location.flag[grave.hologram.player_name_display]> if:<context.location.flag[grave.hologram.player_name_display].is_truthy>
      - remove <context.location.flag[grave.hologram.timer]> if:<context.location.flag[grave.hologram.timer].is_truthy>

      # % ██ [ give the items back to the player ] ██
      - give <context.location.flag[grave.items]>
      - narrate <script[graves_config].data_key[messages.retrieved_grave].parse_color.parsed>
      - flag <context.location> grave:!
      - flag server graves.<context.location>:!
      - determine nothing
