daily_vote_gui:
  type: inventory
  debug: false
  inventory: chest
  title: Daily Vote Crate
  size: 27
  slots:
    - [red_stained_glass_pane[display_name=<&e>]] [blue_stained_glass_pane[display_name=<&e>]] [magenta_stained_glass_pane[display_name=<&e>]] [orange_stained_glass_pane[display_name=<&e>]] [purple_stained_glass_pane[display_name=<&e>]] [yellow_stained_glass_pane[display_name=<&e>]] [lime_stained_glass_pane[display_name=<&e>]] [pink_stained_glass_pane[display_name=<&e>]] [cyan_stained_glass_pane[display_name=<&e>]]
    - [<proc[gen_daily]>] [reward] [<proc[gen_daily]>] [<proc[gen_daily]>] [<proc[gen_daily]>] [<proc[gen_daily]>] [<proc[gen_daily]>] [<proc[gen_daily]>] [<proc[gen_daily]>]
    - [red_stained_glass_pane[display_name=<&e>]] [blue_stained_glass_pane[display_name=<&e>]] [magenta_stained_glass_pane[display_name=<&e>]] [orange_stained_glass_pane[display_name=<&e>]] [purple_stained_glass_pane[display_name=<&e>]] [yellow_stained_glass_pane[display_name=<&e>]] [lime_stained_glass_pane[display_name=<&e>]] [pink_stained_glass_pane[display_name=<&e>]] [cyan_stained_glass_pane[display_name=<&e>]]

daily_gui_open:
  type: task
  debug: false
  script:
    - flag player vote_spinner
    - note <inventory[daily_vote_gui]> as:lotto_<player.uuid>
    - define inventory <inventory[lotto_<player.uuid>]>
    - inject daily_loot_contents
    - inventory open d:lotto_<player.uuid>
    - inventory set slot:11 d:<[inventory]> o:<[reward_slot]>
    - define shift <util.random.int[1].to[9]>
    - define list <[inventory].slot[<util.list_numbers_to[9].parse[add[<[shift]>].mod[9].add[1]]>]>
    - inventory set slot:1 d:<[inventory]> o:<[list]>
    - wait 1t
    - repeat 5 as:i:
      - repeat 9:
        - define list <[inventory].slot[<util.list_numbers_to[9].parse[mod[9].add[1]]>]>
        - inventory set slot:1 d:<[inventory]> o:<[list]>
        - inventory set slot:10 d:<[inventory]> o:<[inventory].slot[<util.list_numbers_to[9].parse[mod[9].add[10]]>]>
        - inventory set slot:19 d:<[inventory]> o:<[list]>
        - playsound <player> sound:UI_BUTTON_CLICK volume:0.25
        - wait <[i]>t
    - repeat 5 as:i:
      - repeat 3:
        - define list <[inventory].slot[<util.list_numbers_to[9].parse[mod[9].add[1]]>]>
        - inventory set slot:1 d:<[inventory]> o:<[list]>
        - inventory set slot:10 d:<[inventory]> o:<[inventory].slot[<util.list_numbers_to[9].parse[mod[9].add[10]]>]>
        - inventory set slot:19 d:<[inventory]> o:<[list]>
        - playsound <player> sound:UI_BUTTON_CLICK volume:0.25
        - wait <[i].add[3]>t
    - wait 10t
    - define indicator <util.list_numbers_to[27].exclude[5|23|10|11|12|13|14|15|16|17|18]>
    - repeat 2:
      - foreach <[indicator]> as:slot:
        - inventory set slot:<[slot]> d:<[inventory]> "o:blue_stained_glass_pane[display_name=<&e> ]"
      - inventory set slot:5 d:<[inventory]> "o:green_stained_glass_pane[display_name=<&e> ]"
      - inventory set slot:23 d:<[inventory]> "o:green_stained_glass_pane[display_name=<&e> ]"
      - playsound <player> sound:ENTITY_EXPERIENCE_ORB_PICKUP pitch:0.25
      - wait 10t
      - foreach <[indicator]> as:slot:
        - inventory set slot:<[slot]> d:<[inventory]> "o:yellow_stained_glass_pane[display_name=<&e> ]"
      - inventory set slot:5 d:<[inventory]> "o:lime_stained_glass_pane[display_name=<&e> ]"
      - inventory set slot:23 d:<[inventory]> "o:lime_stained_glass_pane[display_name=<&e> ]"
      - playsound <player> sound:ENTITY_EXPERIENCE_ORB_PICKUP pitch:0.25
      - wait 10t
    - give <[reward]> quantity:<[quantity]>
    - if <[win_action]> == narrate:
      - narrate <[win_message]>
    - if <[win_action]> == announce:
      - announce <[win_message]>
      - repeat 5:
        - firework <player.location> random trail flicker primary:<list[red|orange|yellow|lime|green|light_blue|cyan|blue|purple|magenta|pink|white|gray|light_gray|black|brown].random> fade:<list[red|orange|yellow|lime|green|light_blue|cyan|blue|purple|magenta|pink|white|gray|light_gray|black|brown].random> power:<util.random.int[1].to[3]>
        - wait 1t
        - firework <player.location> random trail flicker primary:<list[red|orange|yellow|lime|green|light_blue|cyan|blue|purple|magenta|pink|white|gray|light_gray|black|brown].random> fade:<list[red|orange|yellow|lime|green|light_blue|cyan|blue|purple|magenta|pink|white|gray|light_gray|black|brown].random> power:<util.random.int[1].to[3]>
        - wait 1t
        - firework <player.location> random trail flicker primary:<list[red|orange|yellow|lime|green|light_blue|cyan|blue|purple|magenta|pink|white|gray|light_gray|black|brown].random> fade:<list[red|orange|yellow|lime|green|light_blue|cyan|blue|purple|magenta|pink|white|gray|light_gray|black|brown].random> power:<util.random.int[1].to[3]>
        - wait 5t
    - flag player vote_spinner:!


