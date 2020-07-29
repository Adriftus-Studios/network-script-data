tutorial_data:
  type: data
  particle_trail:
    particle: totem
    quantity: 5
    offset: 0.5
  continue_button: "<&a>Click me to Continue"
  complete_button: "<&a>Complete Tutorial"
  start:
    hologram:
      - "<&6>Welcome To Adriftus Survival"
      - "Click one of the options below to begin"
    start_button: "<&6>Start Tutorial"
    skip_button: "<&e>Skip Tutorial"
  1:
    hologram:
      - "<&6>Adriftus Survival"
      - "<&a>This tutorial will teach you the server rules"
      - "<&a>It will also walk you through the basic commands"
    particle_guide: true
  2:
    hologram:
      - "<&6>Rule <&ns>1"
      - "<&e>No harrassing other players"
      - "<&c>Stop Means Stop"
    particle_guide: true
  3:
    hologram:
      - "<&6>Rule <&ns>2"
      - "<&e>Avoid profanity in public channels"
      - "<&e>Keep your language kid appropriate"
    particle_guide: true
  4:
    hologram:
      - "<&6>Warp Command"
      - "<&b>Warps can be made by any player, within their claim"
      - "<&e>You can visit server warps, or other player's warps."
      - "<&a>Command<&co> <&b>/warps"
    particle_guide: true
  5:
    hologram:
      - "<&6>Grim"
      - "<&e>Grim can help you return to your death location"
      - "<&e>Be aware, nothing is free."
      - "<&a>--------------------------"
      - "<&e>use <&b>/warps <&e>and go to the market."
    particle_guide: true
  6:
    hologram:
      - "<&6>The Market"
      - "<&e>You can buy all sorts of upgrades and items here"
      - "<&e>You can also get daily rewards!"
    title: "<&6>Use <&b>/warps"
    subtitle: "Go to the server warp: Marketplace"
    message: "<&6>/warp &eto the server warp: Marketplace"
  7:
    hologram:
      - "<&6>Claims"
      - "<&e>You can claim chunks to different groups"
      - "<&e>If a group doesn't exist, it be created"
      - "<&e>You can manage everything related to chunks in the GUI"
      - "<&a>Command<&co> <&b>/claims"
    particle_guide: true
  8:
    hologram:
      - "<&d>Soul Forge"
      - "<&e>Here you can forge your items with souls"
      - "<&e>Souls can be acquired in the <&c>Savage Lands"
    particle_guide: true
  9:
    hologram:
      - "<&7>The World"
      - "<&e>The world is split into 2 sections"
      - "<&e>The &cSavage Lands &eare the inner 20k"
      - "<&e>The &2Outer Realms &eare everywhere outside of that"
    particle_guide: true
  10:
    hologram:
      - "<&7>The World"
      - "<&e>The <&c>Savage Lands &eare <&c>PvP Enabled"
      - "<&e>Beware of your encounters here as mobs also spawn."
      - "<&e>The <&2>Outer Realms <&e>are a safe haven"
      - "<&e>No mobs will spawn, and PvP is disabled"
    particle_guide: true
  11:
    hologram:
      - "<&6>End Game"
      - "<&e>The close to the center of the world you get"
      - "<&e>The harder the mobs will be, and the better loot they drop"
      - "<&e>The only <&d>Ender Portal <&e>resides at the bottom of the dungeon there"
      - "<&e>Should you manage to endure, great rewards await"
    particle_guide: true
    run_task: tutorial_spawn_finale
  12:
    hologram:
      - "<&a>Start Your Journey"
      - "<&e>Jump through the hole to be teleported to the gameworld"
      - "<&e>If you need any additional help, consult <&b>/help"
      - "<&e>You can return to spawn at any point with <&b>/spawn"
      - "<&e>There is no way to return to your location, however."
      - "<&c>Make sure you <&b>/sethome"
    particle_guide: true


##########################
## TUTORIAL RUN SCRIPTS ##
##########################

tutorial_spawn_finale:
  type: task
  script:
    - fakespawn ender_dragon <location[tutorial_dragon]> duration:10m


###############
## INTERNALS ##
###############

tutorial_command:
  type: command
  name: tutorial
  description: Start the Tutorial!
  usage: /tutorial
  script:
    - inject tutorial_start

tutorial_start:
  type: task
  script:
    - teleport <player> tutorial_start
    - flag player tutorial:0
    - foreach <script[tutorial_data].parsed_key[start.hologram]>:
      - fakespawn armor_stand[custom_name_visible=true;visible=false;custom_name=<[value].parse_color>] <location[tutorial_start_hologram].sub[0,<[loop_index].*[0.25]>,0]> duration:10m
    - fakespawn armor_stand[custom_name_visible=true;visible=false;marker=true;custom_name=<&a><&b><script[tutorial_data].parsed_key[start.start_button].parse_color>] <location[tutorial_start_hologram].right[1.5].sub[0,<script[tutorial_data].parsed_key[start.hologram].size.*[0.25]>,0]> duration:10m
    - fakespawn armor_stand[visible=false;custom_name=ContinueTutorial] <location[tutorial_start_hologram].right[1.5].sub[0,<script[tutorial_data].parsed_key[start.hologram].size.+[4].*[0.25]>,0]> duration:10m
    - fakespawn armor_stand[custom_name_visible=true;visible=false;marker=true;custom_name=<&b><&a><script[tutorial_data].parsed_key[start.skip_button].parse_color>] <location[tutorial_start_hologram].left[1.5].sub[0,<script[tutorial_data].parsed_key[start.hologram].size.*[0.25]>,0]> duration:10m
    - fakespawn armor_stand[visible=false;custom_name=SkipTutorial] <location[tutorial_start_hologram].left[1.5].sub[0,<script[tutorial_data].parsed_key[start.hologram].size.+[4].*[0.25]>,0]> duration:10m

