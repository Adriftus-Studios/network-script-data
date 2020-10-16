system_OP_prevention:
  type: world
  debug: false
  events:
    on command:
      - if <context.source_type> != player:
        - stop
      - if <context.command> != deop && <player.is_op>:
        - narrate "<&c>OP players cannot perform any commands aside from /deop."
        - determine fulfilled