daily_loot_contents:
  type: task
  debug: true
  script:
    - define chance <util.random.int[1].to[100]>
    - choose <[chance]>:
      - case 1 2 3 4 5 6 7 8 9 10:
        - define reward_slot filled_xp_vessel_level_5
        - define win_action narrate
        - define win_message "<&e>You won 2 <item[filled_xp_vessel_level_5].display>s<&e>!"
        - define reward filled_xp_vessel_level_5
        - define quantity 2
      - case 11 12 13 14 15:
        - define reward_slot "dragon_breath[lore=<&e>The essence of pure corruption. Do not drink.]"
        - define win_action narrate
        - define win_message "<&e>You won a Dragon's Breath!"
        - define reward dragon_breath
        - define quantity 1
      - case 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 45:
        - define reward_slot "dried_kelp[display_name=<&a>$500;lore=<&e>It's 500 buckarinos!]"
        - define win_action narrate
        - define win_message "<&e>You won <&a>$500<&e>!"
        - define reward money
        - define quantity 500
      - case 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65:
        - define reward_slot "enchanted_book[display_name=<&b>Random Enchanted Book;lore=<&e>I wonder which it will be!!]"
        - define choose_enchant <util.random.int[1].to[35]>
        - define enchantment <script.data_key[enchantment_list.<[choose_enchant]>.name]>
        - define level <script.data_key[enchantment_list.<[choose_enchant]>.max_level]>
        - define win_action narrate
        - define win_message "<&e>You won an <&f>Enchanted Book (<[enchantment].replace[_].with[ ].to_titlecase>)"
        - define reward enchanted_book[enchantments=<[enchantment]>,<[level]>]
        - define quantity 1
      - case 66:
        - define reward_slot "nether_star[display_name=<&6>Legendary item!;lore=<&e>Will you actually get this?]"
        - define win_action announce
        - define item_selection <util.random.int[1].to[2]>
        - choose <[item_selection]>:
          - case 1:
            - define reward legendary_item_behr_claw
          - case 2:
            - define reward legendary_item_devin_bucket
        - define win_message "<player.display_name><&e> just won a <item[<[reward]>].display><&e>!"
        - define quantity 1
      - case 67 68 69 70 71:
        - define reward_slot "netherite_scrap[lore=<&e>Probably the safest way to get this.]"
        - define win_action narrate
        - define win_message "<&e>You won a <&f>Netherite Scrap<&e>!"
        - define reward netherite_scrap
        - define quantity 1
      - case 72 73 74:
        - define reward_slot teleportation_crystal
        - define win_action announce
        - define reward teleportation_crystal
        - define win_message "<player.display_name><&e> just won a <item[<[reward]>].display><&e>!"
        - define quantity 1
      - case 75 76 77:
        - define reward_slot mob_spawner_fragment
        - define win_action annouce
        - define reward mob_spawner_fragment
        - define win_message "<player.display_name><&e> just won 25 <item[<[reward]>].display><&e>!"
        - define quantity 5
      - case 78 79 80 81 75 76 77:
        - define reward_slot "golden_apple[lore=<&e>Don't break a tooth!]"
        - define win_action narrate
        - define win_message "<&e>You won two <&b>Golden Apples<&e>!"
        - define reward golden_apple
        - define quantity 2
      - case 82 83 84 85 86 87 88 89:
        - define reward_slot Backpack_9
        - define win_action narrate
        - define reward backpack_9
        - define win_message "<&e>You won a <item[<[reward]>].display> (9)<&e>!"
        - define quantity 1
      - case 90 91:
        - define reward_slot Backpack_18
        - define win_action narrate
        - define reward backpack_18
        - define win_message "<&e>You won a <item[<[reward]>].display> (18)<&e>!"
        - define quantity 1
      - case 95 96 97 98 99 100 92 93 94 :
        - define reward_slot "player_head[display_name=<&b>Food Crate;lore=<&e>Provides a heck of a meal!;skull_skin=23c5b3f8-6ab5-464e-85e5-5c28ab9b893c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7ImlkIjoiZjk1NjQ0NTgwN2QwNDJjOWI0OThjMGQ1NzZkYmNkYjEiLCJ0eXBlIjoiU0tJTiIsInVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjRkYTgzMDYwOTJjYzU0YWNlZDYyY2UyNjNmZjFmNTc0YTFmODkwZWE1OGRjNDMwMzBiYTUwNzk3MjZiYWIzOSIsInByb2ZpbGVJZCI6IjY5YzUxMDg3ODAzYjQ4NDViZWYxMTZlMTJjN2VhMjI1IiwidGV4dHVyZUlkIjoiYjRkYTgzMDYwOTJjYzU0YWNlZDYyY2UyNjNmZjFmNTc0YTFmODkwZWE1OGRjNDMwMzBiYTUwNzk3MjZiYWIzOSJ9fSwic2tpbiI6eyJpZCI6ImY5NTY0NDU4MDdkMDQyYzliNDk4YzBkNTc2ZGJjZGIxIiwidHlwZSI6IlNLSU4iLCJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2I0ZGE4MzA2MDkyY2M1NGFjZWQ2MmNlMjYzZmYxZjU3NGExZjg5MGVhNThkYzQzMDMwYmE1MDc5NzI2YmFiMzkiLCJwcm9maWxlSWQiOiI2OWM1MTA4NzgwM2I0ODQ1YmVmMTE2ZTEyYzdlYTIyNSIsInRleHR1cmVJZCI6ImI0ZGE4MzA2MDkyY2M1NGFjZWQ2MmNlMjYzZmYxZjU3NGExZjg5MGVhNThkYzQzMDMwYmE1MDc5NzI2YmFiMzkifSwiY2FwZSI6bnVsbH0=]"
        - define win_action narrate
        - define reward food_crate
        - define win_message "<&e>You won a <item[<[reward]>].display><&e>!"
        - define quantity 1

  enchantment_list:
    1:
      name: aqua_affinity
      max_level: 1
    2:
      name: bane_of_arthropods
      max_level: 5
    3:
      name: blast_protection
      max_level: 4
    4:
      name: channeling
      max_level: 1
    5:
      name: depth_strider
      max_level: 3
    6:
      name: efficiency
      max_level: 5
    7:
      name: feather_falling
      max_level: 4
    8:
      name: fire_aspect
      max_level: 2
    9:
      name: fire_protection
      max_level: 4
    10:
      name: flame
      max_level: 1
    11:
      name: fortune
      max_level: 3
    12:
      name: frost_walker
      max_level: 2
    13:
      name: impaling
      max_level: 5
    14:
      name: infinity
      max_level: 1
    15:
      name: knockback
      max_level: 3
    16:
      name: looting
      max_level: 3
    17:
      name: loyalty
      max_level: 3
    18:
      name: luck_of_the_sea
      max_level: 3
    19:
      name: lure
      max_level: 3
    20:
      name: mending
      max_level: 1
    21:
      name: multishot
      max_level: 1
    22:
      name: piercing
      max_level: 4
    23:
      name: power
      max_level: 5
    24:
      name: projectile_protection
      max_level: 4
    25:
      name: protection
      max_level: 4
    26:
      name: punch
      max_level: 2
    27:
      name: quick_charge
      max_level: 3
    28:
      name: riptide
      max_level: 3
    29:
      name: sharpness
      max_level: 5
    30:
      name: silk_touch
      max_level: 1
    31:
      name: smite
      max_level: 5
    32:
      name: soul_speed
      max_level: 4
    33:
      name: sweeping_edge
      max_level: 3
    34:
      name: thorns
      max_level: 3
    35:
      name: unbreaking
      max_level: 3

