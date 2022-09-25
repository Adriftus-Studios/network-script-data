fishbot_rod_stand_handling:
  type: world
  debug: false
  events:
    on player right clicks ITEM_FRAME:
      - stop if:!<context.entity.has_flag[fishing_rods]>
      - determine passively cancelled
      - ratelimit <player> 2t
      - inventory open d:jade_rod_inventory_<player.flag[fishbot.rods_expanded].if_null[0]>
    on player clicks item in jade_rod_inventory_*:
      - if <context.item.material.name> == air:
        - stop
      - if !<script[fishbot_data_storage].list_keys[rod].contains_any[<context.item.script.name.after[fishing_rod_]||null>]> && <context.item.material.name> != air:
        - determine passively cancelled
      - if <list[standard_filler|standard_accept_button|standard_back_button].contains_any[<context.item.script.name.if_null[null]>]>:
        - determine passively cancelled
        - define rod_list <list[]>
        - choose <context.item.script.name>:
          - case default:
            - stop
          - case standard_accept_button:
            - foreach <context.inventory.list_contents.exclude[standard_filler|standard_accept_button|air]> as:item:
              - if <list[standard_filler|standard_accept_button|standard_back_button|null].contains_any[<[item].script.name||null>]>:
                - foreach next
              - define rod_list:->:<[item]>
            - flag <player> fishbot.rods_stored:<[rod_list]>
            - playsound sound:UI_BUTTON_CLICK <player>
            - wait 2t
            - inventory close
    on player closes jade_rod_inventory_*:
            - define rod_list <list[]>
            - foreach <context.inventory.list_contents.exclude[standard_filler|standard_accept_button|air]> as:item:
              - if <list[standard_filler|standard_accept_button|standard_back_button|null].contains_any[<[item].script.name||null>]>:
                - foreach next
              - define rod_list:->:<[item]>
            - flag <player> fishbot.rods_stored:<[rod_list]>
            - wait 2t


fish_rod_expander_item:
  type: item
  material: feather
  debug: false
  display name: <&6>Fishing Rod Storage Expander
  lore:
  - <&e>Right Click<&6> to expand Jades Rod Storage by <&e>1<&6> slot.

fish_barrel_expansion_script:
  type: world
  debug: false
  events:
    on player right clicks block with:fish_rod_expander_item:
      - determine passively cancelled
      - if <player.flag[fishbot.rods_expanded].if_null[0]> < 2:
        - take iteminhand
        - flag <player> fishbot.rods_expanded:++
      - else:
        - narrate "<&c>You have already used 2 fishing rod storage expanders."

jade_rod_inventory_0:
  type: inventory
  inventory: chest
  title: Jade's Rods
  debug: false
  procedural items:
    - determine <player.flag[fishbot.rods_stored]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [standard_filler] [standard_filler] [] [standard_filler] [standard_filler] [standard_filler] [standard_filler]

jade_rod_inventory_1:
  type: inventory
  inventory: chest
  title: Jade's Rods
  debug: false
  procedural items:
    - determine <player.flag[fishbot.rods_stored]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [standard_filler] [] [] [] [standard_filler] [standard_filler] [standard_back_button]


jade_rod_inventory_2:
  type: inventory
  inventory: chest
  title: Jade's Rods
  debug: false
  procedural items:
    - determine <player.flag[fishbot.rods_stored]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]
