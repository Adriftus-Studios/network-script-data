teleport_task:
  type: task
  debug: false
  definitions: destination
  script:
    - define destination <context.location.flag[destination].if_null[false]> if:<[destination].exists.not>
    - define destination <context.entity.flag[destination].if_null[false]> if:<[destination].is_truthy.not>
    - if <[destination].is_truthy>:
      - teleport <player> <[destination]>