gen_daily:
  type: procedure
  debug: true
  script:
  - define item_chosen <list[exp|dragons_breath|money|random_book|legendary_item|netherite_scrap|teleportation_crystal|spawner_fragment|backpack_9|backpack_18|random_food|golden_apple].random>
  - define item_base <script[daily_rewards_key].parsed_key[reward.<[item_chosen]>.item]>
  - define item_name <script[daily_rewards_key].parsed_key[reward.<[item_chosen]>.name]>
  - define item_lore <script[daily_rewards_key].parsed_key[reward.<[item_chosen]>.lore]>
  - if <script[daily_rewards_key].parsed_key[reward.<[item_chosen]>.model]||false> != false:
      - define item_model <script[daily_rewards_key].parsed_key[reward.<[item_chosen]>.model]>
      - determine <item[<[item_base]>].with[display_name=<[item_name]>;lore=<[item_lore]>;custom_model_data=<[item_model]>]>
  - if <script[daily_rewards_key].parsed_key[reward.<[item_chosen]>.texture]||false> != false:
    - define item_texture <script[daily_rewards_key].parsed_key[reward.<[item_chosen]>.texture]>
    - determine <item[<[item_base]>].with[display_name=<[item_name]>;lore=<[item_lore]>;skull_skin=<[item_texture]>]>
  - determine <item[<[item_base]>].with[display_name=<[item_name]>;lore=<[item_lore]>]>


