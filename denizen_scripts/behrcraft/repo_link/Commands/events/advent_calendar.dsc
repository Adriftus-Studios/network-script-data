advent_calendar:
  type: command
  name: i_demand_pRESENTS
  usage: /i_demand_pRESENTS
  aliases:
    - give_me_presents_santa
    - pls_santa_ive_been_good
    - presentmemyallowance
    - why_does_behr_drink
    - santa_bby
    - christmas_time_yay
    - gimmie_presents
  description: Opens the advent calendar
  script:
    - if !<context.args.is_empty>:
      - inject command_syntax

    - if <util.time_now.month> != 12 || <util.time_now.day> > 25:
      - narrate format:colorize_red "This is only available during the advent calendar period!"
      - stop

    - run open_advent_calendar

open_advent_calendar:
  type: task
  script:
    - define opened_slots <list>
    - define missed_slots <list>
    - define contents <list>
    - define inventory_name <player.uuid>_advent_calendar
    - define color <list[red|blue|green].random>
    - define today <util.time_now.day>

    - if <player.has_flag[behrry.eventful.advent.slots_opened]>:
      - define opened_slots <[opened_slots].include[<player.flag[behrry.eventful.advent.slots_opened]>]>
    - if <player.has_flag[behrry.eventful.advent.missed_slots]>:
      - define missed_slots <[missed_slots].include[<player.flag[behrry.eventful.advent.missed_slots]>]>

    - foreach <util.list_numbers_to[25].exclude[<[opened_slots].exclude[<[missed_slots]>]>]> as:slot:
      - if <[slot]> < <[today]>:
        - flag player behrry.eventful.advent.missed_slots:->:<[slot]>
        - define missed_slots <[missed_slots].include_single[<[slot]>]>

    - foreach <util.list_numbers_to[25]> as:slot:
      - define lore <list>
      - define nbt <list>
      - if <[opened_slots].contains[<[slot]>]>:
        - define skull_skin <script[advent_calendar_boxes].data_key[<[color]>.empty]>
        - define lore "<[lore].include_single[<proc[colorize].context[You've already claimed slot|yellow]> <proc[colorize].context[<&lb><[slot]><&rb>|yellow]>]>"
      - else if <[missed_slots].contains[<[slot]>]>:
        - define skull_skin <script[advent_calendar_boxes].data_key[<[color]>.blank]>
        - define lore "<[lore].include[<&7>You missed this day and|<&7>cannot claim it anymore.]>"
      - else:
        - define skull_skin <script[advent_calendar_boxes].data_key[<[color]>.<[slot]>]>
        - if <[slot]> == <[today]>:
          - define lore "<[lore].include_single[<proc[colorize].context[Click to claim!|green]>]>"
          - define nbt <[nbt].include_single[action/<[slot]>]>
        - else:
          - define lore "<[lore].include[<proc[colorize].context[You can claim this item in:|yellow]>|<proc[colorize].context[<&lb><[slot].sub[<[today]>]> Days<&rb>|yellow]>]>"
          - define lore "<[lore].include[<empty>|<&7>You cannot open|<&7>this item right now.]>"
      - define item "player_head[display_name=<&b>December <[slot]>;lore=<[lore]>;skull_skin=<[skull_skin]>;nbt=<[nbt]>]"
      - define contents <[contents].include_single[air].include_single[<[item]>]>
    - define inventory "<inventory[generic[title=<&3>December <[today]>;contents=<[contents].insert[air|air].at[45]>;size=54]]>"
    - note <[inventory]> as:<[inventory_name]>
    - flag player behrry.eventful.advent.last_day_opened:<[today]>
    - inventory open d:<[inventory_name]>

advent_calendar_handler:
  type: world
  events:
    after player opens *_advent_calendar:
      - define inventory <context.inventory>
      - define empty_slots <util.list_numbers_to[45].parse[mul[2].sub[1]].include[46|47|49|51|53|54]>
      - while <player.open_inventory> == <[inventory]>:
        - define i:++
        - foreach <[empty_slots]> as:slot:
          - if <[i].is_even>:
            - define item lime_stained_glass_pane[display_name=<&f><empty>]
          - else:
            - define item red_stained_glass_pane[display_name=<&f><empty>]
          - inventory set d:<[inventory]> slot:<[slot]> o:<[item]>
        - wait 1s
    on player clicks in *_advent_calendar:
      - if !<context.item.has_nbt[action]>:
        - determine cancelled
      - run advent_calendar_reward def:<context.item.nbt[action]>

