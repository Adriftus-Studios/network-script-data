# -- PvE Mission - Snacking
mission_snack:
  type: data
  id: snack
  category: PvE
  name: <&a>Snack on <&2>-items-
  description:
    - <&a>Complete this by consuming food.
  assignment: mission_snack_assignment
  icon: cookie
  cmd: 0
  milestones:
    max: mission_snack_complete
  rewards:
    daily: 100
    weekly: 200
    monthly: 500
  items:
    enchanted_golden_apple:
        - 1
        - 2
    golden_apple:
        - 2
        - 4
        - 6
    golden_carrot:
        - 2
        - 4
        - 6
    cooked_mutton:
        - 4
        - 8
        - 12
    cooked_porkchop:
        - 4
        - 8
        - 12
    cooked_salmon:
        - 4
        - 8
        - 12
    cooked_beef:
        - 4
        - 8
        - 12
    baked_potato:
        - 6
        - 12
        - 18
    beetroot:
        - 6
        - 12
        - 18
    beetroot_soup:
        - 6
        - 12
        - 18
    bread:
        - 6
        - 12
        - 18
    carrot:
        - 6
        - 12
        - 18
    cooked_chicken:
        - 6
        - 12
        - 18
    cooked_cod:
        - 6
        - 12
        - 18
    cooked_rabbit:
        - 6
        - 12
        - 18
    mushroom_stew:
        - 6
        - 12
        - 18
    rabbit_stew:
        - 6
        - 12
        - 18
    suspicious_stew:
        - 6
        - 12
        - 18
    apple:
        - 8
        - 16
        - 24
    dried_kelp:
        - 8
        - 16
        - 24
    melon_slice:
        - 8
        - 16
        - 24
    poisonous_potato:
        - 8
        - 16
        - 24
    potato:
        - 8
        - 16
        - 24
    pumpkin_pie:
        - 8
        - 16
        - 24
    beef:
        - 8
        - 16
        - 24
    chicken:
        - 8
        - 16
        - 24
    mutton:
        - 8
        - 16
        - 24
    porkchop:
        - 8
        - 16
        - 24
    rabbit:
        - 8
        - 16
        - 24
    cookie:
        - 10
        - 20
        - 30
    glow_berries:
        - 10
        - 20
        - 30
    pufferfish:
        - 10
        - 20
        - 30
    cod:
        - 10
        - 20
        - 30
    salmon:
        - 10
        - 20
        - 30
    rotten_flesh:
        - 10
        - 20
        - 30
    spider_eye:
        - 10
        - 20
        - 30
    sweet_berries:
        - 10
        - 20
        - 30
    tropical_fish:
        - 10
        - 20
        - 30

# Assignment Task
mission_snack_assignment:
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
      description: <proc[missions_replace_description].context[<[config].parsed_key[description].escaped>|<map[items=<[name]>;max=<[max]>].escaped>]>
      rewarded: false
      done: false
  script:
    - stop if:<[timeframe].exists.not>
    - define config <script[mission_snack]>
    # Generate random item and amount from config.
    - define item <[config].data_key[items].keys.random>
    - define name <[item].as_item.display.if_null[<[item].as_item.material.name.replace[_].with[<&sp>].to_titlecase>]>
    - define max <[config].data_key[items.<[item]>].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_snack_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_snack]>
    - define bigconfig <script[missions_config]>
    - define missions <proc[missions_get].context[snack]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define item <player.flag[<[mission]>].get[item]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[bigconfig].data_key[multipliers.<[timeframe]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Snacking completed! <&a>+$<[quantity]>"

# Events
mission_snack_events:
  type: world
  debug: false
  events:
    after player consumes item flagged:missions.active.snack:
      - stop if:<script[mission_snack].data_key[items].contains[<context.item.script.name||<context.item.material.name>>].not>
        # Add missions with ID snack to a list.
      - define missions <proc[missions_get].context[snack]>
      # Check each mission if their item matches the item.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - define item <context.item.script.name||<context.item.material.name>>
        - if <player.flag[<[mission]>].get[item]> == <[item]>:
          - run missions_update_progress def:add|<[mission]>|1