daily_rewards_key:
  type: data
  reward:
    exp:
      item: experience_bottle
      name: <&f>Filled Experience Vessel
      lore: <&e>Will give 55 XP (level 0-5) when used.
    dragons_breath:
      item: dragon_breath
      name: <&e>Dragon's Breath
      lore: <&e>The essence of pure corruption itself. Do not drink.
    money:
      item: dried_kelp
      name: "<&a>$500!"
      lore: <&e>It's 500 buckarinos!
    random_book:
      item: enchanted_book
      name: <&b>Random Enchanted Book
      lore: <&e>I wonder what one you'll get!
    legendary_item:
      item: nether_star
      name: <&6>Legendary item!
      lore: <&e>Will you actually got this?
    netherite_scrap:
      item: netherite_scrap
      name: <&f>Netherite Scrap
      lore: <&e>Probably the safest way to get one of these
    teleportation_crystal:
      item: firework_star
      name: <&b><&o>Teleportation Crystal
      lore: <&3>Right Click to open up the teleportation menu.
    spawner_fragment:
      item: prismarine_shard
      name: <&b>Spawner fragments
      lore: <&e>A few more of these and maybe you can charge it up.
      model: 1
    backpack_9:
      item: chest
      name: <&a>Backpack
      lore: <&e>Slots<&co> <&a>9
    backpack_18:
      item: chest
      name: <&a>Backpack
      lore: <&e>Slots<&co> <&a>18
    golden_apple:
      item: golden_apple
      name: <&b>Golden Apple
      lore: <&e>Don't break a tooth!
    random_food:
      item: player_head
      name: <&b>Food Crate
      lore: <&e>Provides a heck of a meal!
      texture: 23c5b3f8-6ab5-464e-85e5-5c28ab9b893c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7ImlkIjoiZjk1NjQ0NTgwN2QwNDJjOWI0OThjMGQ1NzZkYmNkYjEiLCJ0eXBlIjoiU0tJTiIsInVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjRkYTgzMDYwOTJjYzU0YWNlZDYyY2UyNjNmZjFmNTc0YTFmODkwZWE1OGRjNDMwMzBiYTUwNzk3MjZiYWIzOSIsInByb2ZpbGVJZCI6IjY5YzUxMDg3ODAzYjQ4NDViZWYxMTZlMTJjN2VhMjI1IiwidGV4dHVyZUlkIjoiYjRkYTgzMDYwOTJjYzU0YWNlZDYyY2UyNjNmZjFmNTc0YTFmODkwZWE1OGRjNDMwMzBiYTUwNzk3MjZiYWIzOSJ9fSwic2tpbiI6eyJpZCI6ImY5NTY0NDU4MDdkMDQyYzliNDk4YzBkNTc2ZGJjZGIxIiwidHlwZSI6IlNLSU4iLCJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2I0ZGE4MzA2MDkyY2M1NGFjZWQ2MmNlMjYzZmYxZjU3NGExZjg5MGVhNThkYzQzMDMwYmE1MDc5NzI2YmFiMzkiLCJwcm9maWxlSWQiOiI2OWM1MTA4NzgwM2I0ODQ1YmVmMTE2ZTEyYzdlYTIyNSIsInRleHR1cmVJZCI6ImI0ZGE4MzA2MDkyY2M1NGFjZWQ2MmNlMjYzZmYxZjU3NGExZjg5MGVhNThkYzQzMDMwYmE1MDc5NzI2YmFiMzkifSwiY2FwZSI6bnVsbH0=

