# -- PvP Mission - Hold Power Towers
mission_pvp_towers:
  type: data
  id: pvp_towers
  category: PvP
  name: <&c>Hold <&4>Power Towers
  description:
    - <&e>Complete this by successfully holding Power Towers.
  assignment: mission_pvp_towers_assignment
  icon: beacon
  cmd: 0
  milestones:
    max: mission_pvp_towers_complete
  rewards:
    daily: 200
    weekly: 400
    monthly: 600
  towers:
    - 1
    - 2


# Assignment Task
mission_pvp_towers_assignment:
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
    - define config <script[mission_pvp_towers]>
    # Generate random amount from config.
    - define max <[config].data_key[towers].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_pvp_towers_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_pvp_towers]>
    - define missions <proc[missions_get].context[pvp_towers]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[config].data_key[towers].find[<player.flag[<[mission]>].get[max]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed! <&a>+$<[quantity]>"

# Events
#mission_pvp_towers_events:
#  type: world
#  debug: false
#  events:

