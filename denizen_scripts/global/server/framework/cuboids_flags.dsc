cuboid_flags:
  type: world
  debug: false
  events:
    on player enters area_flagged:player_enters:
      - if <context.area.flag[player_enters].object_type> == List:
        - foreach <context.area.flag[player_enters]>:
          - inject <[value]>
      - else:
        - inject <context.area.flag[player_enters]>
    on player exits area_flagged:player_leaves:
      - if <context.area.flag[player_enters].object_type> == List:
        - foreach <context.area.flag[player_enters]>:
          - inject <[value]>
      - else:
        - inject <context.area.flag[player_enters]>