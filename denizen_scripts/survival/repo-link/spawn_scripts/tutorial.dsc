tutorial_data:
  type: data
  distance_check: 14
  particle_trail:
    particle: totem
    quantity: 5
    offset: 0.5
  continue_button: "<&a>Click me to Continue"
  complete_button: "<&a>Complete Tutorial"
  start:
    hologram:
      - "<&6>Welcome To Adriftus Survival"
      - "<&e>Click one of the options below to begin."
    start_button: "<&a>Start Tutorial"
    skip_button: "<&4>Skip Tutorial"
  1:
    hologram:
      - "<&6><&l>Adriftus Survival"
      - "<&e>This tutorial will teach you the server rules."
      - "<&e>It will also walk you through the basic commands."
    particle_guide: true
  2:
    hologram:
      - "<&6><&l>Rule <&ns>1"
      - "<&e>No harrassing other players."
      - "<&c>Stop Means Stop."
    particle_guide: true
  3:
    hologram:
      - "<&6><&l>Rule <&ns>2"
      - "<&e>Avoid profanity in public channels."
      - "<&c>Keep your language kid appropriate."
    particle_guide: true
  4:
    hologram:
      - "<&6><&l>Vote Crates"
      - "<&e>Voting for our server will earn you rewards."
      - "<&e>Use <&b>/vote <&e>to find out how."
    particle_guide: true
  5:
    hologram:
      - "<&6><&l>Soul Forge"
      - "<&e>Here you can forge your items with souls."
      - "<&e>Doing so will infuse special powers into your gear"
      - "<&c>Souls can be acquired in the <&4>Savage Lands."
    particle_guide: true
  6:
    hologram:
      - "<&6><&l>The Market"
      - "<&e>You can buy all sorts of upgrades and items here!"
      - "<&e>Be sure to check out the stocks and cosmetic vendors."
      - "<&e>You can also get daily rewards!"
    particle_guide: true
  7:
    hologram:
      - <&6><&l>Cosmetics
      - "<&e>Here you can purchase titles and bow trails!"
      - "<&e>Use <&b>/titles<&e> and <&b>/bowtrails<&e> to use them."
    particle_guide: true
  8:
    hologram:
      - <&6><&l>Claims
      - "<&e>Here you can purchase upgrades for your claim."
      - "<&e>Upgrades only apply <&c>within<&e> your claim."
      - "<&c>The claims system will be explained in a few steps."
    particle_guide: true
  9:
    hologram:
      - "<&6><&l>Mystery Boxes"
      - "<&e>Here you can purchase mysterious packages."
      - "<&e>Who knows what they might contain."
    particle_guide: true
  10:
    hologram:
      - <&6><&l>Stonks!
      - "<&e>Our Stonks Broker buys and sells items."
      - "<&e>Prices fluctuate, so check back often!"
    particle_guide: true
  11:
    hologram:
      - <&6><&l>Survivalist
      - "<&e>Want something a little more useful?"
      - "<&e>The survivalist sells backpacks, tents, and more!"
    particle_guide: true
  12:
    hologram:
      - "<&6><&l>Daily Rewards"
      - "<&e>Wait a minute, is that you from the future?"
      - "<&e>Maybe you have something to give yourself."
      - "<&c>Each day you can recieve a daily reward."
    particle_guide: true
  13:
    hologram:
      - "<&6><&l>Warp Command"
      - "<&e>Warps can be made by any player within their claim."
      - "<&e>You can visit server warps, or other player's warps."
      - "<&e>Command Menu<&co> <&b>/warps"
      - <&a>--------------------------
      - "<&e>Use <&b>/warps <&e>and go to Grim to continue."
    particle_guide: true
  14:
    hologram:
      - <&6><&l>Grim
      - "<&e>Grim can help you return to your death location."
      - "<&c>... For a cost."
    particle_guide: false
    title: "<&6>Use <&b>/warps"
    subtitle: "<&e>Go to the server warp: <&4>Grim"
  15:
    hologram:
      - <&6><&l>Claims
      - "<&e>You can claim land!"
      - "<&e>You can also give access to different groups of players."
      - "<&e>If a group doesn't exist, it will be created."
      - "<&e>You can manage everything related to chunks in the GUI."
      - "<&a>Command Menu<&co> <&b>/claims"
    particle_guide: true
  16:
    hologram:
      - <&6><&l>Elevators
      - "<&e>Gold blocks function as elevators."
      - "<&e>You can travel up, or down 25 blocks at a time."
      - "<&e>Step inside to give it a try!"
    particle_guide: true
  17:
    hologram:
      - "<&6><&l>The World (1/2)"
      - "<&e>The world is split into 2 sections<&co>"
      - "<&e>The <&c>Savage Lands <&e>are the inner 20,000 blocks."
      - "<&e>The <&2>Outer Realms <&e>are everywhere outside of that."
    particle_guide: true
  18:
    hologram:
      - "<&6><&l>The World Part (2/2)"
      - "<&e>The <&c>Savage Lands <&e>have <&c>PvP Enabled."
      - "<&e>Beware of encounters there as monsters will spawn."
      - "<&e>The <&2>Outer Realms <&e>are a safe haven."
      - "<&e>No monsters will spawn, and PvP is disabled."
    particle_guide: true
  19:
    hologram:
      - <&6><&l>Chat
      - "<&e>We have cross-server chat available"
      - "<&e>Use <&b>/chat<&e> to change your channel"
      - "<&e>You can also click on the channel name in chat!"
      - "<&c>Please keep our rules in mind."
    particle_guide: true
  20:
    hologram:
      - "<&6><&l>End Game"
      - "<&e>Monsters grow stronger as you venture towards the center of the world."
      - "<&e>These monsters possess and guard more powerful equipment and items."
      - "<&e>The only <&d>Ender Portal <&e>resides at the bottom of a dungeon in the center."
      - "<&e>Should you manage to endure the challenge, powerful rewards await."
    particle_guide: true
    run_task: tutorial_spawn_finale
  21:
    hologram:
      - "<&a><&l>Start Your Journey"
      - "<&e>Jump through the hole to be teleported to the game world."
      - "<&e>If you need any additional help, consult <&b>/help<&e>."
      - "<&e>You can return to spawn at any point with <&b>/spawn<&e>."
      - "<&e>Make sure you <&b>/sethome <&e>if you like where you land."
      - "<&c>There is no other way to return to the same location."
    particle_guide: true


