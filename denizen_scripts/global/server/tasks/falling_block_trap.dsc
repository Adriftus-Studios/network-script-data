falling_block_trap:
  type: task
  debug: false
  script:
    - define material <context.location.material>
    - stop if:<[material].name.equals[air]>
    - modifyblock <context.location> air
    - spawn falling_block[fallingblock_type=<[material]>] <context.location.center.below[0.5]> save:block
    - flag <entry[block].spawned_entity> on_fall:cancel
    - wait 5s
    - modifyblock <context.location> <[material]>

cancel:
  type: task
  debug: false
  script:
    - determine cancelled
