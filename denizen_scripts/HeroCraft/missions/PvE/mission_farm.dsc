# -- PvE Mission - Farming
mission_farm:
  type: data
  id: farm
  category: PvE
  name: <&a>Farm <&2>-blocks-
  description:
    - <&a>Complete this by farming crops.
  assignment: mission_farm_assignment
  icon: wheat_seeds
  cmd: 0
  milestones:
    max: mission_farm_complete
  rewards:
    daily: 100
    weekly: 200
    monthly: 400
  blocks:
    beetroot:
      - 32
      - 48
      - 64
    carrot:
      - 32
      - 48
      - 64
    potato:
      - 32
      - 48
      - 64
    wheat:
      - 32
      - 48
      - 64
    melon:
      - 32
      - 48
      - 64
    pumpkin:
      - 32
      - 48
      - 64


# Assignment Task
mission_farm_assignment:
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
    - define config <script[mission_farm]>
    # Generate random item and amount from config.
    - define block <[config].data_key[blocks].keys.random>
    - define name <[block].as_material.name.replace[_].with[<&sp>].to_titlecase>
    - define max <[config].data_key[blocks.<[block]>].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_farm_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_farm]>
    - define bigconfig <script[missions_config]>
    - define missions <proc[missions_get].context[farm]>
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
mission_farm_events:
  type: world
  debug: false
  events:
    on player breaks pumpkin|melon|wheat|potatoes|carrots|beetroots flagged:missions.active.farm:
      # Add missions with ID farm to a list.
      - define missions <proc[missions_get].context[farm]>
      #Check if the crop is fully grown if it has an age.
      - stop if:<context.material.age.if_null[0].equals[<context.material.maximum_age.if_null[0]>].not>
      # Check each mission if their item matches the item.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - if <context.material.name> == potatoes:
          - define block potato
        - else if <context.material.name> == carrots:
          - define block carrot
        - else if <context.material.name> == beetroots:
          - define block beetroot
        - else:
          - define block <context.material.name>
        - if <player.flag[<[mission]>].get[block]> == <[block]>:
          - run missions_update_progress def:add|<[mission]>|1