advent_calendar_reward:
  type: task
  definitions: slot
  debug: true
  script:
    - inventory close
    - flag player behrry.eventful.advent.slots_opened:->:<[slot]>
    - run locally <[slot]>.script
    - define description <script.data_key[<[slot]>.description]>
    - narrate "<proc[colorize].context[You got:|green]> <proc[colorize].context[<&lb><[description]><&rb>|yellow]>"
  1:
    description: Diamonds!
    script:
      - give diamond quantity:182
  2:
    description: Behr's old Halloween Decorations he forgot to put up (He's not very creative.)
    script:
      - give creeper_head quantity:10
      - give cobweb quantity:400
      - give wither_rose quantity:10
      - wait 3s
      - playsound <player.location> sound:ENTITY_PARROT_IMITATE_GHAST
      - wait 1s
      - narrate "...what was that?"
      - wait 3s
      - spawn ghast|ghast|ghast|ghast|ghast <player.location.above[4]>
  3:
    description: a "SnowMAn"
    script:
      - give panda_spawn_egg quantity:3
      - wait 3s
      - narrate "lol close enough"
  4:
    description: A Partridge in a pear tree! oh wait, minecraft doesn't have birds. okay, uh, A shit-ton of chickens! BWUK BWUK BWUK
    script:
      - repeat 100:
        - spawn <player.location> chicken[custom_name_visible=true;custom_name=<element[BWUK].repeat_as_list[<util.random.int[1].to[7]>].space_separated.rainbow>]
        - wait 1t
  5:
    description: The spirit of BehrCraft
    script:
      - give tnt quantity:640
  6:
    description: Villager Seducers
    script:
      - give emerald quantity:100
  7:
    description: Literally bedrock. Youn got a creative item in survival. Have fun placing it permanently I guess.
    script:
      - give bedrock quantity:64
  8:
    description: A stairway to heaven! aaaaaaaaaaa
    script:
      - modifyblock <player.location.forward_flat[2].points_between[<player.location.forward_flat[2].with_y[256]>].filter[material.name.is[==].to[air]]> ladder
  9:
    description: Carol's Picnic Basket and Crafting Supplies!
    script:
      - foreach white|orange|magenta|light_blue|yellow|lime|pink|white|blue|purple|cyan|brown|red|green|black|light_gray|gray as:color:
        - give <[color]>_dye quantity:<util.random.int[20].to[185]>
  10:
    description: BABY TREES
    script:
      - foreach oak|spruce|birch|jungle|dark_oak|acacia as:tree_type:
        - give <[tree_type]>_sapling quantity:<util.random.int[30].to[110]>
  11:
    description: some kids who politely left eggs at your doorstep after re-evaluating their life decisions
    script:
      - give egg quantity:<util.random.int[100].to[500]>
  12:
    description: Just a few carrots
    script:
      - repeat 10:
        - if <[value]> != 1:
          - narrate format:colorize_green "You find a few more carrots."
        - give carrot quantity:<util.random.int[200].to[500]>
        - wait 10s
  13:
    description: Some anvil?
    script:
      - wait 10s
      - repeat 10:
        - modifyblock <player.location.with_y[<player.location.y.add[50]>]> anvil
        - wait 1s
  14:
    description: Bed-Bug Prank Kit!
    script:
      - give endermite_spawn_egg quantity:<util.random.int[10].to[30]>
  15:
    description: All the fish your parents have ever flushed, revived per<&co> cheesus crisp himself
    script:
      - give pink_shulker_box[inventory_contents=pufferfish_bucket|salmon_bucket|tropical_fish_bucket|cod_bucket|pufferfish_bucket|salmon_bucket|tropical_fish_bucket|cod_bucket|pufferfish_bucket|cod_bucket|pufferfish_bucket|salmon_bucket|tropical_fish_bucket|cod_bucket|pufferfish_bucket|salmon_bucket|tropical_fish_bucket|cod_bucket|tropical_fish_bucket|cod_bucket|pufferfish_bucket|salmon_bucket|tropical_fish_bucket|cod_bucket|pufferfish_bucket|salmon_bucket|tropical_fish_bucket|]
  16:
    description: A nice grief kit
    script:
      - give red_shulker_box[inventory_contents=skeleton_spawn_egg[quantity=2]|wither_skeleton_spawn_egg|skeleton_spawn_egg|wither_skeleton_spawn_egg[quantity=6]|skeleton_horse_spawn_egg[quantity=2]|wither_skeleton_spawn_egg[quantity=6]|skeleton_spawn_egg|wither_skeleton_spawn_egg|skeleton_spawn_egg[quantity=2]|skeleton_spawn_egg[quantity=2]|wither_skeleton_spawn_egg[quantity=6]|wither_skeleton_spawn_egg|skeleton_spawn_egg|wither_skeleton_spawn_egg[quantity=6]|skeleton_spawn_egg|wither_skeleton_spawn_egg|wither_skeleton_spawn_egg[quantity=6]|skeleton_spawn_egg[quantity=2]|skeleton_spawn_egg[quantity=2]|skeleton_horse_spawn_egg[quantity=3]|wither_skeleton_spawn_egg|wither_skeleton_spawn_egg|skeleton_spawn_egg|wither_skeleton_spawn_egg|wither_skeleton_spawn_egg|skeleton_horse_spawn_egg[quantity=3]|skeleton_spawn_egg[quantity=2]|]
  17:
    description: Some netherite Hoes! Surely the most valuable netherite item!
    script:
      - give netherite_hoe quantity:10
  18:
    description: DIAMONDS, YES MOTHER!
    script:
      - give diamond quantity:<util.random.int[200].to[500]>
  19:
    description: Preliminary Naughty Christmas Presents
    script:
      - repeat 27:
        - define list:->:<item[coal].with[quantity=<util.random.int[1].to[64]>]>
      - give black_shulker_box[inventory_contents=<[list]>]
  20:
    description: The spirit of BehrCraft
    script:
      - give tnt quantity:640
  21:
    description: A surprise party from all of your fish friends!
    script:
      - repeat 100:
        - spawn <list[Salmon|Cod|Tropical_Fish]> <player.location.add[<util.random.int[2].to[4]>,0,<util.random.int[2].to[4]>]>
  22:
    description: some MOOnshine
    script:
      - cast BLINDNESS duration:10s
      - cast confusion duration:15s
      - repeat 45:
        - spawn cow <player.location.add[<util.random.int[2].to[4]>,0,<util.random.int[-4].to[4]>]>
  23:
    description: A fat litter of dogs and cats
    script:
      - give wolf_spawn_egg quantity:10
      - give cat_spawn_egg quantity:10
  24:
    description: Golden apples!
    script:
      - give golden_apple quantity:32
  25:
    description: A sincere message from Bear
    script:
      - wait 3s
      - narrate "Hey, listen, so uh. if you're here on BehrCraft on december 25th, you should try and make an effort to do something for christmas"
      - wait 4s
      - narrate "like, this is the one time a year most people just get together to mostly just be together, even if it's not for religious reasons"
      - wait 4s
      - narrate "I might be writing this while having had drank like 12 shots of crown royal, but uh, you deserve attention and affection and uh"
      - wait 4s
      - narrate "you know, just knowing that you don't have to escape your daily life playing Minecraft every day (if you do, even). I personally do"
      - wait 4s
      - narrate "but like i'm living almost a thousand miles away from my family so I might not get to see them for christmas"
      - wait 4s
      - narrate "Taylor needs support while she's away from her family and i'm mostly her only friend so i do that for her"
      - wait 3s
      - narrate "but in the case you're still here, here's some cookies"
      - wait 2s
      - give "cookie[display_name=Gingerbread Cookie]" quantity:<util.random.int[100].to[128]>
      - wait 2s
      - narrate "you deserve the best and if you're here because you don't have anyone to spend a holiday with, you can always reach out to anyone on the discord"
      - wait 5s
      - narrate "we'll always meme hard with you no-matter the day and even if we can't log in with you."
      - wait 10s
      - give diamond quantity:100
      - give netherite_ingot quantity:15


