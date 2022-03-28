mail_delivery_config:
  type: data
  difficulties:
    easy:
      time: 5m
      mail_items: 6
    medium:
      time: 2m
      mail_items: 12
    hard:
      time: 1m
      mail_items: 18

mail_delivery_start:
  type: task
  debug: false
  definitions: difficulty|player
  script:
  - define difficulty <[difficulty].if_null[easy]>
  - adjust <queue> linked_player:<[player]> if:<[player].exists>
  - if <player.inventory.empty_slots> < 18:
    - narrate "<&c>You have too many items in your inventory to begin this challenge."
    - stop
  - if <player.location.is_within[mail_delivery_area].not>:
    - narrate "<&c>You are outside the challenge area."
    - stop
  - define slots <list[1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36].exclude[<player.inventory.map_slots.keys>]>
  - define slots <[slots].random[<script[mail_delivery_config].data_key[difficulties.<[difficulty]>.mail_items]>]>
  - if <[slots].size> < <script[mail_delivery_config].data_key[difficulties.<[difficulty]>.mail_items]>:
    - narrate "<&c>You do not have enough empty slots in your inventory."
    - stop
  - foreach <[slots]> as:slot:
    # - define mailbox_number <[loop_index].mod[1].add[1]>
    - define mailbox_number <[loop_index].mod[6].add[1]>
    - define item <proc[mail_delivery_generate_item].context[<[mailbox_number]>]>
    - inventory set d:<player.inventory> slot:<[slot]> o:<[item]>
    - flag <player> mail_delivery.current.todo.<[mailbox_number]>:+:1
  - define time <script[mail_delivery_config].data_key[difficulties.<[difficulty]>.time].as_duration>
  - flag <player> mail_delivery.current.time expire:<[time]>
  - flag <player> mail_delivery.current.difficulty:<[difficulty]>
  - repeat <[time].in_seconds>:
    - actionbar "<&e>Time Remaining: <&r><&e><&l><[time].sub[<duration[<[value]>s]>].formatted_words>" targets:<player>
    - wait 1s
    - stop if:<player.has_flag[mail_delivery.current].not>
  - run mail_delivery_fail def:<player> if:<player.flag[mail_delivery.current.todo].values.sum.if_null[0].equals[0].not>

mail_delivery_fail:
  type: task
  debug: false
  definitions: player
  script:
  - adjust <queue> linked_player:<[player]> if:<[player].exists>
  - stop if:<player.has_flag[mail_delivery.current].not>
  - actionbar "<&c>You ran out of time." targets:<player>
  - define time_remaining <player.flag[mail_delivery.current.todo].values.sum>
  - narrate "<&c>You failed to deliver all of the mail in time, You had <[time_remaining]> left."
  - run mail_delivery_end def:<player>

mail_delivery_complete:
  type: task
  debug: false
  definitions: player
  script:
  - adjust <queue> linked_player:<[player]> if:<[player].exists>
  - stop if:<player.has_flag[mail_delivery.current].not>
  - define difficulty <player.flag[mail_delivery.current.difficulty]>
  - define time <script[mail_delivery_config].data_key[difficulties.<[difficulty]>.time].as_duration>
  - define time_remaining:<player.flag_expiration[mail_delivery.current.time].from_now.if_null[0s]>
  - narrate "<&e>You delivered all the mail in <[time].sub[<[time_remaining]>].formatted_words>"
  - run mail_delivery_end def:<player>

mail_delivery_end:
  type: task
  debug: false
  definitions: player
  script:
  - adjust <queue> linked_player:<[player]> if:<[player].exists>
  - inventory close player:<player>
  - wait 1t
  - take slot:<player.inventory.find_all_items[mail_delivery_mail_item]> from:<player.inventory>
  - flag <player> mail_delivery.current:!

