graves_config:
  type: data
  # Causes can be found here:
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


graves_data:
  type: world
  debug: false
  load:
    - if <server.has_file[data/graves.yml]>:
      - yaml id:graves load:data/graves.yml
    - else:
      - yaml id:graves create
      - yaml id:graves savefile:data/graves.yml
  save:
    - ~yaml id:graves savefile:data/graves.yml
  events:
    on server start:
      - inject locally load
    on delta time minutely:
      - inject locally save

graves_handler:
  type: world
  debug: false
  debug: false
  load:
    - if <server.has_file[data/graves.yml]>:
      - yaml id:graves load:data/graves.yml
    - else:
      - yaml id:graves create
      - yaml id:graves savefile:data/graves.yml
  save:
    - ~yaml id:graves savefile:data/graves.yml
  tick:
    - foreach <yaml[graves].list_keys[grave]||<list>>:
      - yaml id:graves set grave.<[value]>.time:--
      - if <yaml[graves].read[grave.<[value]>.time]> < 1:
        - if !<[value].as_location.chunk.is_loaded>:
          - chunkload <[value].as_location.chunk> duration:20s
          - waituntil rate:1s <[value].as_location.chunk.is_loaded||false>
        - if <yaml[graves].contains[grave.<[value]>.hologram1]>:
          - remove <yaml[graves].read[grave.<[value]>.hologram1]>
        - if <yaml[graves].contains[grave.<[value]>.hologram2]>:
          - remove <yaml[graves].read[grave.<[value]>.hologram2]>
        - modifyblock <[value]> air
        - drop <yaml[graves].read[grave.<[value]>.items]> <[value]>
        - yaml id:graves set grave.<[value]>:!
        - stop
      - if <yaml[graves].contains[grave.<[value]>.hologram2]> && <yaml[graves].contains[grave.<[value]>.hologram2]> && <server.entity_is_spawned[<yaml[graves].read[grave.<[value]>.hologram2]>]>:
        - define time <yaml[graves].read[grave.<[value]>.time].as_duration.formatted>
        - adjust <yaml[graves].read[grave.<[value]>.hologram2].as_entity> custom_name:<script[graves_config].data_key[hologram.timer_display].parse_color.parsed>
  events:
    on server start:
      - inject locally load
    on delta time minutely:
      - inject locally save
    on delta time secondly:
      - inject locally tick
    on script reload:
      - if !<yaml.list.contains[graves]>:
        - inject locally load
    on player dies bukkit_priority:HIGHEST:
      - if <script[graves_config].data_key[excluded_causes].contains[<context.cause>]||false>:
        - stop
      - if <script[graves_config].data_key[excluded_worlds].contains[<player.world.name>]||false>:
        - stop
      - if <context.drops.is_empty>:
        - stop
      - if <player.location.y> <= 0:
        - stop
      - define items <context.drops>
      - determine passively NO_DROPS
      - define location <player.location>
      - wait 5t
      - while <[location].below.material.name> == air:
        - define location <[location].below>
      - while <[location].material.name> != air:
        - define location <[location].above>
      - modifyblock <[location]> player_head
      - adjust <[location]> skull_skin:<player.skull_skin>
      - yaml id:graves set grave.<[location].simple>.items:!|:<[items]>
      - yaml id:graves set grave.<[location].simple>.time:<script[graves_config].data_key[grave_max_duration].as_duration.in_seconds>
      - yaml id:graves set grave.<[location].simple>.owner:<player.uuid>
      - if <script[graves_config].data_key[hologram.enabled]>:
        - spawn armor_stand[marker=true;visible=false;custom_name=<script[graves_config].data_key[hologram.display].parse_color.parsed>;custom_name_visible=true] <[location].center.above[0.75]> save:as
        - yaml id:graves set grave.<[location].simple>.hologram1:<entry[as].spawned_entity>
      - if <script[graves_config].data_key[hologram.timer]>:
        - define time <script[graves_config].data_key[grave_max_duration].as_duration.formatted>
        - spawn armor_stand[marker=true;visible=false;custom_name=<script[graves_config].data_key[hologram.timer_display].parse_color.parsed>;custom_name_visible=true] <[location].center.above[0.5]> save:as
        - yaml id:graves set grave.<[location].simple>.hologram2:<entry[as].spawned_entity>
    on player breaks player_head bukkit_priority:LOWEST:
      - if !<yaml[graves].contains[grave.<context.location.simple>]>:
        - stop
      - determine passively cancelled
      - if <yaml[graves].read[grave.<context.location.simple>.owner]> != <player.uuid>:
        - narrate <script[graves_config].data_key[messages.not_your_grave].parse_color>
        - stop
      - if <yaml[graves].contains[grave.<context.location.simple>.hologram1]> && <server.entity_is_spawned[<yaml[graves].read[grave.<context.location.simple>.hologram1]>]>:
        - remove <entity[<yaml[graves].read[grave.<context.location.simple>.hologram1]>]>
      - if <yaml[graves].contains[grave.<context.location.simple>.hologram2]> && <server.entity_is_spawned[<yaml[graves].read[grave.<context.location.simple>.hologram2]>]>:
        - remove <entity[<yaml[graves].read[grave.<context.location.simple>.hologram2]>]>
      - give <yaml[graves].read[grave.<context.location.simple>.items]>
      - narrate <script[graves_config].data_key[messages.retrieved_grave].parse_color>
      - yaml id:graves set grave.<context.location.simple>:!
      - determine NOTHING
