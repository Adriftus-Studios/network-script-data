# -- PvE Mission - Hunt Animals
mission_hunt:
  type: data
  id: hunt
  category: PvE
  name: <&6>Hunt <&e>-mobs-
  description:
    - <&6>Complete this by <&e>hunting animals<&6>.
    - <&6>(Only animals <&e>outside town count!<&6>)
  assignment: mission_hunt_assignment
  icon: crossbow
  cmd: 0
  milestones:
    max: mission_hunt_complete
  rewards:
    daily: 150
    weekly: 300
    monthly: 500
  mobs:
    cow:
      - 48
      - 72
      - 96
    bat:
      - 6
      - 12
      - 18
    sheep:
      - 48
      - 72
      - 96
    pig:
      - 48
      - 72
      - 96
    chicken:
      - 48
      - 72
      - 96
    rabbit:
      - 48
      - 72
      - 96
    squid:
      - 3
      - 6
      - 9
    cod:
      - 3
      - 6
      - 9
    salmon:
      - 3
      - 6
      - 9
    panda:
      - 6
      - 12
      - 18
    wolf:
      - 6
      - 12
      - 18
    axolotl:
      - 6
      - 12
      - 18
    frog:
      - 6
      - 12
      - 18
    dolphin:
      - 1
      - 2
      - 3
    fox:
      - 6
      - 12
      - 18
    goat:
      - 6
      - 12
      - 18
    hoglin:
      - 6
      - 12
      - 18
    strider:
      - 6
      - 12
      - 18
    bee:
      - 6
      - 12
      - 18
    ocelot:
      - 6
      - 12
      - 18
    polar_bear:
      - 6
      - 12
      - 18
    turtle:
      - 1
      - 2
      - 3



# Assignment Task
mission_hunt_assignment:
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
    - define config <script[mission_hunt]>
    # Generate random entity and amount from config.
    - define mob <[config].data_key[mobs].keys.random>
    - define name <[mob].as_entity.name.replace[_].with[<&sp>].to_titlecase.if_null[<[mob].as_entity.entity_type.replace[_].with[<&sp>].to_titlecase>]>
    - define max <[config].data_key[mobs.<[mob]>].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_hunt_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_hunt]>
    - define bigconfig <script[missions_config]>
    - define missions <proc[missions_get].context[hunt]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define mob <player.flag[<[mission]>].get[mob]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[bigconfig].data_key[multipliers.<[timeframe]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed (you monster)! <&a>+$<[quantity]>"

# Events
mission_hunt_events:
  type: world
  debug: false
  events:
    on entity killed by entity_flagged:missions.active.hunt:
      - if <context.damager.entity_type> != PLAYER || <context.entity.location.has_town||false>:
        - stop
      - define __player <context.damager>
      # Add missions with ID hunt to a list.
      - define missions <proc[missions_get].context[hunt]>
      # Check each mission if the slain mob matches the mob.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - define mob <context.entity.script.name.if_null[<context.entity.entity_type>]>
        - if <player.flag[<[mission]>].get[mob]> == <[mob]>:
          - run missions_update_progress def:add|<[mission]>|1
