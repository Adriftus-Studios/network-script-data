# -- PvE Mission - Feeding
mission_feed:
  type: data
  id: feed
  category: PvE
  name: <&a>Feed <&2>-entity-
  description:
    - <&a>Complete this by feeding animals.
  assignment: mission_feed_assignment
  icon: apple
  cmd: 0
  milestones:
    max: mission_feed_complete
  rewards:
    daily: 100
    weekly: 200
    monthly: 400
  entity:
    sheep:
      - 8
      - 16
      - 32
    cow:
      - 8
      - 16
      - 32
    mushroom_cow:
      - 8
      - 16
      - 32
    goat:
      - 8
      - 16
      - 32
    chicken:
      - 8
      - 16
      - 32
    pig:
      - 8
      - 16
      - 32
    wolf:
      - 8
      - 16
      - 32
    ocelot:
      - 8
      - 16
      - 32
    rabbit:
      - 8
      - 16
      - 32
    turtle:
      - 8
      - 16
      - 32
    panda:
      - 8
      - 16
      - 32
    bee:
      - 8
      - 16
      - 32
    strider:
      - 8
      - 16
      - 32
    hoglin:
      - 8
      - 16
      - 32
    frog:
      - 8
      - 16
      - 32
    fox:
      - 8
      - 16
      - 32
    horse:
      - 8
      - 16
      - 32
    donkey:
      - 8
      - 16
      - 32
    llama:
      - 8
      - 16
      - 32
    parrot:
      - 8
      - 16
      - 32
    mule:
      - 8
      - 16
      - 32
    axolotl:
      - 8
      - 16
      - 32
    trader_llama:
      - 8
      - 16
      - 32

feed_data_key:
  type: data
  debug: false
  entity:
    sheep:
      wheat: true
    cow:
      wheat: true
    mushroom_cow:
      wheat: true
    goat:
      wheat: true
    chicken:
      wheat_seeds: true
      pumpkin_seeds: true
      melon_seeds: true
      beetroot_seeds: true
    pig:
      carrot: true
      potato: true
      beetroot: true
    wolf:
      bone: true
      beef: true
      chicken: true
      porkchop: true
      mutton: true
      rabbit: true
      rotten_flesh: true
      steak: true
      cooked_chicken: true
      cooked_porkchop: true
      cooked_rabbit: true
      cooked_mutton: true
    ocelot:
      raw_cod: true
      raw_salmon: true
    cat:
      raw_cod: true
      raw_salmon: true
    rabbit:
      dandelion: true
      carrot: true
      golden_carrot: true
    turtle:
      seagrass: true
    panda:
      bamboo: true
    bee:
      dandelion: true
      poppy: true
      blue_orchid: true
      allium: true
      azure_bluet: true
      red_tulip: true
      orange_tulip: true
      white_tulip: true
      pink_tulip: true
      oxeye_daisy: true
      cornflower: true
      lily_of_the_valley: true
      wither_rose: true
      sunflower: true
      lilac: true
      peony: true
    strider:
      warped_fungus: true
    hoglin:
      crimson_fungus: true
    frog:
      slime_ball: true
    fox:
      sweet_berries: true
      glow_berries: true
    horse:
      golden_apple: true
      sugar: true
      apple: true
      wheat: true
      hay_bale: true
      enchanted_golden_apple: true
      golden_carrot: true
    donkey:
      golden_apple: true
      sugar: true
      apple: true
      wheat: true
      hay_bale: true
      enchanted_golden_apple: true
      golden_carrot: true
    llama:
      wheat: true
      hay_bale: true
    parrot:
      wheat_seeds: true
      pumpkin_seeds: true
      melon_seeds: true
      beetroot_seeds: true
    mule:
      sugar: true
      apple: true
      wheat: true
      hay_bale: true
      enchanted_golden_apple: true
      golden_carrot: true
    axolotl:
      tropical_fish_bucket: true
    trader_llama:
      wheat: true
      hay_bale: true

# Assignment Task
mission_feed_assignment:
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
    - define config <script[mission_feed]>
    # Generate random item and amount from config.
    - define entity <[config].data_key[entity].keys.random>
    - define name <[entity].as_material.name.replace[_].with[<&sp>].to_titlecase>
    - define max <[config].data_key[entity.<[entity]>].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_feed_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_feed]>
    - define bigconfig <script[missions_config]>
    - define missions <proc[missions_get].context[feed]>
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
mission_feed_events:
  type: world
  debug: false
  events:
    on player right clicks sheep|cow|mushroom_cow|goat|chicken|pig|wolf|ocelot|rabbit|turtle|panda|bee|strider|hoglin|frog|fox|horse|donkey|llama|parrot|mule|axolotl|trader_llama flagged:missions.active.feed bukkit_priority:HIGHEST:
      - if <context.entity.has_flag[fed]>:
        - stop
      - define entity <context.entity.entity_type>
      - if !<list[<script[feed_data_key].list_keys[entity.<[entity]>]>].contains_any[<player.item_in_hand.material.name>]>:
        - stop
      - playsound sound:ENTITY_PLAYER_BURP <context.entity.location>
      - flag <context.entity> fed expire:6000t
      # Add missions with ID feed to a list.
      - define missions <proc[missions_get].context[feed]>
      # Check each mission if their item matches the item.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - if <player.flag[<[mission]>].get[entity]> == <[entity]>:
          - run missions_update_progress def:add|<[mission]>|1
