# -- Adventure Mission - Loot Dungeon Chests
mission_loot_dungeon:
  type: data
  id: loot_dungeon
  category: Adventure
  name: <&e>Loot <&6>Dungeon Chests
  description:
    - <&e>Complete this by looting chests in open world dungeons.
  assignment: mission_loot_dungeon_assignment
  icon: chest
  cmd: 0
  milestones:
    max: mission_loot_dungeon_complete
  rewards:
    daily: 150
    weekly: 300
    monthly: 500
  chests:
    - 3
    - 6
    - 9


# Assignment Task
mission_loot_dungeon_assignment:
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
    - define config <script[mission_loot_dungeon]>
    # Generate random amount from config.
    - define max <[config].data_key[chests].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_loot_dungeon_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_loot_dungeon]>
    - define missions <proc[missions_get].context[loot_dungeon]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[config].data_key[chests].find[<player.flag[<[mission]>].get[max]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed! <&a>+$<[quantity]>"

# Events
#mission_loot_dungeon_events:
#  type: world
#  debug: false
#  events:
