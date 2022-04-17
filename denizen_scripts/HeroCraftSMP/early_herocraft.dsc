early_herocraft_reset_porkchop_task:
  type: task
  debug: false
  script:
    - if <context.entity.framed_item.material.name> == air:
      - determine cancelled
    - flag <context.entity> last_broken:<util.time_now>
    - wait 5m
    - if <context.entity.is_spawned>:
      - adjust <context.entity> framed:cooked_porkchop

early_herocraft_reset_porkchop_added:
  type: task
  debug: false
  script:
    - if <context.entity.has_flag[last_broken]>:
      - if <context.entity.flag[last_broken].is_after[<util.time_now>]>:
        - wait 1t
        - adjust <context.entity> framed:cooked_porkchop
      - else:
        - wait <context.entity.has_flag[last_broken].from_now>
        - adjust <context.entity> framed:cooked_porkchop if:<context.entity.is_spawned>
