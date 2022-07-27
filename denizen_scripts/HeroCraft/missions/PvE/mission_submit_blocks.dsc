# -- PvE Mission - Submit Blocks to an NPC
mission_submit_blocks:
  type: data
  id: submit_blocks
  category: PvE
  name: <&a>Submit <&2>-items- <&a>to NPC
  description:
    - <&a>Complete this by gathering -items- and giving them to NPC.
  assignment: mission_submit_blocks_assignment
  icon: hopper
  cmd: 0
  milestones:
    max: mission_submit_blocks_complete
  rewards:
    daily: 100
    weekly: 200
    monthly: 400
  items:
    stone:
      - 16
      - 32
      - 48
      - 64
    dirt:
      - 16
      - 32
      - 48
      - 64


# Assignment Task
mission_submit_blocks_assignment:
  type: task
  debug: false
  definitions: timeframe
  data:
    map:
      id: <[config].data_key[id]>
      timeframe: <[timeframe]>
      item: <[item]>
      max: <[max].mul[<script[missions_config].data_key[multipliers.<[timeframe]>]>]>
      name: <proc[missions_replace_name].context[<[config].parsed_key[name]>|<map[items=<[name]>].escaped>]>
      description: <proc[missions_replace_description].context[<[config].parsed_key[description].escaped>|<map[items=<[name]>].escaped>]>
      rewarded: false
      done: false
  script:
    - stop if:<[timeframe].exists.not>
    - define config <script[mission_submit_blocks]>
    # Generate random item and amount from config.
    - define item <[config].data_key[items].keys.random>
    - define name <[item].as_item.display.if_null[<[item].as_item.material.name.replace[_].with[<&sp>].to_titlecase>]>
    - define max <[config].data_key[items.<[item]>].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_submit_blocks_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_submit_blocks]>
    - define missions <proc[missions_get].context[submit_blocks]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define item <player.flag[<[mission]>].get[item]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[config].data_key[items.<[item]>].find[<player.flag[<[mission]>].get[max]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed! <&a>+$<[quantity]>"

# Events
mission_submit_blocks_events:
  type: world
  debug: false
  events:
    on player takes item from furnace flagged:missions.active.submit_blocks:
      # Add missions with ID submit_blocks to a list.
      - define missions <proc[missions_get].context[submit_blocks]>
      # Check each mission if their item matches the item.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - define item <context.item.script.name.if_null[<context.item.material.name>]>
        - if <player.flag[<[mission]>].get[item]> == <[item]>:
          - run missions_update_progress def:add|<[mission]>|<context.item.quantity>