##########################
## TUTORIAL RUN SCRIPTS ##
##########################

tutorial_spawn_finale:
  type: task
  script:
    - repeat 20:
      - wait 1t
      - playeffect redstone at:<location[tutorial_dragon]> special_data:1|black quantity:<[value].mul[2]> offset:<[value].mul[0.2]>
      - playeffect dragon_breath at:<location[tutorial_dragon]> data:0.5 quantity:10 offset:0


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
    - playsound <player> sound:entity_ender_pearl_throw volume:0.5
    - flag player tutorial:0
    - foreach <script[tutorial_data].parsed_key[start.hologram]>:
      - fakespawn armor_stand[custom_name_visible=true;visible=false;custom_name=<[value]>] <location[tutorial_start_hologram].sub[0,<[loop_index].mul[0.25]>,0]> duration:10m
    - fakespawn armor_stand[custom_name_visible=true;visible=false;marker=true;custom_name=<&a><&b><script[tutorial_data].parsed_key[start.start_button]>] <location[tutorial_start_hologram].right[1.5].sub[0,<script[tutorial_data].parsed_key[start.hologram].size.mul[0.25]>,0]> duration:10m
    - fakespawn armor_stand[visible=false;custom_name=ContinueTutorial] <location[tutorial_start_hologram].right[1.5].sub[0,<script[tutorial_data].parsed_key[start.hologram].size.add[4].mul[0.25]>,0]> duration:10m
    - fakespawn armor_stand[custom_name_visible=true;visible=false;marker=true;custom_name=<&b><&a><script[tutorial_data].parsed_key[start.skip_button]>] <location[tutorial_start_hologram].left[1.5].sub[0,<script[tutorial_data].parsed_key[start.hologram].size.mul[0.25]>,0]> duration:10m
    - fakespawn armor_stand[visible=false;custom_name=SkipTutorial] <location[tutorial_start_hologram].left[1.5].sub[0,<script[tutorial_data].parsed_key[start.hologram].size.add[4].mul[0.25]>,0]> duration:10m

