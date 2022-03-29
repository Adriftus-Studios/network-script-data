easter_egg_item:
  type: item
  material: player_head
  display name: Easter Egg

easter_egg_events:
  type: world
  debug: false
  skins:
    pink:
      # 20%
      weight: 200
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWNlZGRjMjNmOWQ5NmJhYWEwZDJkN2I5ZWMxODBjZDdiZWE1NDQ3ZDM5YzQyNWNhOWU0NGQ4ODA4ZWExMWVhMCJ9fX0=
    blue:
      # 20%
      weight: 200
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjE1NGJhNDJkMjgyMmY1NjUzNGU3NTU4Mjc4OTJlNDcxOWRlZWYzMjhhYmI1OTU4NGJlNjk2N2YyNWY0OGNiNCJ9fX0=
    red:
      # 20%
      weight: 200
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmUzMmE3ZGU3YTY3MmNjNjhmYTdhMjcyYmFhNmE4OWViZDQ0MGMzMmRjZjQ0ZTc3MDU3MDY4OTg5MDQyZjdjNiJ9fX0=
    blue_striped:
      # 20%
      weight: 200
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmFkMDZmMDRlYTkxYjIzNTI0OWFmZDg4NWY1ZTA0MDIyNDAxZGQ3N2I0NTI2MmE5ZjAyNGU0ZDdiN2E1MWM3OSJ9fX0=
    confetti:
      # 19.9%
      weight: 199
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOWY1NWM1MDVkN2YwMDEzNWI1ZjUyMjViNzVjZDkyZWQxMjIwMWNjOTVjNDFkZWVkOGE3N2RhOGZkNmI3Yjk2MyJ9fX0=
    gold:
      # 0.1%
      weight: 1
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMTUxNTk5ZjY2ZTgzZGE1NTVjZjliOGI3ZTVhMzc5ZDBkZWFiMjFjMmVlZTkwOWQxODM3MzIzZGIwODkzYmYzOCJ9fX0=
  events:
    on player places easter_egg_item:
    - define pool <list[]>
    - foreach <script.data_key[skins].keys> as:type:
      - define pool:|:<element[<[type]>|].repeat[<script.data_key[skins.<[type]>.weight]>].as_list>
    - define type <[pool].random>
    - define skin <script.data_key[skins.<[type]>.skin]>
    - adjust <context.location> skull_skin:<util.random_uuid>|<[skin]>
    - define counter <server.flag[easter_egg.counter].add[1].if_null[1]>
    - flag server easter_egg.counter:<[counter]>
    - flag <context.location> easter_egg.number:<[counter]>
    - flag <context.location> easter_egg.type:<[type]>
    - announce "Placed a <[type]> egg at <context.location.simple>: <[counter]>"
    on player breaks block:
    - stop if:<context.location.has_flag[easter_egg].not>
    - define type <context.location.flag[easter_egg.type]>
    - define counter <server.flag[easter_egg.counter].sub[1].if_null[0]>
    - announce "Breaked a <[type]> egg <context.location.flag[easter_egg.number]>. Counter: <[counter]>"
    - flag <context.location> easter_egg:!
    - flag server easter_egg.counter:-:1
    on player joins:
    - adjust <player> noclip:true
    - if <player.has_permission[easter.see_eggs]>:
      - define all <cuboid[spawn_cuboid].blocks_flagged[easter_egg]>
      - showfake players:<player> air d:<server.flag_expiration[easter_egg.session.active].from_now> <[all].exclude[<server.flag[easter_egg.session.current]>]>
    - else:
      - showfake players:<player> air d:<server.flag_expiration[easter_egg.session.active].from_now> <[all]>
    on player quit:
    - adjust <player> noclip:false
    on delta time hourly:
    # <cuboid[spawn_cuboid].blocks_flagged[easter_egg].filter[material.name.equals[PLAYER_HEAD]].size>
    - run easter_egg_respawn def:1h
    on player right clicks block:
    - stop if:<context.location.flag[easter_egg.active].exists.not.if_null[true]>
    - define duration 1h
    - define type <context.location.flag[easter_egg.type]>
    # - ratelimit <player>_<context.location.block> <server.flag_expiration[easter_egg.active].if_null[<[duration]>]>
    - narrate "<element[You found a <[type].replace[_].with[ ].to_titlecase> Easter Egg.].rainbow>"
    - showfake <context.location> air players:<player> d:<server.flag_expiration[easter_egg.active].if_null[<[duration]>]>
    - playsound sound:entity_experience_orb_pickup volume:10 <player>
    - flag <player> easter_egg.session.found.<[type]>:+:1
    - flag <player> easter_egg.easter_token:+:1

easter_egg_respawn:
  type: task
  definitions: duration
  debug: false
  script:
  - define duration <[duration].if_null[<server.flag_expiration[easter_egg.session.active].from_now.if_null[1h]>]>
  - define quantity_to_spawn 40
  - define all <cuboid[spawn_cuboid].blocks_flagged[easter_egg]>
  - define chosen <[all].random[<[quantity_to_spawn]>]>
  - flag <[all]> easter_egg.active:!
  - showfake players:<server.online_players> air d:<[duration]> <[all]>
  - showfake players:<server.online_players.filter[has_permission[easter.see_eggs]]> cancel <[chosen]>
  - flag <[chosen]> easter_egg.active expire:<[duration]>
  - flag server easter_egg.session.active expire:<[duration]>
  - flag server easter_egg.session.current:<[chosen]>
  - foreach <bungee.list_servers>:
    - bungee <[value]>:
      - announce "The Easter Bunny has planted eggs in hub." to_permission:easter.see_eggs

easter_egg_view_command:
  type: command
  name: see_easter_eggs
  debug: false
  script:
  - stop if:<player.has_permission[easter.command.see_eggs].not>
  - define all <cuboid[spawn_cuboid].blocks_flagged[easter_egg]>
  - showfake <[all]> cancel players:<player>
  - foreach <cuboid[spawn_cuboid].blocks_flagged[easter_egg]>:
    - fakespawn easter_egg_view_point_entity <[value]> d:<server.flag_expiration[easter_egg.session.active].from_now.if_null[1h]>

easter_egg_view_point_entity:
  type: entity
  entity_type: falling_block
  mechanisms:
    fallingblock_type: bedrock
    glowing: true
    gravity: false