daily_vote_gui_events:
  type: world
  events:
    on player closes weekly_vote_gui flagged:vote_roulette:
      - inventory open d:lotto_<player.uuid>
    on player clicks item in daily_vote_gui|weekly_vote_gui priority:100:
      - determine passively cancelled
    on player closes daily_vote_gui flagged:vote_roulette:
      - inventory open d:lotto_<player.uuid>

weekly_vote_gui:
  type: inventory
  debug: false
  inventory: chest
  size: 45
  title: Weekly Vote Crate
  slots:
    - [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]]
    - [black_stained_glass_pane[display_name=<&e> ]] [<proc[gen_weekly]>] [<proc[gen_weekly]>] [<proc[gen_weekly]>] [<proc[gen_weekly]>] [<proc[gen_weekly]>] [<proc[gen_weekly]>] [<proc[gen_weekly]>] [black_stained_glass_pane[display_name=<&e> ]]
    - [black_stained_glass_pane[display_name=<&e> ]] [<proc[gen_weekly]>] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [<proc[gen_weekly]>] [black_stained_glass_pane[display_name=<&e> ]]
    - [black_stained_glass_pane[display_name=<&e> ]] [<proc[gen_weekly]>] [<proc[gen_weekly]>] [<proc[gen_weekly]>] [<proc[gen_weekly]>] [<proc[gen_weekly]>] [reward] [<proc[gen_weekly]>] [black_stained_glass_pane[display_name=<&e> ]]
    - [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]] [black_stained_glass_pane[display_name=<&e> ]]

