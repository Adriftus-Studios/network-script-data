armor_stand_quick_swap:
  type: world
  debug: false
  events:
    on player right clicks armor_stand:
      - if <player.is_sneaking>:
        - determine passively cancelled
        - ratelimit <player> 5t
        - define equipment <player.equipment>
        - define new_equipment <context.entity.equipment>
        - adjust <player> equipment:<[new_equipment]>
        - adjust <context.entity> equipment:<[equipment]>