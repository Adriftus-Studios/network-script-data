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
    blue_stripped:
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
    on delta time minutely:
    # <cuboid[spawn_cuboid].blocks_flagged[easter_egg].filter[material.name.equals[PLAYER_HEAD]].size>
    - define duration 1m
    - define all <cuboid[spawn_cuboid].blocks_flagged[easter_egg]>
    - define chosen <[all].random[20]>
    - showfake players:<server.online_players> air d:<[duration]> <[all].exclude[<[chosen]>]>
    - showfake players:<server.online_players> air d:<[duration]> <[chosen]>
    - flag <[chosen]> easter_egg.active expire:<[duration]>
    on player right clicks block:
    - stop if:<context.location.has_flag[easter_egg.active].not>
    - narrate pass