tutorial_next:
  type: task
  script:
    - define stage <player.flag[tutorial]>
    - if <location[tutorial_<[stage]>]||null> != null:
      - run tutorial_timeout def:<[stage]>
      - if <script[tutorial_data].list_keys[<[stage]>].contains[run_task]>:
        - run <script[tutorial_data].parsed_key[<[stage]>.run_task]>
      - if <script[tutorial_data].list_keys[<[stage]>].contains[title]>:
        - if <script[tutorial_data].list_keys[<[stage]>].contains[subtitle]>:
          - title title:<script[tutorial_data].parsed_key[<[stage]>.title]> subtitle:<script[tutorial_data].parsed_key[<[stage]>.subtitle]>
        - else:
          - title title:<script[tutorial_data].parsed_key[<[stage]>.title]>
      - if <script[tutorial_data].list_keys[<[stage]>].contains[message]>:
        - narrate <script[tutorial_data].parsed_key[<[stage]>.message]>
      - if <script[tutorial_data].list_keys[<[stage]>].contains[particle_guide]> && <script[tutorial_data].parsed_key[<[stage]>.particle_guide]>:
        - look <player> tutorial_<[stage]>
        - playsound <player> sound:entity_ender_pearl_throw volume:0.5
        - define last_distance 128
        - while <player.location.world.name> == spawn && <player.location.distance[<location[tutorial_<[stage]>]>]> > <script[tutorial_data].data_key[distance_check]>:
          - define points <player.location.points_between[<location[tutorial_<[stage]>]>].get[3].to[last]>
          - foreach <[points]>:
            - if !<player.is_online>:
              - flag player tutorial:!
              - stop
            - while <[value].material.name> != air:
              - define value <[value].above[2]>
            - playeffect <script[tutorial_data].parsed_key[particle_trail.particle]> at:<[value]> quantity:<script[tutorial_data].parsed_key[particle_trail.quantity]> offset:<script[tutorial_data].parsed_key[particle_trail.offset]> targets:<player>
            - wait 1t
          - if <player.location.distance[<location[tutorial_<[stage]>]>]> > <[last_distance].add[5]>:
            - narrate "<&4>You have gone too far from your next tutorial location."
            - narrate "<element[<&e>You can restart the tutorial at any time by using <&b>/tutorial<&e>.].on_hover[<&e>Click to restart the tutorial].on_click[/tutorial]>"
            - inject tutorial_skipped
            - stop
          - else if <player.location.distance[<location[tutorial_<[stage]>]>]> < <[last_distance]>:
            - define last_distance <player.location.distance[<location[tutorial_<[stage]>]>]>
          - wait 5t
      - foreach <script[tutorial_data].parsed_key[<[stage]>.hologram]>:
        - fakespawn armor_stand[custom_name_visible=true;marker=true;visible=false;custom_name=<[value]>] <location[tutorial_<[stage]>].above[3].sub[0,<[loop_index].add[0.25]>,0]> duration:10m
        - wait 4t
      - if <script[tutorial_data].parsed_key[<[stage].add[1]>]||null> == null:
        - fakespawn armor_stand[custom_name_visible=true;marker=true;visible=false;custom_name=<script[tutorial_data].parsed_key[complete_button]>] <location[tutorial_<[stage]>].above[1]> duration:10m
      - else:
        - fakespawn armor_stand[custom_name_visible=true;marker=true;visible=false;custom_name=<script[tutorial_data].parsed_key[continue_button]>] <location[tutorial_<[stage]>].above[1]> duration:10m
      - fakespawn armor_stand[visible=false;custom_name=ContinueTutorial] <location[tutorial_<[stage]>]> duration:10m
      - stop
    - flag player tutorial:!
    - flag player tutorial_status:completed
    - playsound <player> sound:entity_player_levelup volume:0.5
    - firework <player.location> random trail
    - narrate "<&a>You have completed the tutorial!"
    - narrate "<&a>Please jump through the hole in front of you to begin your journey!"

tutorial_timeout:
  type: task
  definitions: stage
  script:
    - while <player.has_flag[tutorial]> && <player.flag[tutorial]> == <[stage]>:
      - if <queue.time_ran.in_seconds> > 600:
        - inject tutorial_skipped
        - narrate "<&4>Your tutorial has timed out."
        - playsound <player> sound:block_beacon_deactivate volume:0.5
        - narrate "<element[<&e>You can restart the tutorial at any time by using <&b>/tutorial<&e>.].on_hover[<&e>Click to restart the tutorial].on_click[/tutorial]>"
      - wait 10s

tutorial_skipped:
  type: task
  script:
    - foreach <player.fake_entities>:
      - fakespawn <[value]> cancel
    - playsound <player> sound:entity_chicken_ambient volume:0.5
    - flag player tutorial:!
    - flag player tutorial_status:skipped

tutorial_events:
  type: world
  events:
    on player clicks fake entity flagged:tutorial:
      - playsound <player> sound:ui_button_click volume:0.5
      - if <context.entity.name> == ContinueTutorial:
        - foreach <player.fake_entities>:
          - fakespawn <[value]> cancel
        - flag player tutorial:++
        - run tutorial_next
      - else if <context.entity.name> == SkipTutorial:
        - foreach <player.fake_entities>:
          - fakespawn <[value]> cancel
        - inject tutorial_skipped
        - narrate "<&4>You have opted to skip the tutorial."
        - narrate "<element[<&e>Please view <&b>/help <&e>for any questions.].on_hover[<&e>Click to open the help menu.].on_click[/help]>"
        - narrate "<element[<&e>You can restart the tutorial at any time by using <&b>/tutorial<&e>.].on_hover[<&e>Click to restart the tutorial].on_click[/tutorial]>"
    on player exits spawn_cuboid flagged:tutorial:
      - inject tutorial_skipped
      - narrate "<&4>You have exited spawn, and stopped the tutorial."
      - narrate "<element[<&e>You can restart the tutorial at any time by using <&b>/tutorial<&e>.].on_hover[<&e>Click to restart the tutorial].on_click[/tutorial]>"
