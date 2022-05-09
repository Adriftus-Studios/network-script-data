material_flags:
  type: world
  debug: false
  events:
    on player right clicks material_flagged:on_right_click:
      - if <context.location.material.flag[on_right_click].object_type> == List:
        - foreach <context.location.material.flag[on_right_click]>:
          - inject <[value]>
      - else:
        - inject <context.location.material.flag[on_right_click]>
    on player left clicks material_flagged:on_left_click:
      - if <context.location.material.flag[on_right_click].object_type> == List:
        - foreach <context.location.material.flag[on_right_click]>:
          - inject <[value]>
      - else:
        - inject <context.location.material.flag[on_right_click]>
    on player places material_flagged:on_place bukkit_priority:HIGHEST:
      - if <context.material.flag[on_place].object_type> == List:
        - foreach <context.material.flag[on_place]>:
          - inject <[value]>
      - else:
        - inject <context.material.flag[on_place]>