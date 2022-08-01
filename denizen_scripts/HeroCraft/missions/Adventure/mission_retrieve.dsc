# -- Adventure Mission - Retrieve Mob Drops
mission_retrieve:
  type: data
  id: retrieve
  category: Adventure
  name: <&e>Retrieve <&6>-items-
  description:
    - <&e>Complete this by slaying monsters.
  assignment: mission_retrieve_assignment
  icon: shulker_box
  cmd: 0
  milestones:
    max: mission_retrieve_complete
  rewards:
    daily: 150
    weekly: 300
    monthly: 500
  items:
    bone:
      - 32
      - 48
      - 64
    gunpowder:
      - 32
      - 48
      - 64
    rotten_flesh:
      - 32
      - 48
      - 64
    slime_ball:
      - 32
      - 48
      - 64
    eye_of_ender:
      - 12
      - 24


# Assignment Task
mission_retrieve_assignment:
  type: task
  debug: false
  definitions: timeframe
  data:
    map:
      id: <[config].data_key[id]>
      timeframe: <[timeframe]>
      item: <[item]>
      max: <[max].mul[<script[missions_config].data_key[multipliers.<[timeframe]>]>]>
      name: <proc[missions_replace_name].context[<[config].parsed_key[name]>|<map[items=<[name]>].escaped>]>
      description: <proc[missions_replace_description].context[<[config].parsed_key[description].escaped>|<map[items=<[name]>;max=<[max]>].escaped>]>
      rewarded: false
      done: false
  script:
    - stop if:<[timeframe].exists.not>
    - define config <script[mission_retrieve]>
    # Generate random entity and amount from config.
    - define item <[config].data_key[items].keys.random>
    - define name <[item].as_item.display.if_null[<[item].as_item.material.name.replace[_].with[<&sp>].to_titlecase>]>
    - define max <[config].data_key[items.<[item]>].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_retrieve_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_retrieve]>
    - define missions <proc[missions_get].context[retrieve]>
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
mission_retrieve_events:
  type: world
  debug: false
  events:
    on entity dies by:player:
      - if <context.damager.has_flag[missions.active.retrieve].not>:
        - stop
      - define __player <context.damager>
      # Add missions with ID retrieve to a list.
      - define missions <proc[missions_get].context[retrieve]>
      # Check each mission if the slain mob's drops matches the item.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - define items <context.drops.if_null[<list[]>]>
        - foreach <[items]>:
          - determine passively NO_DROPS
          - define retrieve <player.flag[<[mission]>].get[item].as_item.script.name.if_null[<player.flag[<[mission]>].get[item].as_item.material.name>]>
          - define item <[value].as_item.script.name.if_null[<[value].as_item.material.name>]>
          # Drop item
          - if <[retrieve]> == <[item]>:
            # Progress mission if player inventory can fit item.
            - if <player.inventory.can_fit[<[value].as_item>].quantity[<[value].as_item.quantity>]>:
              - give <[item]> quantity:<[value].as_item.quantity> to:<player.inventory>
              - run missions_update_progress def:add|<[mission]>|<[value].as_item.quantity>
            # Otherwise, notify player that their inventory is full.
            - else:
              - narrate "<&c>You cannot retrieve items right now! Your inventory is full."
          - else:
            - drop <[item]> <context.entity.location> quantity:<[value].as_item.quantity>