tutorial_next:
  type: task
  script:
    - define stage <player.flag[tutorial]>
    - if <location[tutorial_<[stage]>]||null> != null:
      - run tutorial_timeout def:<[stage]>
      - if <script[tutorial_data].list_keys[<[stage]>].contains[title]>:
        - if <script[tutorial_data].list_keys[<[stage]>].contains[subtitle]>:
          - title title:<script[tutorial_data].parsed_key[<[stage]>.title].parse_color> subtitle:<script[tutorial_data].parsed_key[<[stage]>.subtitle]>
        - else:
          - title title:<script[tutorial_data].parsed_key[<[stage]>.title].parse_color>
      - if <script[tutorial_data].list_keys[<[stage]>].contains[message]>:
        - narrate <script[tutorial_data].parsed_key[<[stage]>.message].parse_color>
      - if <script[tutorial_data].list_keys[<[stage]>].contains[particle_guide]> && <script[tutorial_data].parsed_key[<[stage]>.particle_guide]>:
        - look <player> tutorial_<[stage]>
        - while <player.location.world.name> == spawn && <player.location.distance[<location[tutorial_<[stage]>]>]> > 7:
          - define points <player.location.points_between[<location[tutorial_<[stage]>]>].get[3].to[last]>
          - foreach <[points]>:
            - if !<player.is_online>:
              - flag player tutorial:!
              - stop
            - while <[value].material.name> != air:
              - define value <[value].above[2]>
            - playeffect <script[tutorial_data].parsed_key[particle_trail.particle]> at:<[value]> quantity:<script[tutorial_data].parsed_key[particle_trail.quantity]> offset:<script[tutorial_data].parsed_key[particle_trail.offset]> targets:<player>
            - wait 1t
          - wait 5t
      - foreach <script[tutorial_data].parsed_key[<[stage]>.hologram]>:
        - fakespawn armor_stand[custom_name_visible=true;marker=true;visible=false;custom_name=<[value].parse_color>] <location[tutorial_<[stage]>].above[3].sub[0,<[loop_index].*[0.25]>,0]> duration:10m
      - if <script[tutorial_data].parsed_key[<[stage].+[1]>]||null> == null:
        - fakespawn armor_stand[custom_name_visible=true;marker=true;visible=false;custom_name=<script[tutorial_data].parsed_key[complete_button].parse_color>] <location[tutorial_<[stage]>].above[1]> duration:10m
      - else:
        - fakespawn armor_stand[custom_name_visible=true;marker=true;visible=false;custom_name=<script[tutorial_data].parsed_key[continue_button].parse_color>] <location[tutorial_<[stage]>].above[1]> duration:10m
      - fakespawn armor_stand[visible=false;custom_name=ContinueTutorial] <location[tutorial_<[stage]>].sub[0,0.5,0]> duration:10m
      - if <script[tutorial_data].list_keys[<[stage]>].contains[run_task]>:
        - run <script[tutorial_data].parsed_key[<[stage]>.run_task]>
      - stop
    - flag player tutorial:!
    - flag player tutorial_status:completed
    - narrate "<&a>You have completed the tutorial!"

tutorial_timeout:
  type: task
  definitions: stage
  script:
    - while <player.flag[tutorial]||null> == <[stage]>:
      - if <queue.time_ran> > <duration[10m]>:
        - inject tutorial_skipped
        - narrate "<&e>Your tutorial has timed out"
        - narrate "<&e>You may use <&b>/tutorial<&e> at any time to restart it."
      - wait 10s

tutorial_skipped:
  type: task
  script:
    - foreach <player.fake_entities>:
      - fakespawn <[value]> cancel
    - flag player tutorial:!
    - flag player tutorial_status:skipped
    

tutorial_events:
  type: world
  events:
    on player clicks fake entity flagged:tutorial:
      - if <context.entity.name> == ContinueTutorial:
        - foreach <player.fake_entities>:
          - fakespawn <[value]> cancel
        - flag player tutorial:++
        - run tutorial_next
      - else if <context.entity.name> == SkipTutorial:
        - foreach <player.fake_entities>:
          - fakespawn <[value]> cancel
        - inject tutorial_skipped
        - narrate "<&e>You have opted to skip the tutorial."
        - narrate "<&e>Please view <&b>/help <&e>for any questions."
    on player exits spawn_cuboid flagged:tutorial:
      - injet tutorial_skipped
      - narrate "<&e>You have exited spawn, and stopped the tutorial."
      - narrate "<&e>You can restart the tutorial at any time by using <&b>/tutorial"