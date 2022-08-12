# -- PvE Mission - Crafting
mission_craft:
  type: data
  id: craft
  category: PvE
  name: <&a>Craft <&2>-items-
  description:
    - <&a>Complete this by crafting items.
  assignment: mission_craft_assignment
  icon: crafting_table
  cmd: 0
  milestones:
    max: mission_craft_complete
  rewards:
    daily: 100
    weekly: 400
    monthly: 800
  items:

    ###Easy
    oak_planks:
      - 128
      - 256
      - 384
    birch_planks:
      - 128
      - 256
      - 384
    spruce_planks:
      - 128
      - 256
      - 384
    dark_oak_planks:
      - 128
      - 256
      - 384
    composter:
      - 16
      - 32
    scaffolding:
      - 128
      - 256
    arrow:
      - 128
      - 256
    glass_bottle:
      - 64
      - 128
      - 256
    stick:
      - 256
      - 512
      - 1024
    bowl:
      - 128
      - 256
    pumpkin_seeds:
      - 256
      - 512
      - 1024
    melon_seeds:
      - 64
      - 128
      - 256
    black_dye:
      - 16
      - 32
    blue_dye:
      - 16
      - 32
    brown_dye:
      - 16
      - 32
    gray_dye:
      - 16
      - 32
    white_dye:
      - 16
      - 32
    cookie:
      - 64
      - 128
    bread:
      - 32
      - 64
      - 128

    ###Medium
    jungle_planks:
      - 128
      - 256
      - 384
    acacia_planks:
      - 128
      - 256
      - 384
    mangrove_planks:
      - 128
      - 256
      - 384
    crimson_planks:
      - 128
      - 256
      - 384
    warped_planks:
      - 128
      - 256
      - 384
    writable_book:
      - 1
      - 2
      - 4
    bucket:
      - 8
      - 16
    clock:
      - 8
      - 16
    lead:
      - 8
      - 16
    compass:
      - 16
      - 32
    rail:
      - 128
      - 256
    powered_rail:
      - 64
      - 128
    detector_rail:
      - 64
      - 128
    minecart:
      - 8
      - 16
    piston:
      - 8
      - 16
    hopper:
      - 8
      - 16
    dropper:
      - 4
      - 8
      - 16
    iron_door:
      - 16
      - 32
    lectern:
      - 4
    target:
      - 8
      - 16
    beetroot_soup:
      - 8
      - 16

    ###Hard
    fire_charge:
      - 96
      - 192
    leather_horse_armor:
      - 3
      - 6
    custom_saddle:
      - 3
      - 6
    custom_iron_horse_armor:
      - 3
      - 6
    custom_golden_horse_armor:
      - 3
      - 6
    custom_diamond_horse_armor:
      - 2
      - 4
    firework_star:
      - 8
      - 16
      - 32
    spyglass:
      - 8
    specral_arrow:
      - 64
      - 128
    magma_cream:
      - 16
      - 32
      - 64
    fermented_spider_eye:
      - 8
      - 16
    cauldron:
      - 3
      - 6
      - 9
    brewing_stand:
      - 3
      - 6
    pumpkin_pie:
      - 8
      - 16
      - 32

    ###Awful
    creeper_banner_pattern:
      - 1
    skull_banner_pattern:
      - 1
      - 2
    mojang_banner_pattern:
      - 1
    beacon:
      - 1
      - 2
    recovery_compass:
      - 1
      - 2
      - 3
    leather:
      - 8
      - 16
    golden_apple:
      - 8
      - 16


# Assignment Task
mission_craft_assignment:
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
    - define config <script[mission_craft]>
    # Generate random item and amount from config.
    - define item <[config].data_key[items].keys.random>
    - define name <[item].as_item.display.if_null[<[item].as_item.material.name.replace[_].with[<&sp>].to_titlecase>]>
    - define max <[config].data_key[items.<[item]>].random>
    # Define map
    - define map <script.parsed_key[data.map]>
    # Give mission
    - run missions_give def:<[map]>

# Completion Task
mission_craft_complete:
  type: task
  debug: false
  script:
    - define config <script[mission_craft]>
    - define bigconfig <script[missions_config]>
    - define missions <proc[missions_get].context[craft]>
    # Check each mission if their item matches the item.
    - foreach <[missions]> as:mission:
      - if <player.flag[<[mission]>].get[done]> && <player.flag[<[mission]>].get[rewarded].not>:
        - define timeframe <player.flag[<[mission]>].get[timeframe]>
        - define item <player.flag[<[mission]>].get[item]>
        - define quantity <[config].data_key[rewards.<[timeframe]>].mul[<[bigconfig].data_key[multipliers.<[timeframe]>]>]>
        - money give quantity:<[quantity]>
        - flag <player> <[mission]>.rewarded:true
        - narrate "<&b>Mission completed! <&a>+$<[quantity]>"

# Events
mission_craft_events:
  type: world
  debug: false
  events:
    on player crafts item flagged:missions.active.craft:
      - if <context.click_type> == NUMBER_KEY:
        - stop
      # Add missions with ID craft to a list.
      - define missions <proc[missions_get].context[craft]>
      # Check each mission if their item matches the item.
      - foreach <[missions]> as:mission:
        - if <player.flag[<[mission]>].get[done]>:
          - foreach next
        - define item <context.item.script.name.if_null[<context.item.material.name>]>
        - if <player.flag[<[mission]>].get[item]> == <[item]>:
          - run missions_update_progress def:add|<[mission]>|<context.amount>
