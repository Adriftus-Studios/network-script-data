falling_block_trap:
  type: task
  debug: false
  definitions: location
  script:
    - define location <context.location> if:<[location].exists.not>
    - define material <[location].material>
    - stop if:<[material].name.equals[air]>
    - modifyblock <[location]> air
    - spawn falling_block[fallingblock_type=<[material]>] <[location].center.below[0.5]> save:block
    - flag <entry[block].spawned_entity> on_fall:cancel
    - wait 5s
    - modifyblock <[location]> <[material]>\

falling_block_multiple:
  type: task
  debug: false
  script:
    - define flag_to_check <context.location.flag[trigger_flag]>
    - foreach <context.location.find_blocks_flagged[<[flag_to_check]>].within[6]>:
      - run falling_block_trap def:<[value]>