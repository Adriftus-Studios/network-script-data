armor_stand_quick_swap:
  type: world
  debug: false
  events:
    on player right clicks armor_stand bukkit_priority:HIGHEST:
      - if <player.is_sneaking> && <player.can_build[<context.entity.location>]> && !<context.entity.script.exists>:
        - determine passively cancelled
        - ratelimit <player> 5t
        - define equipment <player.equipment>
        - define new_equipment <context.entity.equipment>
        - adjust <player> equipment:<[new_equipment]>
        - adjust <context.entity> equipment:<[equipment]>