weekly_gui_open:
  type: task
  debug: true
  script:
    - define colorlist <list[red|orange|yellow|lime|light_blue|pink]>
    - define glass_item "<item[<[colorlist].first>_stained_glass_pane].with[display_name=<&e> ]>"
    - flag player vote_spinner
    - note <inventory[weekly_vote_gui]> as:lotto_<player.uuid>
    - define inventory <inventory[lotto_<player.uuid>]>
    - inject weekly_loot_contents
    - inventory open d:lotto_<player.uuid>
    - inventory set slot:34 d:<[inventory]> o:<[reward_slot]>
    - narrate <[chance]>
    - narrate <[reward]>
    - repeat 6 as:i:
      - repeat 10:
        - define slotsaver <[inventory].slot[11]>
        - inventory set slot:11 d:<[inventory]> o:<[inventory].slot[12|13|14|15|16|17]>
        - inventory set slot:17 d:<[inventory]> o:<[inventory].slot[26]>
        - inventory set slot:26 d:<[inventory]> o:<[inventory].slot[35]>
        - inventory set slot:30 d:<[inventory]> o:<[inventory].slot[29|30|31|32|33|34]>
        - inventory set slot:29 d:<[inventory]> o:<[inventory].slot[20]>
        - inventory set slot:20 d:<[inventory]> o:<[slotsaver]>
        - playsound <player> sound:UI_BUTTON_CLICK volume:0.25
        - wait <[i]>t
    - repeat 6 as:i:
      - repeat 3:
        - define slotsaver <[inventory].slot[11]>
        - inventory set slot:11 d:<[inventory]> o:<[inventory].slot[12|13|14|15|16|17]>
        - inventory set slot:17 d:<[inventory]> o:<[inventory].slot[26]>
        - inventory set slot:26 d:<[inventory]> o:<[inventory].slot[35]>
        - inventory set slot:30 d:<[inventory]> o:<[inventory].slot[29|30|31|32|33|34]>
        - inventory set slot:29 d:<[inventory]> o:<[inventory].slot[20]>
        - inventory set slot:20 d:<[inventory]> o:<[slotsaver]>
        - playsound <player> sound:UI_BUTTON_CLICK volume:0.25
        - wait <[i].add[4]>t
    - wait 10t
    - inventory set slot:11 d:<[inventory]> "o:<item[black_stained_glass_pane].with[display_name=<&e> ].repeat_as_list[8]>"
    - inventory set slot:17 d:<[inventory]> "o:<item[black_stained_glass_pane].with[display_name=<&e> ]>"
    - inventory set slot:26 d:<[inventory]> "o:<item[black_stained_glass_pane].with[display_name=<&e> ]>"
    - inventory set slot:29 d:<[inventory]> "o:<item[black_stained_glass_pane].with[display_name=<&e> ].repeat_as_list[3]>"
    - inventory set slot:33 d:<[inventory]> "o:<item[black_stained_glass_pane].with[display_name=<&e> ].repeat_as_list[3]>"
    - inventory set slot:20 d:<[inventory]> "o:<item[black_stained_glass_pane].with[display_name=<&e> ]>"
    - repeat 18:
      - inventory set slot:1 d:<[inventory]> o:<[glass_item].repeat_as_list[10]>
      - inventory set slot:18 d:<[inventory]> o:<[glass_item].repeat_as_list[2]>
      - inventory set slot:27 d:<[inventory]> o:<[glass_item]>
      - inventory set slot:36 d:<[inventory]> o:<[glass_item]>
      - inventory set slot:37 d:<[inventory]> o:<[glass_item].repeat_as_list[9]>
      - inventory set slot:28 d:<[inventory]> o:<[glass_item]>
      - inventory set slot:21 d:<[inventory]> o:<[glass_item].repeat_as_list[5]>
      - define colorlist <[colorlist].insert[<[colorlist].first>].at[7].remove[first]>
      - define glass_item "<item[<[colorlist].first>_stained_glass_pane].with[display_name=<&e> ]>"
      - wait 2t
    - give <[reward]> quantity:<[quantity]>
    - if <[win_action]> == narrate:
      - narrate <[win_message]>
    - if <[win_action]> == announce:
      - announce <[win_message]>
      - repeat 5 as:f:
        - repeat <[f]>:
          - define fade <color[255,0,0].with_hue[<util.random.int[1].to[255]>]>
          - define primary <color[255,0,0].with_hue[<util.random.int[1].to[255]>]>
          - firework <player.location.find.surface_blocks.within[8].random> random trail flicker primary:<[primary]> fade:<[fade]> power:<util.random.int[0].to[3]>
          - wait <[f]>t
        - wait 5t
    - flag player vote_spinner:!

