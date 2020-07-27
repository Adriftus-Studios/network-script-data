tutorial_data:
  type: data
  particle_trail:
    particle: totem
    quantity: 5
    offset: 0.5
  continue_button: &aClick me to Continue
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
  2:
    hologram:
      - "&6Rule #1"
      - "&eNo harrassing other players"
      - "&cStop Means Stop"
  3:
    hologram:
      - "&6Rule #1"
      - "&eAvoid profanity in public channels"
      - "&eKeep your language kid appropriate"
  4:
    hologram:
      - "&6Warp Command"
      - "&b/warps &ewill open the warp menu"
      - "&eYou can visit server warps, or other player's warps."
  5:
    hologram:
      - "&6Grim"
      - "&eGrim can help you return to your death location"
      - "&eBe aware, nothing is free."
      - "&a--------------------------"
      - "&euse &b/warps &e and go to the market."


tutorial_start:
  type: task
  script:
    - flag player tutorial:0
    - showfake barrier <cuboid[<location[tutorial_start_hologram].backward.left[2]>|<location[tutorial_start_hologram].backward.right[2].above[3]>].blocks> duration:10h
    - foreach <script[tutorial_data].data_key[start.hologram]>:
      - fakespawn armor_stand[custom_name_visible=true;visible=false;custom_name=<[value].parse_color>] <location[tutorial_start_hologram].sub[0,<[loop_index].*[0.25]>,0]> duration:10h
    - fakespawn armor_stand[custom_name_visible=true;visible=false;custom_name=<&a><&b><script[tutorial_data].data_key[start.start_button].parse_color>] <location[tutorial_start_hologram].right.sub[0,<script[tutorial_data].data_key[start.hologram].size.+[2].*0.25]>,0]>
    - fakespawn armor_stand[custom_name_visible=true;visible=false;custom_name=<&b><&a><script[tutorial_data].data_key[start.stop_button].parse_color>] <location[tutorial_start_hologram].left.sub[0,<script[tutorial_data].data_key[start.hologram].size.+[2].*0.25]>,0]>

tutorial_next:
  type: task
  script:
    - define stage <player.flag[tutorial]>
    - if <server.notables[locations].contains[tutorial_<[stage]>]>:
      - look <player> tutorial_<[stage]>
      - while <player.location.distance[<location[tutorial_<[stage]>]>]> > 5:
        - define points <player.location.points_between[<location[tutorial_<[stage]>]>]>
        - foreach <[points]>:
          - if <[loop_index]> == 11:
            - repeat stop
          - if !<player.is_online>:
            - flag player tutorial:!
            - stop
          - playeffect <script[tutorial_data].data_key[particle_trail.particle]> at:<[value]> quantity:<script[tutorial_data].data_key[particle_trail.quantity]> offset:<script[tutorial_data].data_key[particle_trail.offset]> targets:<player>
          - wait 1t
      - foreach <script[tutorial_data].data_key<[stage]>.hologram]>:
        - fakespawn armor_stand[custom_name_visible=true;visible=false;custom_name=<[value].parse_color>] <location[tutorial_start_hologram].sub[0,<[loop_index].*[0.25]>,0]> duration:10h
      - fakespawn armor_stand[custom_name_visible=true;visible=false;custom_name=<&a><&b><script[tutorial_data].data_key[continue_button].parse_color>] <location[tutorial_start_hologram].sub[0,<script[tutorial_data].data_key[<[stage]>.hologram].size.+[2].*0.25]>,0]>
    - flag player tutorial:!
    - narrate "<&a>You have completed the tutorial!"

tutorial_events:
  type: world
  events:
    on player clicks fake entity:
      - if <context.entity.name.starts_with[<&a><&b>]>:
        - foreach <player.fake_entities>:
          - fakespawn <[value]> cancel
        - flag player tutorial:++
        - run tutorial_next
      - else if <context.entity.name.starts_with[<&b><&a>]>:
        - flag player tutorial:!
        - narrate "<&e>You have opted to skip the tutorial."
        - narrate "<&e>Please view <&b>/help <&e>for any questions."