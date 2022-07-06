## FLAG LIST FOR THIS FILE ##
# no_build - prevents building in this location
# on_break - injects task, or list of tasks when location is broken
# on_step - injects task, or list of tasks when location is stepped on by a player
# on_right_click - injects task, or list of tasks when location is right clicked
# on_pistoned - injects task, or list of tasks when location is pushed or pulled by a piston
# infinite_chest - Makes contents of a chest infinite, value is inventory title

block_properties:
  type: world
  debug: false
  events:
    on player places block location_flagged:no_build:
      - determine cancelled
    on player breaks block location_flagged:on_break:
        - if <context.location.flag[on_break].object_type> == List:
          - foreach <context.location.flag[on_break]>:
            - inject <[value]>
        - else:
          - inject <context.location.flag[on_break]>
    on player steps on block location_flagged:on_step:
        - if <context.location.flag[on_step].object_type> == List:
          - foreach <context.location.flag[on_step]>:
            - inject <[value]>
        - else:
          - inject <context.location.flag[on_step]>
    on player right clicks chest location_flagged:infinite_chest:
      - if <player.has_permission[adriftus.admin]> && <player.is_sneaking>:
        - narrate "<&a>Bypassing Infinite Chest Restriction With Admin Permissions."
      - else:
        - determine passively cancelled
        - inventory open d:generic[title=<context.location.flag[infinite_chest]>;size=27;contents=<context.location.inventory.list_contents>]
    on player right clicks block location_flagged:on_right_click:
        - if <context.location.flag[on_right_click].object_type> == List:
          - foreach <context.location.flag[on_right_click]>:
            - inject <[value]>
        - else:
          - inject <context.location.flag[on_right_click]>
    on piston extends:
      - foreach <context.blocks.filter[has_flag[on_pistoned]]>:
        - if <[value].flag[on_pistoned].object_type> == List:
          - foreach <[value].flag[on_pistoned]>:
            - inject <[value]>
        - else:
          - inject <[value].flag[on_pistoned]>
    on piston retracts:
      - foreach <context.blocks.filter[has_flag[on_pistoned]]>:
        - if <[value].flag[on_pistoned].object_type> == List:
          - foreach <[value].flag[on_pistoned]>:
            - inject <[value]>
        - else:
          - inject <[value].flag[on_pistoned]>
    on block physics location_flagged:on_physics:
        - if <context.location.flag[on_physics].object_type> == List:
          - foreach <context.location.flag[on_physics]>:
            - inject <[value]>
        - else:
          - inject <context.location.flag[on_physics]>
    on liquid spreads location_flagged:on_liquid_spreads:
        - if <context.location.flag[on_liquid_spreads].object_type> == List:
          - foreach <context.location.flag[on_liquid_spreads]>:
            - inject <[value]>
        - else:
          - inject <context.location.flag[on_liquid_spreads]>
    on liquid spreads:
      - if <context.destination.has_flag[on_liquid_spreads]>:
        - if <context.destination.flag[on_liquid_spreads].object_type> == List:
          - foreach <context.destination.flag[on_liquid_spreads]>:
            - inject <[value]>
        - else:
          - inject <context.destination.flag[on_liquid_spreads]>
    on block_flagged:on_explodes destroyed by explosion:
        - if <context.block.flag[on_explodes].object_type> == List:
          - foreach <context.block.flag[on_explodes]>:
            - inject <[value]>
        - else:
          - inject <context.block.flag[on_explodes]>