advent_calendar_boxes:
  type: data
  day:
  red:
    empty: 3167ba84-a532-4956-9db3-a312e2aaa12e|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTAzYmQwMDQyMTcyOWNkNjM1Y2QzYjQ4MjQzNDMwYWQ0N2NmNzA3MDE4YTU5MTZmZjU5NTQ5ZDVlY2Q2Zjg3OSJ9fX0=
    blank: e9377959-ae49-4baf-97b0-a9a6d97c886b|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjQ3ZTNlZGQyOWMxYjk2YmNkMjk4YWNmY2YyOTVhYzVmNjFjNjhmNWM2Yzk3ZGMzMmUxMzg4OTZkOGFiNmEyMSJ9fX0=
    1: a3eeecfb-c49f-4aa8-beab-d64b08ea0089|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMTA1YjM1NmJlNjhhYzU2Y2ZlMDYxMWI5NTAyN2FkZjFlZTY3MDUwZTRjZDY2YTBhOTk2NzhmYzJlMjViNmIwZiJ9fX0=
    2: 125d174c-87f7-4e7e-8721-1bc93e66cd6a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNDBlYzQ1ZThmZmI5Y2I3MTRkMTQxMmJiOWVlNTRmZDFlN2EzMTQwYzAyZTM1YWUwZDNmMzA4ZjE2NjZiYTEyNiJ9fX0=
    3: 8219efcc-1194-4d34-afec-e8da4a922b67|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjQ2NjYyOWEzMWFhZTIyZGJhMTVhN2I3MTBhNDUxNzMwODY1NmMxOWJhMzlhODlhYzJkZTI5MTVhNDZlMjgyMyJ9fX0=
    4: dbcbc22b-4651-45e2-bca1-49ff4b910c71|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTdhMTk1NmVkNmYzMmUxOGIxMzlmMmQ3MDkzNTVhYzY5NDVkMGFiOGZlY2QwNGQ0YzE1OWQwODAwNmJmYmU1OCJ9fX0=
    5: 245dc540-7765-4724-af3c-e08c5a0e3402|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODU1ZmFkMDEyYzg4NDRmYzMxMzUxMDQzNmI0OTE5ZTAwMmQ5M2Q2YTA3NjFmN2JkYWY3ODA2OTY4M2VlZTVlNiJ9fX0=
    6: 725be231-de84-4619-881e-85d156c9bf12|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYzA0MDAxMTFhZTAyNjEwMTA3N2I1OWQ4NDgyYzg0YTgzMmM3NGY0ZjIxMDVmYzEzYjdjOTRmNWI4MDAwZWEzIn19fQ==
    7: c419db46-0e58-462d-9fb0-3835a4d2616e|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTM0NTA1ZWQyNTY3ZWEyZWZiYWI0OTk3N2Y3ZGE4ZjExNzhkYjlhZTUzYTBlOTk3MzcyODZkYzU2ZTYzNjM2YSJ9fX0=
    8: 653a901d-a0b0-454a-a2cb-5efd3ea652ca|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTE3ZGRmMTI0ODVmYjU0Y2FiOWM5ZmZiNTVmZWVhNjJhMmQ5MGI4MjU3NzJjNmVhMzg1NjFjZTc1MGNiNmY4MyJ9fX0=
    9: 97aa5f39-e133-4c24-889c-21201c9a0812|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjc1MDIyZmViMTFiNzM2ZTUwYmM3ZDE5ZDI2ZDRlZTAwY2VjZDY3MzRhMjEzOGQyNTc5Zjc5OWIxMTliNjczNCJ9fX0=
    10: 3c4b3d69-e373-46da-9a53-dde3c000d4f0|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmI4NDIwOGU0YmUyMjMzZmNkOTZlN2YwMmQ5NjEzZDU0MzdmMWQwMDYyMzYyNzdjNTdkNDA2NTJjNWJlMmYyMyJ9fX0=
    11: a382bf46-64f5-43ee-8cef-b15ba113d8ea|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMTlhYThhNjViYTI5YjRiN2NiYjljNjZjZjU5ZmI1MzdiYTJjMzAxM2E5NTg2MjBiOTc2YjlmMDYyNDhlOGRkYSJ9fX0=
    12: d9d0df03-60eb-4156-a40f-84e739fa0113|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvN2RjMTMzMGIzMDJlODAwYzMxYzhkZmVmYmQxYjk5NjAxNmMzNDY0OWYzYTM5Njc0OWQzZTA0ODYzNzM2NGFhZCJ9fX0=
    13: e0015060-4a5b-4390-908e-c2f8a43c46dc|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvN2U5OGEzODg0ZTBlYWM5NjdjNzNhMmJjYmZmN2RmNjJhYjJmYjMyN2I0Y2ViOWU2MzZjNzQyNTQ4NjZiNWM3YyJ9fX0=
    14: 1ca3eded-9455-4605-b48e-d61db2670996|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzg2NjY0M2RlY2IyZDE0ODk5OWY5NzY4ZGFlODlmYmRiMTk2YjMwZDU1Zjg4NDZiMWZiYmU3MzZiYjdlNTA0MiJ9fX0=
    15: 7f960663-4666-40bc-bc20-e74cdfb70039|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNzQ0YTk1NjExOTUwY2M3ZjE1NGM5ZjU2YWQ0NzJjMTk0MTM3NmVjMTcxZWZiOGJhNDc2ZTZjZWM0Zjg2NjUyNiJ9fX0=
    16: a63dc781-d04b-4a8f-aaab-e88917c2b0e6|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMTU0Njk1OTU1NmVmZjRiODgyN2NhNTBkOGRmNjg2ZThmMjBkNWM4NDNkYTY4OWRkZGM0OGJmZjBhMjE3ZWZiZSJ9fX0=
    17: 8fe201ae-f4e3-46a9-937a-d684d575e556|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWY0ZmIwMGU4MjRjOTdkOWNmYmE0YzQ0ZGVmMjdhNzk1MTM5Nzg5Nzk1MTUwNDhmMmU2OWViNWI3MTIzYzE1OSJ9fX0=
    18: 944efdef-f0ca-47a9-a844-6e7d76c7f9f6|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTIxNmI0MjAxODAwNGE4NjA4MWI1YzFlZTg3ZGM4ZjEyNzcwZjE4NTkyNjZlMmNkMzU5Yjc1YjQ0YjVlNzY4MCJ9fX0=
    19: 72461bac-7549-4a93-914e-57321fa72286|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTNjNzA5NzI5MTA0MmMzOTQyNjc4OTJjNTZmZWVlOWJhMzkzNjgyNmVhNWIyMjMyZjQ2Y2I1NDc0ZjljZDkzNyJ9fX0=
    20: 12733fad-f63e-4dd5-ba5f-c882760b019e|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGY4NWExMzk3N2QwMTg2NWE5ZDk1ZDMyNzk1MjgyODU4NzI1NTFjMzZmZDUyMzFjN2UzYWI5ODk3YTc1NjBmZCJ9fX0=
    21: e74dc8e4-7d3d-4609-8e0b-02878c5257b1|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2RiNTEyNDAzZjM2MTA5NjZkMTBiZDNjYTlmYzYxZmRjNTAyMTI2ODM4MmY2OTcxOWFjNTY3OWYzZWZkNGMxNCJ9fX0=
    22: 5edf5b42-3773-4e37-b573-a779669515e4|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2FkYWVmODI0NzcxMjUwMzc0ZmMzZTgyZWZlMDIwYWI3NjVlNjY1MzQwY2MyMzkzZjNiNGFlOGQ2ZDE4NTI5YyJ9fX0=
    23: cb789092-a8d7-4e3c-b452-2b4bdce1f039|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjY2Zjg5NmMzN2E5ZDdmYjg1N2ZmOGM5ZjZmNWUzNTQwZDE3ZTFiODkzNDE5ZjUyM2ViMTk5YjcxZTcxZGRlMyJ9fX0=
    24: 5ae8ebc7-bd63-4a13-b406-1ae44e9f0b6b|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjA4MWY5Mjc0ZTRlZjgwMjQ1M2FjOTUzODFjMDA0MjZlNDYyNDQwZDNiYjA4NWZiM2FmZWZhNmRlZDZhOGQwMSJ9fX0=
    25: 86d8381b-de64-4908-acb3-a7b5597e5447|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODVmZGE0MmNhZjE1OWIxMTY0MDQ5Mjk3OTVmMjgxMmNiODAwOTI5ZTM0Y2I0NWJkZGZkMzA4MGFjMjg5ZjdhOSJ9fX0=
  green:
    empty: 70a0834c-2b94-4a0f-978a-ee6d6d12d162|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGZlYTM2YTllNzNhYjNiMDhkNjQ3OWNkMWUwMDA0NDk1ZWYyOTIxMmZhN2NmZjU2YjU1NmZkNDZiMGRkYTcxIn19fQ==
    blank: 3477517f-91b6-4a4c-80d5-f9297c1d4fc6|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmZmMzkwYmFiNmY5ZWJhYzhlOTRjNTVjOWQxZThmNzhlYzcwMTYwZTZiNmUwMjI2ZGZjNGRiOTE5NDU3ZmQzYSJ9fX0=
    1: d2e1a355-cb5f-44d0-a951-2ecfca973186|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjE5MzIxYTE5ZGJhM2YxNmFhYjk4NmIyZmQ5MDVkMTZlNDhmNzQ1YTYxNmFmZDFhYTkxZTY5OGY2NzE4YjNjZCJ9fX0=
    2: c0faf6f0-345d-4012-90d2-8091bb364966|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMmQ4MmFmN2Y2MmZmMWM5MDBhNTYzY2IwYmVlODBhNTM0YTdmMzlhYWQxOWQwY2MxYWM5YjRmN2U2Y2NkMDI1YiJ9fX0=
    3: 8e877540-f021-445a-b36c-7d29af3d0110|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYWZkNjc2NjVmNGE3MTgxOGFkMTBiMmNiYjE2NGVhMmYzMDVkYzY2NzU1M2FlNTNlMmEzZTRhOTg3ZTk0YmI3ZSJ9fX0=
    4: 1e5c31d6-686a-4793-9521-dd37d84405a1|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmQzOWRmNWFhNjZiMTIyZWM2MDM0NGIzN2E2Y2JhOGY3YzY5YjkzOGNjMmJmZTczMjQyODk4ZTVjOWFiM2ViZSJ9fX0=
    5: ff08ce44-d2b4-4079-ae18-4c34c340cfcc|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDIxMGU5NTg4NTJhOTM1NWU0NzBmMGFjZDU2YTEyYjE0NzRiOWNmNjYxODEyMGFhNGViYmMxOWJkOWQxNTdiOCJ9fX0=
    6: 2585ce2c-85a0-445f-a7b3-949448171e60|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjA2Y2U1NzE0NDg4YTMyNGYwOTU1MDZhMmNjYjhlNTlkZjExZDU4NzU3MDE4MDI0YmVhZjI5NzQyZWEyODU3OSJ9fX0=
    7: 74b5f998-90de-41a6-85c8-5752fb34bd1c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTZjNDcxMDU5NWVjM2M3MDM2MmQ5YmYyMDU4M2M4OGY4MGI5ZGFjY2IyMTgyMzA0ZDBmMmZkNTliN2ZkYjQzNSJ9fX0=
    8: 3afc7b01-0abe-4bd1-a638-ef043bdd58e2|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOThlZDZlNzZiNjZkZWIyNjVjZDc4MzAxM2YwYTBjYWY2ZDZiZDQ1NzQ1ZjRlYWFlN2M5MzMzZTYxNTQzMDZmOCJ9fX0=
    9: e063cdeb-a5d6-47ad-a6c0-6f8a1a43ed20|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYmM0NWM4YTUwNDg4MDhiZjM5N2UyOWFmMWRjNzI4NWEyM2U4NmMzYjE5ODdiYTNhNDQyYmYyM2YxYWYxMDIxNSJ9fX0=
    10: 5bd7780c-6baf-40ca-8e1c-db7871e3d284|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjY3MDE2OWQ4NDEwMDk5OGMxMzkwNDM3ZDMwYTY0NWIxYTU5NDQyN2JlMzVlMDdkM2IxZDRmOTU5ZTA3ZmVkMCJ9fX0=
    11: 7edda5ac-ab44-42f1-96ab-97564d838796|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTJiNDQ0NDc0OTY3N2YwN2QyY2YyMTY0Mjg3NDVkYjc4ZDJlMmNlNmYzNjJhMGUzOTYxZjk5ZjE3YTE4ODRlZiJ9fX0=
    12: e66b3fb3-e29a-42ef-af95-4e22f0b3b12c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNDhjN2FmNDBmMTdmMjliNDNhMmJlZmFjMGE3Y2E3YmQ4MTA5YjA2M2M3YzNiY2UzYmRiMDdjZTlmYmZkNDc1ZiJ9fX0=
    13: dd74a512-3ef5-4b18-a9b0-77761a6ff4e3|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjU4ZjYyNjg0YzhmZDJlMWIyZGNiYzI1NjE0ZGYwMWJkNTNmNTQ1MGM0OGIwODUzYWMyNDJmZTk0ZTk2NDQ2NiJ9fX0=
    14: bee289dd-8e1c-4047-86b6-d55b86951297|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg0NGMzYTI0Y2M3YTA1NGNlMjYxYzI2NzdmNjY2OTcyNGZjNDFmZmM4NWUyOGMwMDE0MjhkM2MxMzgwODM3MCJ9fX0=
    15: d9ca2cf8-aed4-42b7-8c76-50e09cc6cb7b|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTc2Y2MzMTAyOWMwMTBlNTY3OTFhOTk5MWNmYmFjODY4NGQyNjgxMDNhNWE5M2JhNzMyNDA4ZmQwNTkwYWRiZSJ9fX0=
    16: 0bdf7133-8892-4076-aca1-e8f2d9a407f2|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMTM1Y2EwNTY5NjNmYjRkNWYxZDE5MjlmZjYzMjExODZmZjliNTJhYmJiZTdkYjBhNDhlNDM5NjBlZjM0ZDE4MyJ9fX0=
    17: 930a7644-3f2c-441c-be63-fb773c90616a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTI5ZTkzYzQ0NjQwNmE0YTg4YWZlYzQyY2QyZmQ3MjNjNmE3ZDExZDcyMzhkZTQ2NmExNTYzNjYxYmM3YjU0YSJ9fX0=
    18: d73de2b6-b42f-46e6-9cea-430faba79d9e|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjdmMTYzNjdjMGQ4ZTk0NDZiYWZkNWRlYmY4YjgxNTk5YTgzMGNkNTUyMDMxNzRjMGFjNDc0NTU4YjhiYjcyZiJ9fX0=
    19: 2fb22b94-da8e-4b9e-97cb-a66a4633b0d2|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTAzZGVmNWVjZDU4NDkwNWU0ZmQ4MGEzNDkxODJjMDEwOTZjMTkxYmI2NmUzNGUyYjE1ZTExMmZjYjY1YzE2MiJ9fX0=
    20: ead7d185-138b-4199-b497-be7c27289b32|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDU4MzFlZmM5NTc0YjVkYmYyN2U2MWE4YzM0MDkzOWEzMzVmNTM5NDRmNzI3NTBjZTNjMGViZmYyYTY3MzNiMSJ9fX0=
    21: 58fd8807-a4d7-4367-a67d-7766ae945d5c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODFmYTg5NWFiYzc0MDAyZDUzMDk1NDA1NjFhZTgzMjZhMDAxZDg3NmMxYzhmYzg0ZWE5NTc5Nzc5NmVmYjZhNyJ9fX0=
    22: 07622d45-9e15-48aa-a8f2-fe947462eed1|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjlmMGJiZmVjNmZhMDgxNDc5Y2EzMjk1MDA0YTU0ZDdlZTQ5ZmNmNzAwNWNmZjkzMGZmMGFmMTRhNzcwMmFlIn19fQ==
    23: 1a607312-a1e5-42c0-892e-38e572c9c30f|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTUzNmFiYjI4NDI5OGIyMWFkZDYwMjM0NzJiYTFhMDYzMDQ2MGQ0YzVhOGEwOGMyZTkyZDA2MGYzYTgxNzJiOSJ9fX0=
    24: 9d1a67dd-5c2a-47d8-8884-50eb8b908d14|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjMyMzQ3NDMwOWNiY2FhOWQwNDkyNjYwOTYzYzZiMjRhMTZmMDZhMjQ2ZGRjY2M5OWE3NjM3ZTlkNDkzMjExZCJ9fX0=
    25: b1e4b74d-2108-4d00-8b13-19c4cdbad19e|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYmNiMzQ0N2RlZDg4MWEyMzc2YmUwZmM1NWM2NTYyMThjNGQ2ZDc3NGMxNzgzNjdmMjg0ZjNlM2UzNjEyNTZmIn19fQ==
  blue:
    empty: 212a7d24-4444-4c90-ab56-e9a7163e3dc1|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjBmNDJlOWU1Y2UxNjFkMWQ3YTY4NTc3NTllYTFjZjI4MDZlOTFkM2JiOWY0NGNhZTIyNjhjMzhlOWM4N2FkZSJ9fX0=
    blank: 1922514b-bd4b-41c4-94bb-a86fd57fc029|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODA1OGQyZDlmNGQ5Y2VhMzFlZDVlNGU4MDZlZTczZjlhNzc0YzM2NjY0YzM3N2MyOGQwMWQzM2Q1OWZmZmE5MiJ9fX0=
    1: 6f1d6da9-da0b-4fa1-afee-5fb259c684d3|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjE0ZGVkOWU2ZDBmMzYyODhkNWRhYjdjMDhjNjRkY2Q2OWI5MjBiZjJmNGYwMTQ2YWRiOGQ2ZDgzMmEwYWE4ZiJ9fX0=
    2: d79dfae2-dc28-4bcd-ba10-d510b71ff792|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2M2N2NlN2UyZGI0NWFjOWRhZmY0NmI4OThiZTJjZmYwOGRjYmZmYTNmYmYyZDY1YzAyN2UwZTYwNmM3N2VkOCJ9fX0=
    3: b46b29d0-33be-456e-a2ba-2d24221dacb1|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTM4YTMwNDU1NWE5YzFlNzA2NzZmZDA5ZTJjMDcyYTY4OTE4Yzc4ZjA3MGU1M2RlZDBjZDU5ZDNjMzRjOGQ3In19fQ==
    4: b42ad14c-87fe-4a24-9494-781d29068351|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTRhM2VhNDZhYzk0NzQyYjRiYTQ2YTBmNGYxMzIzOGM1ZDk3YWU3MDViZWYxMzQzMjY5YmQ3MDI4MGNjNTFhNiJ9fX0=
    5: 004fc27c-cc83-4aa1-9d31-60eb2bee83ec|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzViNWZjNmVkNTFlMDhlNmZmNDU3ZjA5MjJlMjI5NzdjNTk3ZGFiYWI3Y2JiM2YxMzAxNDlkODg2YTI5YSJ9fX0=
    6: c47790a8-4c3f-43f1-91d8-4b4ef51a9e34|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNzkxZTYzMWVlNWFiYzU4ZGIyYTQxNGVlMzg1ZmYzMWIzOWQ1ZGE5NGVkNDk0ZDVlMjVjMWEwMDhjYTVlZWRiMSJ9fX0=
    7: 459a4c98-238e-47a6-94b6-73905b0178ec|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTU2NGU0ODIwNWM4MzQyNGI4NTAzNThiYmM0OThmYzU0ZjQzNjAwZDQ0YWY3MDZiNDY4ZDM0ZjYxNWQ2NzdiNCJ9fX0=
    8: 2d33af1c-1b1b-4220-9b0b-560cb95007e4|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMTljYWI1NWY1N2EzOWNjY2FkNWU5MGYzMTYwM2MwNjk2YmM4Y2UzNDFiNTIwYmQwMWUwMGE4NzIzYTZjNDM4MSJ9fX0=
    9: 3ed0c5d9-0d79-4913-8cbc-689396598d5e|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYmIyZmIzMzg2MTkxZmMxNWJmMTJhNTYxMTk4YWI4YTc3OTYyNjdmMDBkYTE0N2M2NTVmY2FkMjFmOTA5YzY2NiJ9fX0=
    10: e2cff58e-0f7f-4a08-8d2e-af8febf8ea8d|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMmVkNmVlY2ZmM2RmMjM1Yzk4NWI0OTAzZGQ4ZDQ1OTgwYjFlYTMzYTc3NjE5MTUwYmE4NGFiZDYzZjkyNjRhMCJ9fX0=
    11: 2e485862-bbdf-4c99-8249-2e1716cc102d|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYmQ1MTEyNDczMTBkZjJlYzEyNGYwZGEwZWIzNDkyZDlhNDdhNzI1Njg0MTJiMDY0ZjI2MzMyZDM5ZDNlMmNkNCJ9fX0=
    12: 54ee964d-be37-4e19-8c6c-9b97c087fea3|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjg5ZjZmNzc4ZmQ4NzBhNGJlMGRmZGQ4OGI1YzI3OGZmNDdjMTk1MjMxMzIzY2VjYzliMTVjMDYzNTczNTlhMiJ9fX0=
    13: d374a1d9-4978-4161-9553-a4701be7ca20|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTYzYWY5YzgzMjVjYTU2OTg2Y2JmYWZhMzA0NjY1YmMwY2ZmMzJhMDczYTFlNGUxMzIzZjA3OTk4MWIyZjA4YyJ9fX0=
    14: 26f3fc0b-5161-4932-adea-a27cf14b9f24|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzQ5OWQ5MGRhYzBjZjY5NWYzYjFkZWE0ZmRkOTg4Yzk5MmQ3YTg5NDQ4OGExMTVhMjY4ZjM4MGZiOTdkMDI5OSJ9fX0=
    15: ea1cd476-11e4-4cf9-a315-677642abb5d2|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjIyYmFiMDNiOWFjM2Y0NzIxZjFkNjBlNGEyNTc3MDA2MGE4ZTFkYjllYzU4N2NiZjgyYzE2NmQ5MWI2Yzg5MCJ9fX0=
    16: f9703cb0-83d2-4440-b0ad-164e1de1aabf|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOWM3Y2M2YzNlNTI0N2I3N2E5OWRhNjVlY2M4OThiY2RiN2NiNTlkNmNkZGRkMzE0NWZhNDFiYTU5MmJlM2RlMiJ9fX0=
    17: acc349c0-a1bd-4073-84cf-2eaaba2b5f6e|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYWE4YjIyMzc3MTk3OTQwY2M0MmM3YjUxZmIxMmIyYjM0MDIyN2FkMjRmM2Y0ZGI1NmU1ZDY5NTdiYzM5YzA1YyJ9fX0=
    18: 1216ddfb-ed89-4060-b20c-8bb31cb30b88|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjE4ZTQxZWI0NTUzMzFiNWEyNjRjOTQxNmQxM2M1ZDU4MWI5ZjFiZGIyMzIwN2FkMzMxZGE0ZjJjOTU4ZWJjNSJ9fX0=
    19: 3eed23f7-53eb-4d09-9c12-77c8067f2bd8|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOWFiMTMxMzI0NjMyM2M5ODlkYjAzMGI5MDMxM2QwNTRjY2UwOWY2NzU0OGM5ODU5MzYzMDhhYmMyYTBmZjJhMiJ9fX0=
    20: ae5c1cc9-398b-453a-abfa-4be041a6ec3e|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTc2Nzc5YzFhM2Q4ZTBjODE3ZGFiMWMzNzFmZjczOWQ3ODk0YzAxOGNhNDA0YWJjNzE1NGFjZTVmYWVkMjNkZiJ9fX0=
    21: ee99d477-d552-4f3d-80fe-a47f23423b9f|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjllZjYxMzNhMTVjMmNhNDQ1MDM2ZTc1NDZiNDgzODg1YjliYTRlYzU4M2M1YTM3OTllYjE2ZWNmZWIwYWNmOSJ9fX0=
    22: d1825b9b-e293-416f-a33c-74f3d9544262|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZGE5NTc0ODFhN2FjMTYzOTg4YzMxNTBmNzgwNjA1ZmIzMjBhNjIyZGI3MWI5MzM1YmNmNzI5NzMxMzcwYTA3YyJ9fX0=
    23: 73545413-424b-480f-8c77-64ce4544b9bd|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODcyMTRlNWJjN2M5MzA1MGYzOGIyM2FjZmNhNmU1OTE5Nzk0MzIwZjZmMjZkMzgzNmViNzhkMjgxY2I3Y2FmNCJ9fX0=
    24: cb2fed75-cf5d-4fb9-a24f-460b857162ed|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvM2Y2OTM1MTNmZGRhNDI3YTk4ZmFhNDFkZTc1ZTU5MTg5YjlkZWYwZGVmY2E5MWU5NzU4MmUzOTE3NmMxNzc1YSJ9fX0=
    25: 4e8dd99c-d0a9-47bf-ac2e-d48b243bbde7|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZGRmZmY3OGVjNTU2ZDdkNjUyM2ZkMzZiNmZjM2VkZDk1Mzg5M2M4M2U1N2M2ZWYyYzRiNGVlNzk0ODhhYWI5MyJ9fX0=
