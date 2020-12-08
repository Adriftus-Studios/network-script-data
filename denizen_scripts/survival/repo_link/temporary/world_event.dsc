world_event_config:
  type: data
  materials:
    honey_bottle: 1
    honey_block: 4
    honeycomb: 3
    honeycomb_block: 12
    beehive: 9
    bee_nest: 12
  server_amount_needed: 5000
  personal_amount_needed: 500

currency_display_item:
  type: item
  debug: false
  material: name_tag
  display name: <&a>
  mechanisms:
    custom_model_data: 3

world_event_bar_0:
  type: item
  debug: false
  material: beetroot
  display name: <&a>0%
  mechanisms:
    custom_model_data: 3

world_event_bar_1:
  type: item
  debug: false
  material: beetroot
  display name: <&a>20%
  mechanisms:
    custom_model_data: 4

world_event_bar_2:
  type: item
  debug: false
  material: beetroot
  display name: <&a>40%
  mechanisms:
    custom_model_data: 5

world_event_bar_3:
  type: item
  debug: false
  material: beetroot
  display name: <&a>60%
  mechanisms:
    custom_model_data: 6

world_event_bar_4:
  type: item
  debug: false
  material: beetroot
  display name: <&a>80%
  mechanisms:
    custom_model_data: 7

world_event_bar_5:
  type: item
  debug: false
  material: beetroot
  display name: <&a>100%
  mechanisms:
    custom_model_data: 8

world_event_progress_assignment:
  type: assignment
  debug: false
  actions:
    on assignment:
    - trigger name:click state:true
    - trigger name:damage state:true
    on damage:
    - run world_event_progress_inventory_open
    on click:
    - run world_event_progress_inventory_open

world_event_progress_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: <&a>World Event
  definitions:
    G: white_stained_glass_pane[display_name=<&a>]
    T: "ender_chest[display_name=<&a>Turn in Materials;lore=<&e>- Honey Bottle (1)|<&e>- Honey Block (4)|<&e>- Honeycomb (3)|<&e>- Honeycomb Block (12)|<&e>- Bee Hive (9)|<&e>- Bee Nest (12)|;nbt=action/turn_in]"
    soon: "barrier[display_name=<&e>Coming Soon!]"
  slots:
    - [G] [G] [G] [G] [G] [G] [G] [G] [G]
    - [G] [G] [G] [G] [G] [G] [G] [G] [G]
    - [G] [] [] [] [G] [] [] [] [G]
    - [G] [] [] [G] [G] [G] [] [] [G]
    - [G] [G] [G] [T] [G] [G] [G] [G] [G]
    - [G] [G] [G] [G] [G] [G] [G] [G] [G]

world_event_progress_inventory_events:
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
    - define percentage <server.flag[world_event.progress].div[<script[world_event_config].data_key[server_amount_needed]>]||0>
    - if <[percentage]> > 1:
      - define percentage 1
    #- inventory set slot:5 o:world_event_bar_<[percentage].round_to_precision[0.2].mul[5]> d:<[inventory]>
    - define "lore:|:<&e>Server<&co> <&b><server.flag[world_event.progress]||0>/<script[world_event_config].data_key[server_amount_needed]>  <&6>(<server.flag[world_event.progress].div[<script[world_event_config].data_key[server_amount_needed]>].mul[100].round_to[2]||0>%)"
    - define lore:|:<list.pad_right[<[percentage].mul[20].round_down||0>].with[<&a>⬛].pad_right[20].with[<&7>⬛].unseparated>
    - define lore:|:<&a>
    - define percentage <player.flag[world_event.progress].div[<script[world_event_config].data_key[personal_amount_needed]>]||0>
    - if <[percentage]> > 1:
      - define percentage 1
    - define "lore:|:<&e>Personal<&co> <&b><player.flag[world_event.progress]||0>/<script[world_event_config].data_key[personal_amount_needed]> <&6>(<player.flag[world_event.progress].div[<script[world_event_config].data_key[personal_amount_needed]>].mul[100].round_to[2]||0>%)"
    - define lore:|:<list.pad_right[<[percentage].mul[20].round_down||0>].with[<&a>⬛].pad_right[20].with[<&7>⬛].unseparated>
    - inventory set slot:5 "o:player_head[skull_skin=<player.skull_skin>;lore=<[lore]>;display_name=<&a>World Event Progress]" d:<[inventory]>
    - inventory set slot:42 "o:currency_display_item[display_name=<&6>Tokens<&co><&e> <player.flag[world_event.tokens.current]||0>;lore=<&7>Awarded at the end of the week|<&7>Incoming Tokens<&co> <&a><player.flag[world_event.progress].div[4].round_down||0>]" d:<[inventory]>
    - give "iron_ingot[display_name=<&a>Week 1;lore=<&e>- Iron Ingots|<&e>- Iron Blocks]" to:<[inventory]>
    - give "scute[display_name=<&a>Week 2;lore=<&e>- Scutes]" to:<[inventory]>
    - give "bee_nest[display_name=<&a>Week 3;lore=<&e>- Honey Bottle|<&e>- Honey Block|<&e>- Honeycomb|<&e>- Honeycomb Block|<&e>- Bee Hive|<&e>- Bee Nest|]" to:<[inventory]>
    - repeat 6:
      - give "barrier[display_name=<&a>Week <[value].add[2]>;lore=<&b>Release Date<&co>|<&e><time[2020/12/04_02:20:31:123_-07:00].add[<[value].mul[7]>d].format[MM/dd/YYYY]>]" to:<[inventory]>
    - inventory open d:<[inventory]>

world_event_turn_in:
  type: inventory
  debug: false
  inventory: chest
  title: <&6>Turn Ins
  definitions:
    filler: white_stained_glass_pane[display_name=<&a>]
    close: "barrier[display_name=<&c>Back;nbt=action/close]"
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
    - foreach <script[world_event_config].data_key[materials]> as:worth key:material:
      - define count:+:<context.inventory.quantity[<[material]>].mul[<[worth]>]>
    - inventory set slot:50 "o:green_stained_glass_pane[display_name=<&e>Turn in <&a><[count]||0><&e>.;nbt=action/submit]" d:<context.inventory>

world_event_turn_in_submit:
  type: task
  debug: false
  script:
    - foreach <script[world_event_config].data_key[materials]> as:worth key:material:
      - define count:+:<context.inventory.quantity[<[material]>].mul[<[worth]>]>
    - flag player world_event.progress:+:<[count]||0>
    - flag server world_event.progress:+:<[count]||0>
    - narrate "<&e>You are now at <&b><player.flag[world_event.progress]>/<script[world_event_config].data_key[personal_amount_needed]>."
    - inventory open d:world_event_turn_in

world_event_turn_in_events:
  type: world
  debug: false
  events:
    on player clicks in world_event_turn_in:
      - if <script[world_event_config].list_keys[materials].contains[<context.item.material.name>]> || <context.item.material.name> == air:
        - wait 1t
        - inject world_event_turn_in_update
        - stop
      - determine passively cancelled
      - if <context.item.has_nbt[action]>:
        - choose <context.item.nbt[action]>:
          - case close:
            - run world_event_progress_inventory_open
          - case submit:
            - inject world_event_turn_in_submit
