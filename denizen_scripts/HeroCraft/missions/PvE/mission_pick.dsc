# -- PvE Mission - Flower Picking
mission_pick:
  type: data
  id: pick
  category: PvE
  name: <&a>Pick <&2>-blocks-
  description:
    - <&a>Complete this by picking flowers.
  assignment: mission_pick_assignment
  icon: poppy
  cmd: 0
  milestones:
    max: mission_pick_complete
  rewards:
    daily: 100
    weekly: 200
    monthly: 400
  blocks:
    dandelion:
      - 32
      - 48
      - 64
    poppy:
      - 32
      - 48
      - 64
    blue_orchid:
      - 32
      - 48
      - 64
    allium:
      - 32
      - 48
      - 64
    azure_bluet:
      - 32
      - 48
      - 64
    oxeye_daisy:
      - 32
      - 48
      - 64
    cornflower:
      - 32
      - 48
      - 64
    lily_of_the_valley:
      - 32
      - 48
      - 64
    sunflower:
      - 32
      - 48
      - 64
    lilac:
      - 32
      - 48
      - 64
    red_tulip:
      - 32
      - 48
      - 64
    orange_tulip:
      - 32
      - 48
      - 64
    white_tulip:
      - 32
      - 48
      - 64
    pink_tulip:
      - 32
      - 48
      - 64

# Assignment Task
mission_pick_assignment:
  type: task
  debug: false
  definitions: timeframe
  data:
    map:
      id: <[config].data_key[id]>
      timeframe: <[timeframe]>
      block: <[block]>
      max: <[max].mul[<script[missions_config].data_key[multipliers.<[timeframe]>]>]>
      name: <proc[missions_replace_name].context[<[config].parsed_key[name]>|<map[blocks=<[name]>].escaped>]>
      description: <proc[missions_replace_description].context[<[config].parsed_key[description].escaped>|<map[items=<[name]>;max=<[max]>].escaped>]>
      rewarded: false
      done: false
  script:
    - stop if:<[timeframe].exists.not>
    - define config <script[mission_pick]>
    # Generate random item and amount from config.
    - define block <[config].data_key[blocks].keys.random>
    - define name <[block].as_material.name.replace[_].with[<&sp>].to_titlecase>
    - define max <[config].data_key[blocks.<[block]>].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_pick_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_pick]>
    - define bigconfig <script[missions_config]>
    - define missions <proc[missions_get].context[pick]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define item <player.flag[<[mission]>].get[block]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[bigconfig].data_key[multipliers.<[timeframe]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed! <&a>+$<[quantity]>"

# Events
mission_pick_events:
  type: world
  debug: false
  events:
    on player breaks dandelion|poppy|blue_orchid|allium|azure_bluet|red_tulip|orange_tulip|white_tulip|pink_tulip|oxeye_daisy|cornflower|lily_of_the_valley|wither_rose|sunflower|lilac|rose_bush|peony flagged:missions.active.pick bukkit_priority:HIGHEST:
      # Add missions with ID pick to a list.
      - define missions <proc[missions_get].context[pick]>
      #Check if the crop is fully grown if it has an age.
      - stop if:<context.material.age.if_null[0].equals[<context.material.maximum_age.if_null[0]>].not>
      # Check each mission if their item matches the item.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - else:
          - define block <context.material.name>
        - if <player.flag[<[mission]>].get[block]> == <[block]>:
          - determine passively NOTHING
          - run missions_update_progress def:add|<[mission]>|1