weekly_loot_contents:
  type: task
  debug: true
  script:
    - define chance <util.random.int[1].to[100]>
    - choose <[chance]>:
      - case 1 2 3 4 5:
        - define reward_slot "name_tag[display_name=<&b>Title Voucher;lore=<&c>I wonder which it will be!!]"
        - define win_action announce
        - define title <yaml[daily_reward].read[items_to_win.titles].random>
        - narrate "<&e>You won a title<&co> <&b><yaml[titles].read[titles.<[title]>.tag].parse_color.parsed><&e>!"
        - define win_message "<player.display_name><&e> just won a <&b>Title Voucher <&e>(<yaml[titles].read[titles.<[title]>.tag].parse_color>)!"
        - define reward "<item[title_voucher].with[display_name=<&b>Title Voucher<&co> <yaml[titles].read[titles.<[title]>.tag].parse_color>;lore=<&e>Right Click to Redeem;nbt=title/<[title]>]>"
        - define quantity 1
      - case 6 7 8 9 10:
        - define reward_slot "name_tag[display_name=<&b>Bowtrail Voucher;lore=<&d>I wonder which it will be!!]"
        - define win_action announce
        - define bow_trail <yaml[daily_reward].read[items_to_win.bow_trail].random>
        - define win_message "<player.display_name><&e> just won a <&b>Bowtrail Voucher <&e>(<yaml[bowtrails].read[bowtrails.<[bow_trail]>.name].parse_color.parsed>)!"
        - define reward "<item[bowtrail_voucher].with[display_name=<&b>Bow Trail Voucher<&co> <yaml[bowtrails].read[bowtrails.<[bow_trail]>.name].parse_color>;lore=<&e>Right Click to Redeem;nbt=trail/<[bow_trail]>]>"
        - define quantity 1
      - case 11 12 13 14 15:
        - define reward_slot "nether_star[display_name=<&6>Legendary item!;lore=<&e>Will you actually get this?]"
        - define win_action announce
        - define item_selection <util.random.int[1].to[2]>
        - choose <[item_selection]>:
          - case 1:
            - define reward legendary_item_behr_claw
          - case 2:
            - define reward legendary_item_devin_bucket
        - define win_message "<player.display_name><&e> just won a <item[<[reward]>].display><&e>!"
        - define quantity 1
      - case 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40:
        - define reward_slot "dried_kelp[display_name=<&a>$7000;lore=<&e>It's 7000 big ones!]"
        - define win_action narrate
        - define win_message "<&e>You won <&a>$7000<&e>!"
        - define reward money
        - define quantity 7000
      - case 41 42 43 44 45 46 47 48 49 50:
        - define reward_slot teleportation_crystal
        - define win_action narrate
        - define reward teleportation_crystal
        - define win_message "<&e>You won a <item[<[reward]>].display><&e>!"
        - define quantity 4
      - case 51 52 53 54 55 56 57 58 59 60:
        - define reward_slot "enchanted_golden_apple[display_name=<&b>Notch Apple;lore=<&e>Tasty!]"
        - define win_action narrate
        - define win_message "<&e>You won two <&d>Enchanted Golden Apples<&e>!"
        - define reward enchanted_golden_apple
        - define quantity 2
      - case 61 62 63 64 65:
        - define reward_slot head_chooser_token
        - define win_action announce
        - define reward head_chooser_token
        - define win_message "<player.display_name><&e> just won a <item[<[reward]>].display>!"
      - case 66 67 68 69 70:
        - define reward_slot "netherite_ingot[lore=<&e>Probably the safest way to get this.]"
        - define win_action narrate
        - define win_message "<&e>You won two <&f>Netherite Ingots<&e>!"
        - define reward netherite_ingot
        - define quantity 2
      - case 71 72 73 74 75 :
        - define reward_slot Backpack_36
        - define win_action narrate
        - define reward backpack_36
        - define win_message "<&e>You won a <item[<[reward]>].display> (36)<&e>!"
        - define quantity 1
      - case 76 77 78 79 80 81 82 83 84 85:
        - define reward_slot Backpack_18
        - define win_action narrate
        - define reward backpack_18
        - define win_message "<&e>You won a <item[<[reward]>].display> (18))<&e>!"
        - define quantity 1
      - case 86 87 88 89 90:
        - define reward_slot "gold_block[display_name=<&b>Claim Expansion Token;lore=<&e>Good for 1 claim expansion!]"
        - define win_action announce
        - define win_message "<&e>You won a <&b>Claim Expansion Token<&e>!"
        - define reward "<item[claiming_group_upgrade_item].with[material=gold_block;display_name=<&b>Upgrade<&sp>Claim<&sp>Limit;lore=<&a>---------------------|<&b>Right click while holding.|<&b>This will unlock <&a>10 <&b>more claim chunks.|<&a>---------------------";nbt=upgrade/claim_limit]>"
        - define quantity 1
      - case 90 91 92 93 94 95:
        - define reward_slot "turtle_egg[display_name=<&6>Spawner Changer!;lore=<&e>I wonder which it will be!!]"
        - define win_action announce
        - define choose_egg <list[pillager|piglin|magma_cube|husk|hoglin|drowned|creeper|cave_spider|blaze|zombified_piglin|zoglin|zombie|witch|spider|skeleton].random>
        - define win_message "<player.display_name><&e> just won a <&6>Spawner changer (<[choose_egg].replace[_].with[ ].to_titlecase>)"
        - define reward <[choose_egg]>_spawn_egg
        - define quantity 1
      - case 96 97 98 99 100:
        - define reward_slot mob_spawner_fragment
        - define win_action annouce
        - define reward mob_spawner_fragment
        - define win_message "<player.display_name><&e> just won 25 <item[<[reward]>].display><&e>!"
        - define quantity 25

