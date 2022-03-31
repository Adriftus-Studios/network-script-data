mail_delivery_config:
  type: data
  difficulties:
    easy:
      time: 5m
      mail_items_min: 6
      mail_items_max: 9
    medium:
      time: 2m
      mail_items_min: 12
      mail_items_max: 18
    hard:
      time: 1m
      mail_items_min: 18
      mail_items_max: 27

mail_delivery_start:
  type: task
  debug: false
  definitions: difficulty|player
  script:
  - define difficulty <[difficulty].if_null[easy]>
  - adjust <queue> linked_player:<[player]> if:<[player].exists>
  - if <player.location.is_within[mail_delivery_area].not>:
    - narrate "<&c>You are outside the challenge area."
    - stop
  # - define slots <[slots].random[<script[mail_delivery_config].data_key[difficulties.<[difficulty]>.mail_items]>]>
  # - if <[slots].size> < <script[mail_delivery_config].data_key[difficulties.<[difficulty]>.mail_items]>:
  #   - narrate "<&c>You do not have enough empty slots in your inventory."
  #   - stop
  - flag <player> minigame.active
  - flag <player> mail_delivery.current.inventory:<player.inventory.map_slots>
  - inventory clear d:<player.inventory>
  - define slots <list[10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36].exclude[<player.inventory.map_slots.keys>]>
  - foreach <[slots].random[<util.random.int[<script[mail_delivery_config].data_key[difficulties.<[difficulty]>.mail_items_min]>].to[<script[mail_delivery_config].data_key[difficulties.<[difficulty]>.mail_items_max]>]>]> as:slot:
    - define mailbox_number <[loop_index].mod[6].add[1]>
    - define item <proc[mail_delivery_generate_item].context[<[mailbox_number]>]>
    - inventory set d:<player.inventory> slot:<[slot]> o:<[item]>
    - flag <player> mail_delivery.current.todo.<[mailbox_number]>:+:1
  - define time <script[mail_delivery_config].data_key[difficulties.<[difficulty]>.time].as_duration>
  - flag <player> mail_delivery.current.time:<util.time_now.in_seconds.milliseconds> expire:<[time]>
  - flag <player> mail_delivery.current.difficulty:<[difficulty]>
  - repeat <[time].in_seconds>:
    - actionbar "<&e>Time Remaining: <&r><&e><&l><[time].sub[<duration[<[value]>s]>].formatted_words>" targets:<player>
    - wait 1s
    - stop if:<player.has_flag[mail_delivery.current].not>
  - run mail_delivery_fail_time def:<player> if:<player.flag[mail_delivery.current.todo].values.sum.if_null[0].equals[0].not>

mail_delivery_fail_forfeit:
  type: task
  debug: false
  definitions: player
  script:
  - adjust <queue> linked_player:<[player]> if:<[player].exists>
  - stop if:<player.has_flag[mail_delivery.current].not>
  - narrate "<&c>You forfeit the session."
  - run mail_delivery_end def:<player>

mail_delivery_fail_area:
  type: task
  debug: false
  definitions: player
  script:
  - adjust <queue> linked_player:<[player]> if:<[player].exists>
  - stop if:<player.has_flag[mail_delivery.current].not>
  - narrate "<&c>You left the minigame area."
  - run mail_delivery_end def:<player>

mail_delivery_fail_time:
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
  - define time_taken <util.time_now.in_seconds.milliseconds.sub[<player.flag[mail_delivery.current.time]>].div[1000]>
  - narrate "<&e>You delivered all the mail in <[time_taken]> seconds."
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
  - foreach <player.flag[mail_delivery.current.inventory].if_null[<map[]>]> key:slot as:item:
    - inventory set d:<player.inventory> slot:<[slot]> o:<[item]>
  - flag <player> mail_delivery.current:!
  - flag <player> minigame.active:!

mail_delivery_apply_to_leaderboard:
  type: task
  debug: false
  definitions: player|difficulty|time_taken
  script:
  - narrate TODO
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
    on player exits mail_delivery_area:
    - stop if:<player.has_flag[mail_delivery.current].not>
    - run mail_delivery_fail_area def:<player>

mail_delivery_mail_item:
  type: item
  material: paper
  display name: Mail

mail_delivery_mailbox_events:
  type: world
  debug: false
  events:
    on player clicks in mail_delivery_mailbox_inventory:
    - narrate TODO

mail_delivery_mailbox_inventory:
  type: inventory
  inventory: chest
  size: 45
  title: <&f><&font[adriftus:guis]><&chr[F808]><&chr[6914]>
  slots:
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []

mail_delivery_generate_item:
  type: procedure
  debug: false
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
  data:
    leaderboard:
      easy:
        1: 5
        2: 6
        3: 7
        4: 8
        5: 9
      medium:
        1: 14
        2: 15
        3: 16
        4: 17
        5: 18
      hard:
        1: 23
        2: 24
        3: 25
        4: 26
        5: 27
  slots:
  - [mail_delivery_icon_start_easy] [mail_delivery_icon_start_easy] [] [] [] [] [] [] []
  - [mail_delivery_icon_start_medium] [mail_delivery_icon_start_medium] [] [] [] [] [] [] []
  - [mail_delivery_icon_start_hard] [mail_delivery_icon_start_hard] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [mail_delivery_icon_help] [] [] [] [mail_delivery_icon_stop] [] []

mail_delivery_open_menu:
  type: task
  debug: false
  definitions: player
  script:
  - adjust <queue> linked_player:<[player]> if:<[player].exists>
  - define inv <inventory[mail_delivery_menu_inventory]>

  - inventory open d:<[inv]>

mail_delivery_menu_inventory_npc_assignment:
  type: assignment
  actions:
    on click:
    - run mail_delivery_open_menu def:<player>

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
        - run mail_delivery_fail_forfeit def:<player>

mail_delivery_icon_stop:
  type: item
  material: barrier
  display name: <&4><&l>Forfeit ongoing session.

mail_delivery_icon_help:
  type: item
  material: crafting_table
  display name: <&b><&m>---<&r><&8><&m>｜-<&r>  <&8><&m>+----------------------------------+<&r>  <&8><&m>-｜<&b><&m>---
  lore:
  - <&7>* <&e>Name: <&7>Mail Delivery!
  - <&7>* <&e>Description: <&7>The post-master is shorthanded,
  - <&7>  and needs these packages delivered ASAP,
  - <&7>  or the customer gets a refund. <&o>*shiver*
  - <&r>
  - <&7>  Help the post-master deliver all of the packages on time.
  - <&7>
  - <&7>  Around the area, you should see mail-boxes
  - <&7>  with a coresponding number above them.
  - <&7>  Deliver the the packages to the
  - <&7>  address you see on the box. This is a
  - <&7>  timed event, and your score is being recorded!
  - <&7>  Who knows, maybe you could be the next post master.
  - <&b><&m>---<&r><&8><&m>｜-<&r>  <&8><&m>+----------------------------------+<&r>  <&8><&m>-｜<&b><&m>---

mail_delivery_icon_start_easy:
  type: item
  material: feather
  display name: <&7>Start -- <&l><&a>Easy <&r><&a>[5 Minute]
  mechanisms:
    custom_model_data: 3

mail_delivery_icon_start_medium:
  type: item
  material: feather
  display name: <&7>Start -- <&l><&6>Medium <&r><&6>[2 Minute]
  mechanisms:
    custom_model_data: 3

mail_delivery_icon_start_hard:
  type: item
  material: feather
  display name: <&7>Start -- <&l><&c>Hard <&r><&c>[1 Minute]
  mechanisms:
    custom_model_data: 3