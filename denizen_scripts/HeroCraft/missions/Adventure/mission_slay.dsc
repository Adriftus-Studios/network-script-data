# -- Adventure Mission - Slay Mobs
mission_slay:
  type: data
  id: slay
  category: Adventure
  name: <&e>Slay <&6>-mobs-
  description:
    - <&e>Complete this by slaying monsters.
  assignment: mission_slay_assignment
  icon: diamond_sword
  cmd: 0
  milestones:
    max: mission_slay_complete
  rewards:
    daily: 150
    weekly: 300
    monthly: 500
  mobs:
    zombie:
      - 24
      - 36
      - 48
    witch:
      - 4
      - 8
      - 12
    skeleton:
      - 24
      - 36
      - 48
    ghast:
      - 24
      - 36
      - 48
    blaze:
      - 24
      - 36
      - 48
    silverfish:
      - 24
      - 36
      - 48
    drowned:
      - 24
      - 36
      - 48
    husk:
      - 24
      - 36
      - 48
    stray:
      - 24
      - 36
      - 48
    guardian:
      - 24
      - 36
      - 48
    pillager:
      - 24
      - 36
      - 48
    vindicator:
      - 24
      - 36
      - 48

    #creeper:
      #- 24
      #- 36
      #- 48


# Assignment Task
mission_slay_assignment:
  type: task
  debug: false
  definitions: timeframe
  data:
    map:
      id: <[config].data_key[id]>
      timeframe: <[timeframe]>
      mob: <[mob]>
      max: <[max].mul[<script[missions_config].data_key[multipliers.<[timeframe]>]>]>
      name: <proc[missions_replace_name].context[<[config].parsed_key[name]>|<map[mobs=<[name]>].escaped>]>
      description: <proc[missions_replace_description].context[<[config].parsed_key[description].escaped>|<map[mobs=<[name]>;max=<[max]>].escaped>]>
      rewarded: false
      done: false
  script:
    - stop if:<[timeframe].exists.not>
    - define config <script[mission_slay]>
    # Generate random entity and amount from config.
    - define mob <[config].data_key[mobs].keys.random>
    - define name <[mob].as_entity.name.replace[_].with[<&sp>].to_titlecase.if_null[<[mob].as_entity.entity_type.replace[_].with[<&sp>].to_titlecase>]>
    - define max <[config].data_key[mobs.<[mob]>].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_slay_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_slay]>
    - define bigconfig <script[missions_config]>
    - define missions <proc[missions_get].context[slay]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define mob <player.flag[<[mission]>].get[mob]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[bigconfig].data_key[multipliers.<[timeframe]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed! <&a>+$<[quantity]>"

# Events
mission_slay_events:
  type: world
  debug: false
  events:
    on entity killed by entity_flagged:missions.active.slay:
      - if <context.damager.entity_type> != PLAYER:
        - stop
      - define __player <context.damager>
      # Add missions with ID slay to a list.
      - define missions <proc[missions_get].context[slay]>
      # Check each mission if the slain mob matches the mob.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - define mob <context.entity.entity_type>
        - if <player.flag[<[mission]>].get[mob]> == <[mob]>:
          - run missions_update_progress def:add|<[mission]>|1