gen_weekly:
  type: procedure
  debug: false
  script:
  - define item_chosen <list[money|legendary_item|netherite_ingot|teleportation_crystal|backpack_36|title_voucher|claim_token|bowtrail_voucher|notch_apple|choosable_playerhead|random_claim_upgrade|spawner_fragment|spawner_changer].random>
  - define item_base <script[weekly_rewards_key].parsed_key[reward.<[item_chosen]>.item]>
  - define item_name <script[weekly_rewards_key].parsed_key[reward.<[item_chosen]>.name]>
  - define item_lore <script[weekly_rewards_key].parsed_key[reward.<[item_chosen]>.lore]>
  - if <script[daily_rewards_key].parsed_key[reward.<[item_chosen]>.model]||false> != false:
      - define item_model <script[daily_rewards_key].parsed_key[reward.<[item_chosen]>.model]>
      - determine <item[<[item_base]>].with[display_name=<[item_name]>;lore=<[item_lore]>;custom_model_data=<[item_model]>]>
  - if <script[weekly_rewards_key].parsed_key[reward.<[item_chosen]>.texture]||false> != false:
    - define item_texture <script[weekly_rewards_key].parsed_key[reward.<[item_chosen]>.texture]>
    - determine <item[<[item_base]>].with[display_name=<[item_name]>;lore=<[item_lore]>;skull_skin=<[item_texture]>]>
  - determine <item[<[item_base]>].with[display_name=<[item_name]>;lore=<[item_lore]>]>
weekly_rewards_key:
  type: data
  reward:
    money:
      item: dried_kelp
      name: "<&a>$7000!"
      lore: <&e>It's 7000 big ones!
    legendary_item:
      item: nether_star
      name: <&6>Legendary item!
      lore: <&e>Will you actually got this?
    netherite_ingot:
      item: netherite_ingot
      name: <&f>Netherite Ingot
      lore: <&e>Probably the safest way to get one of these
    teleportation_crystal:
      item: firework_star
      name: <&b><&o>Teleportation Crystal
      lore: <&3>Right Click to open up the teleportation menu.
    backpack_36:
      item: chest
      name: <&a>Backpack
      lore: <&e>Slots<&co> <&a>9
    backpack_18:
      item: chest
      name: <&a>Backpack
      lore: <&e>Slots<&co> <&a>18
    title_voucher:
      item: name_tag
      name: <&b>Title Voucher
      lore: <&e>I wonder what one you'll get!
    claim_token:
      item: gold_block
      name: <&b>Claim Expansion Token
      lore: <&e>Good for 1 claim expansion!
    bowtrail_voucher:
      item: name_tag
      name: <&b>Bowtrail Voucher
      lore: <&e>I wonder what one you'll get!
    notch_apple:
      item: enchanted_golden_apple
      name: <&b>Notch Apple
      lore: <&e>Tasty!
    choosable_playerhead:
      item: player_head
      name: <&b>Decorative Head Chooser
      lore: <&e>Theres over 30k choices!
      texture: 0f0e290c-fdf2-47a1-b987-f72a0549ed36|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTE0OWZjZDJkMThhYTlhYjQ3OTljZTg5MWJlNGZjOTZmMThiZWU4YWQ2ZjdkYjcxN2RjZWRiZjY1Zjc5N2IwIn19fQ==
    random_claim_upgrade:
      item: crafting_table
      name: <&b>Random Claim Upgrade
      lore: <&e>I wonder what one you'll get!
    spawner_changer:
      item: turtle_egg
      name: <&6>Spawner Changer!
      lore: <&e>I wonder what one you'll get!
    spawner_fragment:
      item: prismarine_shard
      name: <&b>Spawner Fragment
      lore: <&e>A few more of these and maybe you can charge it up.
      model: 1


