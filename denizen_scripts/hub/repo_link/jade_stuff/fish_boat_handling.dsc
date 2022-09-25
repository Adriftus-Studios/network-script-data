fishbot_boat_assignment:
  type: assignment
  debug: false
  actions:
    on assignment:
    - trigger name:click state:true
    - trigger name:damage state:true
    on damage:
    - inject fishbot_boat
    on click:
    - inject fishbot_boat


fishbot_boat:
  type: task
  debug: false
  script:
    - inventory open d:jade_boat_inventory_<player.flag[fishbot.boat_expanded].if_null[0]>
    - stop



fishbot_boat_stand_handling:
  type: world
  debug: false
  events:
    on player clicks item in jade_boat_inventory_*:
      - if <context.item.material.name> == air:
        - stop
      - if !<script[fishbot_data_storage].list_keys[boat].contains_any[<context.item.script.name.after[fishing_boat_]||nulla>]> && <context.item.material.name> != air:
        - determine passively cancelled
      - if <list[standard_filler|standard_accept_button|standard_back_button].contains_any[<context.item.script.name.if_null[null]>]>:
        - determine passively cancelled
        - define boat_list <list[]>
        - choose <context.item.script.name>:
          - case default:
            - stop
          - case standard_accept_button:
            - foreach <context.inventory.list_contents.exclude[standard_filler|standard_accept_button|air]> as:item:
              - if <list[standard_filler|standard_accept_button|standard_back_button|null].contains_any[<[item].script.name||null>]>:
                - foreach next
              - define boat_list:->:<[item]>
            - flag <player> fishbot.boats_stored:<[boat_list]>
            - playsound sound:UI_BUTTON_CLICK <player>
            - wait 2t
            - inventory close
    on player closes jade_boat_inventory_*:
            - define boat_list <list[]>
            - foreach <context.inventory.list_contents.exclude[standard_filler|standard_accept_button|air]> as:item:
              - if <list[standard_filler|standard_accept_button|standard_back_button|null].contains_any[<[item].script.name||null>]>:
                - foreach next
              - define boat_list:->:<[item]>
            - flag <player> fishbot.boats_stored:<[boat_list]>
            - wait 2t


fish_boat_expander_item:
  type: item
  material: feather
  debug: false
  display name: <&6>Fishing Boat Storage Expander
  lore:
  - <&e>Right Click<&6> to expand Jades Boat Storage by <&e>1<&6> slot.

fish_barrel_expansion_script:
  type: world
  debug: false
  events:
    on player right clicks block with:fish_boat_expander_item:
      - determine passively cancelled
      - if <player.flag[fishbot.boat_expanded].if_null[0]> < 2:
        - take iteminhand
        - flag <player> fishbot.boat_expanded:++
      - else:
        - narrate "<&c>You have already used 2 fishing boat storage expanders."

jade_boat_inventory_0:
  type: inventory
  inventory: chest
  title: Jade's Boats
  debug: false
  procedural items:
    - determine <player.flag[fishbot.boats_stored]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [standard_filler] [standard_filler] [] [standard_filler] [standard_filler] [standard_filler] [standard_filler]

jade_boat_inventory_1:
  type: inventory
  inventory: chest
  title: Jade's Boats
  debug: false
  procedural items:
    - determine <player.flag[fishbot.boats_stored]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [standard_filler] [] [] [] [standard_filler] [standard_filler] [standard_back_button]


jade_boat_inventory_2:
  type: inventory
  inventory: chest
  title: Jade's Boats
  debug: false
  procedural items:
    - determine <player.flag[fishbot.boats_stored]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]