mail_delivery_events:
  type: world
  debug: false
  events:
    on player right clicks block:
    - stop if:<player.has_flag[mail_delivery.current].not>
    - stop if:<context.location.has_flag[mailbox].not>
    - define number <context.location.flag[mailbox]>
    - note <inventory[mail_delivery_mailbox_inventory]> as:mailbox_<[number]>_<player.uuid>
    - define inventory <inventory[mailbox_<[number]>_<player.uuid>]>
    - flag <[inventory]> mailbox:<[number]>
    - inventory open d:<[inventory]> player:<player>
    on player closes mail_delivery_mailbox_inventory:
    - stop if:<player.has_flag[mail_delivery.current].not>
    - if <context.inventory.note_name.is_truthy>:
      - define mailbox <context.inventory.flag[mailbox]>
      - define difficulty <player.flag[mail_delivery.current.difficulty]>
      - foreach <context.inventory.map_slots> key:slot as:item:
        - if <[item].flag[mailbox_number].equals[<[mailbox]>].not.if_null[true]>:
          - inventory set d:<context.inventory> slot:<[slot]> o:air
          - give to:<player.inventory> <[item]>
        - else:
          - narrate "Delivered <[item].display>"
          - flag <player> mail_delivery.current.todo.<[mailbox]>:-:1
      - wait 1t
      - run mail_delivery_complete def:<player> if:<player.flag[mail_delivery.current.todo].values.sum.if_null[1].equals[0]>
      - note remove as:<context.inventory.note_name>
    on player drops mail_delivery_mail_item:
    - stop if:<player.has_flag[mail_delivery.current].not>
    - determine cancelled

mail_delivery_mail_item:
  type: item
  material: paper
  display name: Mail

mail_delivery_mailbox_inventory:
  type: inventory
  inventory: chest
  size: 9
  slots:
  - [] [] [] [] [] [] [] [] []

mail_delivery_generate_item:
  type: procedure
  debug: true
  definitions: number
  script:
  - define item <item[mail_delivery_mail_item].with[flag=mailbox_number:<[number]>].with[flag=no_stack:<util.random_uuid>]>
  - define item <[item].with[lore=<&e>Destination<&co><&sp><[number]>]>
  - choose <util.random.int[1].to[3]>:
    - case 1:
      - define item <[item].with[material=crafting_table]>
      - define item <[item].with[display_name=<&e>Package]>
    - case 2:
      - define item <[item].with[material=paper]>
      - define item <[item].with[display_name=<&e>Letter]>
    - case 3:
      - define item <[item].with[material=stripped_oak_wood]>
      - define item <[item].with[display_name=<&e>Container]>
  - determine <[item]>

mail_delivery_menu_inventory:
  type: inventory
  inventory: chest
  size: 45
  gui: true
  procedural items:
  # TODO: program top 5 leaderboard for each difficulty.
  - define items <list[]>
  - foreach <list[easy|medium|hard]> as:d:
    - repeat 5 as:number:
      - if <server.has_flag[mail_delivery.leaderboard.<[d]>.<[number]>]>:
        - define player <server.has_flag[mail_delivery.leaderboard.<[d]>.<[number]>]>
      - else:
        - define items:|:<item[player_head]>
  - determine <[items]>
  slots:
  - [mail_delivery_icon_start_easy] [standard_filler] [standard_filler] [standard_filler] [] [] [] [] []
  - [mail_delivery_icon_start_medium] [standard_filler] [standard_filler] [standard_filler] [] [] [] [] []
  - [mail_delivery_icon_start_hard] [standard_filler] [standard_filler] [standard_filler] [] [] [] [] []
  - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]
  - [standard_filler] [standard_filler] [mail_delivery_icon_help] [standard_filler] [standard_filler] [standard_filler] [mail_delivery_icon_stop] [standard_filler] [standard_filler]

mail_delivery_menu_inventory_npc_assignment:
  type: assignment
  actions:
    on click:
    - inventory open d:mail_delivery_menu_inventory

mail_delivery_menu_events:
  type: world
  debug: false
  events:
    on player clicks item in mail_delivery_menu_inventory:
    - stop if:<context.item.script.exists.not>
    - choose <context.item.script.name>:
      - case mail_delivery_icon_start_easy:
        - inventory close
        - run mail_delivery_start def:easy|<player>
      - case mail_delivery_icon_start_medium:
        - inventory close
        - run mail_delivery_start def:medium|<player>
      - case mail_delivery_icon_start_hard:
        - inventory close
        - run mail_delivery_start def:hard|<player>
      - case mail_delivery_icon_stop:
        - inventory close
        - run mail_delivery_fail def:<player>

mail_delivery_icon_stop:
  type: item
  material: barrier
  display name: <&4><&l>Forfeit ongoing session.

mail_delivery_icon_help:
  type: item
  material: crafting_table
  display name: TODO<&co> Minigame explanation.

mail_delivery_icon_start_easy:
  type: item
  material: iron_ingot
  display name: Start<&co> <&a>Easy

mail_delivery_icon_start_medium:
  type: item
  material: gold_ingot
  display name: Start<&co> <&6>Medium

mail_delivery_icon_start_hard:
  type: item
  material: diamond
  display name: Start<&co> <&c>Hard
