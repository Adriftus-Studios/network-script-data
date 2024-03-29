# -- PvP Mission - Kill Players in Zan'zar
mission_pvp_zanzar:
  type: data
  id: pvp_zanzar
  category: PvP
  name: <&c>Kill <&4>Players
  description:
    - <&e>Complete this by killing other players.
  assignment: mission_pvp_zanzar_assignment
  icon: player_head
  cmd: 0
  milestones:
    max: mission_pvp_zanzar_complete
  rewards:
    daily: 200
    weekly: 400
    monthly: 600
  players:
    - 3
    - 4
    - 5


# Assignment Task
mission_pvp_zanzar_assignment:
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
    - define config <script[mission_pvp_zanzar]>
    # Generate random amount from config.
    - define max <[config].data_key[players].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_pvp_zanzar_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_pvp_zanzar]>
    - define missions <proc[missions_get].context[pvp_zanzar]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[config].data_key[players].find[<player.flag[<[mission]>].get[max]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed! <&a>+$<[quantity]>"

# Events
mission_pvp_zanzar_events:
  type: world
  debug: false
  events:
    on player killed by entity_flagged:missions.active.pvp_zanzar:
      - if <context.damager.entity_type> != PLAYER:
        - stop
      - define __player <context.damager>
      # Add missions with ID pvp_zanzar to a list.
      - define missions <proc[missions_get].context[pvp_zanzar]>
      # Check each mission if the slain mob matches the mob.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - run missions_update_progress def:add|<[mission]>|1
