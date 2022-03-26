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
      - define pool:|:<[type].repeat[<script.data_key[skins.<[type]>.weight]>]>
    - define type <[pool].random>
    - define skin <script.data_key[skins.<[type]>]>
    - wait 1t
    - adjust <context.location> skull_skin:<util.random_uuid>|<[skin]>