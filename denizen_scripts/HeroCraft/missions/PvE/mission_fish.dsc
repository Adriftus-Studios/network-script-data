# -- PvE Mission - Fishing
mission_fish:
  type: data
  id: fish
  category: PvE
  name: <&a>Fish <&2>-items-
  description:
    - <&a>Complete this by catching fish.
  assignment: mission_fish_assignment
  icon: tropical_fish
  cmd: 0
  milestones:
    max: mission_fish_complete
  rewards:
    daily: 100
    weekly: 125
    monthly: 150
  items:
    cod:
      - 2
      - 4
      - 6
      - 8
    salmon:
      - 2
      - 4
      - 6
      - 8
    tropical_fish:
      - 2
      - 4
      - 6
      - 8
    pufferfish:
      - 2
      - 4
      - 6
      - 8


# Assignment Task
mission_fish_assignment:
  type: task
  debug: false
  definitions: timeframe
  script:
    - stop if:<[timeframe].exists.not>
    - define config <script[mission_fish]>
    # Generate random item and amount from config.
    - define item <[config].data_key[items].keys.random>
    - define name <[item].as_item.display.if_null[<[item].as_item.material.name.replace[_].with[<&sp>].to_titlecase>]>
    - define max <[config].data_key[items.<[item]>].random>
    # Define map
    - define map <map.with[id].as[<[config].data_key[id]>]>
    - define map <[map].with[timeframe].as[<[timeframe]>]>
    - define map <[map].with[item].as[<[item]>]>
    - define map <[map].with[max].as[<[max]>]>
    - define map <[map].with[name].as[<proc[missions_replace_name].context[<[config].parsed_key[name]>|<map[items=<[name]>].escaped>]>]>
    - define map <[map].with[description].as[<proc[missions_replace_description].context[<[config].parsed_key[description].escaped>|<map[items=<[name]>;max=<[max]>].escaped>]>]>
    - define map <[map].with[rewarded].as[false]>
    - define map <[map].with[done].as[false]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_fish_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_fish]>
    - define missions <proc[missions_get].context[fish]>
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
mission_fish_events:
  type: world
  debug: false
  events:
    on player fishes item while caught_fish flagged:missions.active.fish:
      # Add missions with ID fish to a list.
      - define missions <proc[missions_get].context[fish]>
      # Check each mission if their item matches the item.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - define item <context.item.script.name.if_null[<context.item.material.name>]>
        - if <player.flag[<[mission]>].get[item]> == <[item]>:
          - run missions_update_progress def:add|<[mission]>|<context.item.quantity>
