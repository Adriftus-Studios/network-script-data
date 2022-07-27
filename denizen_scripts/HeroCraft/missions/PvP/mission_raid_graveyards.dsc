# -- PvP Mission - Raid Graveyards
mission_raid_graveyards:
  type: data
  id: raid_graveyards
  category: PvP
  name: <&c>Raid <&4>Graveyards
  description:
    - <&e>Complete this by raiding graveyards in other towns.
  assignment: mission_raid_graveyards_assignment
  icon: skeleton_skull
  cmd: 0
  milestones:
    max: mission_raid_graveyards_complete
  rewards:
    daily: 200
    weekly: 400
    monthly: 600
  graves:
    - 1
    - 2
    - 3


# Assignment Task
mission_raid_graveyards_assignment:
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
    - define config <script[mission_raid_graveyards]>
    # Generate random amount from config.
    - define max <[config].data_key[graves].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_raid_graveyards_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_raid_graveyards]>
    - define missions <proc[missions_get].context[raid_graveyards]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[config].data_key[graves].find[<player.flag[<[mission]>].get[max]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed! <&a>+$<[quantity]>"

# Events
#mission_raid_graveyards_events:
#  type: world
#  debug: false
#  events:

