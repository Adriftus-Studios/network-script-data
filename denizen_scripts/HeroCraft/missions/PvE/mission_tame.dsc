# -- PvE Mission - taming
mission_tame:
  type: data
  id: tame
  category: PvE
  name: <&a>Tame <&2>-entity-
  description:
    - <&a>Complete this by taming animals.
  assignment: mission_tame_assignment
  icon: lead
  cmd: 0
  milestones:
    max: mission_tame_complete
  rewards:
    daily: 100
    weekly: 200
    monthly: 400
  entity:
    cat:
      - 3
      - 6
      - 9
    donkey:
      - 3
      - 6
      - 9
    horse:
      - 3
      - 6
      - 9
    llama:
      - 3
      - 6
      - 9
    mule:
      - 3
      - 6
      - 9
    parrot:
      - 3
      - 6
      - 9
#    skeleton_horse:
#      - 1
#      - 2
#      - 3
    trader_llama:
      - 1
      - 2
      - 3
    wolf:
      - 3
      - 6
      - 9

# Assignment Task
mission_tame_assignment:
  type: task
  debug: false
  definitions: timeframe
  data:
    map:
      id: <[config].data_key[id]>
      timeframe: <[timeframe]>
      entity: <[entity]>
      max: <[max].mul[<script[missions_config].data_key[multipliers.<[timeframe]>]>]>
      name: <proc[missions_replace_name].context[<[config].parsed_key[name]>|<map[entity=<[name]>].escaped>]>
      description: <proc[missions_replace_description].context[<[config].parsed_key[description].escaped>|<map[items=<[name]>;max=<[max]>].escaped>]>
      rewarded: false
      done: false
  script:
    - stop if:<[timeframe].exists.not>
    - define config <script[mission_tame]>
    # Generate random item and amount from config.
    - define entity <[config].data_key[entity].keys.random>
    - define name <[entity].as_entity.name.replace[_].with[<&sp>].to_titlecase.if_null[<[entity].as_entity.entity_type.replace[_].with[<&sp>].to_titlecase>]>
    - define max <[config].data_key[entity.<[entity]>].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_tame_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_tame]>
    - define bigconfig <script[missions_config]>
    - define missions <proc[missions_get].context[tame]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define item <player.flag[<[mission]>].get[entity]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[bigconfig].data_key[multipliers.<[timeframe]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed! <&a>+$<[quantity]>"

# Events
mission_tame_events:
  type: world
  debug: false
  events:
    on player tames entity flagged:missions.active.tame bukkit_priority:HIGHEST:
      # Add missions with ID tame to a list.
      - define missions <proc[missions_get].context[tame]>
      # Check each mission if their item matches the item.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - else:
          - define entity <context.entity.entity_type>
        - if <player.flag[<[mission]>].get[entity]> == <[entity]>:
          - run missions_update_progress def:add|<[mission]>|1
