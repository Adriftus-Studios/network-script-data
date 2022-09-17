# -- PvP Mission - Reclaim Supplies
mission_supply:
  type: data
  id: supply
  category: PvP
  name: <&c>Reclaim <&4>Supplies
  description:
    - <&e>Complete this by winning Arena battles.
  assignment: mission_supply_assignment
  icon: barrel
  cmd: 0
  milestones:
    max: mission_supply_complete
  rewards:
    daily: 200
    weekly: 400
    monthly: 600
  supplies:
    - 1
    - 2


# Assignment Task
mission_supply_assignment:
  type: task
  debug: false
  definitions: timeframe
  data:
    map:
      id: <[config].data_key[id]>
      timeframe: <[timeframe]>
      max: <[max].mul[<script[missions_config].data_key[multipliers.<[timeframe]>]>]>
      name: <[config].parsed_key[name]>
      description: <[config].parsed_key[description]>
      rewarded: false
      done: false
  script:
    - stop if:<[timeframe].exists.not>
    - define config <script[mission_supply]>
    # Generate random amount from config.
    - define max <[config].data_key[supplies].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_supply_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_supply]>
    - define missions <proc[missions_get].context[supply]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[config].data_key[supplies].find[<player.flag[<[mission]>].get[max]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed! <&a>+$<[quantity]>"

# Events
#mission_supply_events:
#  type: world
#  debug: false
#  events:

