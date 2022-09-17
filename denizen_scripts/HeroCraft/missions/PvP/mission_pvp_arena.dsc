# -- PvP Mission - Win Arena Fights or Duels
mission_pvp_arena:
  type: data
  id: pvp_arena
  category: PvP
  name: <&c>Win <&4>One-on-One Battles
  description:
    - <&e>Complete this by winning Arena battles.
  assignment: mission_pvp_arena_assignment
  icon: shield
  cmd: 0
  milestones:
    max: mission_pvp_arena_complete
  rewards:
    daily: 200
    weekly: 400
    monthly: 600
  wins:
    - 1
    - 2
    - 3


# Assignment Task
mission_pvp_arena_assignment:
  type: task
  debug: false
  definitions: timeframe
  data:
    map:
      id: <[config].data_key[id]>
      timeframe: <[timeframe]>
      max: <[max].mul[<script[missions_config].data_key[multipliers.<[timeframe]>]>]>
      name: <[config].parsed_key[name]>
      description: <proc[missions_replace_description].context[<[config].parsed_key[description].escaped>|<map[max=<[max]>].escaped>]>
      rewarded: false
      done: false
  script:
    - stop if:<[timeframe].exists.not>
    - define config <script[mission_pvp_arena]>
    # Generate random amount from config.
    - define max <[config].data_key[wins].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_pvp_arena_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_pvp_arena]>
    - define missions <proc[missions_get].context[pvp_arena]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[config].data_key[wins].find[<player.flag[<[mission]>].get[max]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed! <&a>+$<[quantity]>"

# Events
#mission_pvp_arena_events:
#  type: world
#  debug: false
#  events:

