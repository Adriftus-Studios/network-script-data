world_event_config:
  type: data
  materials:
    iron_ingot: 1
    iron_block: 9
  server_amount_needed: 250000
  personal_amount_needed: 15000

currency_display_item:
  type: item
  debug: false
  display name: <&a>

world_event_bar_0:
  type: item
  debug: false
  material: beetroot
  display name: <&a>
  mechanisms:
    custom_model_data: 3

world_event_bar_1:
  type: item
  debug: false
  material: beetroot
  display name: <&a>
  mechanisms:
    custom_model_data: 4

world_event_bar_2:
  type: item
  debug: false
  material: beetroot
  display name: <&a>
  mechanisms:
    custom_model_data: 5

world_event_bar_3:
  type: item
  debug: false
  material: beetroot
  display name: <&a>
  mechanisms:
    custom_model_data: 6

world_event_bar_4:
  type: item
  debug: false
  material: beetroot
  display name: <&a>
  mechanisms:
    custom_model_data: 7

world_event_bar_5:
  type: item
  debug: false
  material: beetroot
  display name: <&a>
  mechanisms:
    custom_model_data: 8

world_event_progress_inventory:
  type: inventory
  debug: false
  type: chest
  title: <&a>World Event
  definitions:
    G: white_stained_glass_pane[display_name=<&a>]
    T: "green_stained_glass_pane[display_name=<&a>Turn in Materials;nbt=action/turn_in]"
  slots:
    - [] [] [] [] [] [] [] [] []
    - [G] [G] [G] [G] [G] [G] [G] [G] [G]
    - [G] [] [] [] [] [] [] [] [G]
    - [G] [] [] [] [] [] [] [] [G]
    - [G] [] [] [] [] [] [] [] [G]
    - [G] [G] [G] [G] [G] [G] [G] [G] [G]

world_event_progress_inventory:
  type: world
  debug: false
  events:
    on player clicks item in world_event_progress_inventory:
      - determine passively cancelled
      - if <context.item.has_nbt[action]> && <context.item.nbt[action]> == turn_in:
        - inventory open d:world_event_turn_in

world_event_progress_inventory_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[world_event_progress_inventory]>
    - define percentage <server.flag[world_event.progress]./[<script[world_event_config].data_key[server_amount_needed]>].round_to_precision[0.2]>
    - if <[percentage]> > 1:
      - define percentage 1
    - inventory set slot:5 o:world_event_bar_<[percentage].*[5]> d:<[inventory]>
    - define percentage2 <player.flag[world_event.progress]./[<script[world_event_config].data_key[personal_amount_needed]>].round_to_precision[0.2]>
    - if <[percentage]> > 1:
      - define percentage 1
    - inventory set slot:41 o:world_event_bar_<[percentage].*[5]> d:<[inventory]>
    - inventory set slot:44 "o:currency_display_item[display_name=<&6>Tokens<&co> <player.flag[world_event.tokens.current]||0>]" d:<[inventory]>
    - inventory open d:<[inventory]>

world_event_turn_in:
  type: inventory
  debug: false
  inventory: chest
  title: <&6>Turn Ins
  definitions:
    filler: white_stained_glass_pane[display_name=<&a>]
    close: "barrier[display_name=<&c>Close GUI;nbt=action/close]"
    turn_in: "green_stained_glass_pane[display_name=<&e>Place materials to turn them in]"
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [turn_in] [filler] [filler] [filler] [close]

world_event_turn_in_update:
  type: task
  debug: false
  script:
    - foreach <script[world_event_config].keys[materials]> as:worth key:material
      - define count:+:<context.inventory.quantity[<[material]>].*[<[worth]>]>
    - inventory set slot:50 "o:green_stained_glass_pane[display_name=<&e>Turn in <&a><[count]><&e>.]" d:<context.inventory>

world_event_turn_in_submit:
  type: task
  debug: false
  script:
    - foreach <script[world_event_config].keys[materials]> as:worth key:material
      - define count:+:<context.inventory.quantity[<[material]>].*[<[worth]>]>
    - flag player world_event.progress:+:<[count]>
    - inventory open d:world_event_turn_in

world_event_turn_in_events:
  type: world
  debug: false
  events:
    on player clicks in world_event_turn_in_events:
      - if <script[world_event_config].keys[materials].contains[<context.item.material.name>]>:
        - wait 1t
        - inject world_event_turn_in_update
        - stop
      - determine passively cancelled
      - if <context.item.has_nbt[action]>:
        - choose <context.item.nbt[action]>:
          - case close:
            - inventory close
          - case submit:
            - inject world_event_turn_in_submit