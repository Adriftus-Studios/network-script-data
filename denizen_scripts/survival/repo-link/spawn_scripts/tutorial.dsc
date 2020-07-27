tutorial_data:
  type: data
  particle_trail:
    particle: totem
    quantity: 5
    offset: 0.5
  continue_button: "&aClick me to Continue"
  start:
    hologram:
      - "&6Welcome To Adriftus Survival"
      - "Click one of the options below to begin"
    start_button: "&6Start Tutorial"
    skip_button: "&eSkip Tutorial"
  1:
    hologram:
      - "&6Adriftus Survival"
      - "&aThis tutorial will teach you the server rules"
      - "&aIt will also walk you through the basic commands"
    particle_guide: true
  2:
    hologram:
      - "&6Rule #1"
      - "&eNo harrassing other players"
      - "&cStop Means Stop"
    particle_guide: true
  3:
    hologram:
      - "&6Rule #1"
      - "&eAvoid profanity in public channels"
      - "&eKeep your language kid appropriate"
    particle_guide: true
  4:
    hologram:
      - "&6Warp Command"
      - "&b/warps &ewill open the warp menu"
      - "&eYou can visit server warps, or other player's warps."
    particle_guide: true
  5:
    hologram:
      - "&6Grim"
      - "&eGrim can help you return to your death location"
      - "&eBe aware, nothing is free."
      - "&a--------------------------"
      - "&euse &b/warps &e and go to the market."
    particle_guide: true
  6:
    hologram:
      - "&6The Market"
      - "&eYou can buy all sorts of upgrades and items here"
      - "&eYou can also get daily rewards!"
    title: "&6Use &b/warps"
    subtitle: "Go to the market."
    message: "&6/warp &eto the market"


tutorial_start:
  type: task
  script:
    - teleport <player> tutorial_start
    - flag player tutorial:0
    - foreach <script[tutorial_data].data_key[start.hologram]>:
      - fakespawn armor_stand[custom_name_visible=true;visible=false;custom_name=<[value].parse_color>] <location[tutorial_start_hologram].sub[0,<[loop_index].*[0.25]>,0]> duration:10h
    - fakespawn armor_stand[custom_name_visible=true;visible=false;marker=true;custom_name=<&a><&b><script[tutorial_data].data_key[start.start_button].parse_color>] <location[tutorial_start_hologram].right[1.5].sub[0,<script[tutorial_data].data_key[start.hologram].size.*[0.25]>,0]> duration:10h
    - fakespawn armor_stand[visible=false;custom_name=ContinueTutorial] <location[tutorial_start_hologram].right[1.5].sub[0,<script[tutorial_data].data_key[start.hologram].size.+[4].*[0.25]>,0]> duration:10h
    - fakespawn armor_stand[custom_name_visible=true;visible=false;marker=true;custom_name=<&b><&a><script[tutorial_data].data_key[start.skip_button].parse_color>] <location[tutorial_start_hologram].left[1.5].sub[0,<script[tutorial_data].data_key[start.hologram].size.*[0.25]>,0]> duration:10h
    - fakespawn armor_stand[visible=false;custom_name=SkipTutorial] <location[tutorial_start_hologram].left[1.5].sub[0,<script[tutorial_data].data_key[start.hologram].size.+[4].*[0.25]>,0]> duration:10h

tutorial_next:
  type: task
  script:
    - define stage <player.flag[tutorial]>
    - if <location[tutorial_<[stage]>]||null> != null:
      - if <script[tutorial_data].list_keys[<[stage]>].contains[title]>:
        - if <script[tutorial_data].list_keys[<[stage]>].contains[subtitle]>:
          - title title:<script[tutorial_data].data_key[<[stage]>.title].parse_color> subtitle:<script[tutorial_data].data_key[<[stage]>.subtitle]>
        - else:
          - title title:<script[tutorial_data].data_key[<[stage]>.title].parse_color>
      - if <script[tutorial_data].list_keys[<[stage]>].contains[message]>:
        - narrate <script[tutorial_data].data_key[<[stage]>.message].parse_color>
      - if <script[tutorial_data].list_keys[<[stage]>].contains[particle_guide]> && <script[tutorial_data].data_key[<[stage]>.particle_guide]>:
        - look <player> tutorial_<[stage]>
        - while <player.location.distance[<location[tutorial_<[stage]>]>]> > 7:
          - define points <player.location.points_between[<location[tutorial_<[stage]>]>].get[3].to[last]>
          - foreach <[points]>:
            - if !<player.is_online>:
              - flag player tutorial:!
              - stop
            - playeffect <script[tutorial_data].data_key[particle_trail.particle]> at:<[value]> quantity:<script[tutorial_data].data_key[particle_trail.quantity]> offset:<script[tutorial_data].data_key[particle_trail.offset]> targets:<player>
            - wait 1t
      - foreach <script[tutorial_data].data_key[<[stage]>.hologram]>:
        - fakespawn armor_stand[custom_name_visible=true;marker=true;visible=false;custom_name=<[value].parse_color>] <location[tutorial_<[stage]>].above[3].sub[0,<[loop_index].*[0.25]>,0]> duration:10h
      - fakespawn armor_stand[custom_name_visible=true;marker=true;visible=false;custom_name=<script[tutorial_data].data_key[continue_button].parse_color>] <location[tutorial_<[stage]>].above[1]> duration:10h
      - fakespawn armor_stand[visible=false;custom_name=ContinueTutorial] <location[tutorial_<[stage]>].sub[0,0.5,0]> duration:10h
      - stop
    - flag player tutorial:!
    - narrate "<&a>You have completed the tutorial!"

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
        - flag player tutorial:!
        - narrate "<&e>You have opted to skip the tutorial."
        - narrate "<&e>Please view <&b>/help <&e>for any questions."