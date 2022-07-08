trade_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: <&f><&font[adriftus:guis]><&chr[F808]><&chr[6932]>
  size: 54
  data:
    item_slots:
      player_1_head: 5
      player_2_head: 14
      player_1_confirm: 48
      player_1_confirm2: 49
      player_2_confirm: 52
      player_2_confirm2: 51
      player_1_currency_button: 39
      player_2_currency_button: 43
    click_script_slots:
      # Player Heads
      #1: cancel
      #9: cancel
      # Player 1 Trade Slots
      1: trade_player_1_slot
      2: trade_player_1_slot
      3: trade_player_1_slot
      4: trade_player_1_slot
      10: trade_player_1_slot
      11: trade_player_1_slot
      12: trade_player_1_slot
      13: trade_player_1_slot
      19: trade_player_1_slot
      20: trade_player_1_slot
      21: trade_player_1_slot
      22: trade_player_1_slot
      28: trade_player_1_slot
      29: trade_player_1_slot
      30: trade_player_1_slot
      31: trade_player_1_slot
      37: cancel
      38: cancel
      39: cancel
      40: cancel
      46: cancel
      47: cancel
      #48: trade_player_1_slot
      #49: trade_player_1_slot
      # Player 2 Trade Slots
      6: trade_player_2_slot
      7: trade_player_2_slot
      8: trade_player_2_slot
      9: trade_player_2_slot
      15: trade_player_2_slot
      16: trade_player_2_slot
      17: trade_player_2_slot
      18: trade_player_2_slot
      24: trade_player_2_slot
      25: trade_player_2_slot
      26: trade_player_2_slot
      27: trade_player_2_slot
      33: trade_player_2_slot
      34: trade_player_2_slot
      35: trade_player_2_slot
      36: trade_player_2_slot
      42: cancel
      43: cancel
      44: cancel
      45: cancel
      #51: trade_player_2_slot
      #52: trade_player_2_slot
      53: cancel
      54: cancel
      #Middle Column
      5: cancel
      14: cancel
      23: cancel
      32: cancel
      41: cancel
      50: cancel
    on_close: trade_inventory_cancel
    on_drag: cancel
    any_click: trade_sanitize

trade_data_initialize:
  type: world
  debug: false
  init:
    - flag server trade_slots:!
    - foreach <script[trade_inventory].data_key[data.click_script_slots]> key:slot as:script:
      - if !<[script].starts_with[trade_player_]>:
        - foreach next
      - define number <[script].substring[14,14]>
      - flag server trade_slots.<[number]>:->:<[slot]>
  events:
    on server start:
      - inject locally path:init
    on script reload:
      - inject locally path:init

trade_confirm_button:
  type: item
  debug: false
  material: feather
  display name: <&a>Confirm Trade
  lore:
    - "<&a>Accept the trade"
  mechanisms:
    custom_model_data: 3
  flags:
    run_script: trade_player_confirm

trade_cancel_confirm_button11:
  type: item
  debug: false
  material: paper
  display name: <&a>Cancel Confirm
  lore:
    - "<&a>Cancel the confirmation"
    - "<&e>Allows further changes"
  flags:
    run_script: trade_player_cancel_confirm
  mechanisms:
    custom_model_data: 1100

trade_cancel_confirm_button12:
  type: item
  debug: false
  material: paper
  display name: <&a>Cancel Confirm
  lore:
    - "<&a>Cancel the confirmation"
    - "<&e>Allows further changes"
  flags:
    run_script: trade_player_cancel_confirm
  mechanisms:
    custom_model_data: 1101

trade_cancel_confirm_button21:
  type: item
  debug: false
  material: paper
  display name: <&a>Cancel Confirm
  lore:
    - "<&a>Cancel the confirmation"
    - "<&e>Allows further changes"
  flags:
    run_script: trade_player_cancel_confirm
  mechanisms:
    custom_model_data: 1103

trade_cancel_confirm_button22:
  type: item
  debug: false
  material: paper
  display name: <&a>Cancel Confirm
  lore:
    - "<&a>Cancel the confirmation"
    - "<&e>Allows further changes"
  flags:
    run_script: trade_player_cancel_confirm
  mechanisms:
    custom_model_data: 1102

trade_currency_button:
  type: item
  debug: false
  material: feather
  display name: <&a>Currency
  lore:
    - "<&c>Unavailable"
  flags:
    run_script: cancel
  mechanisms:
    custom_model_data: 3

trade_open:
  type: task
  debug: false
  definitions: player2|player1
  script:
    - define player1 <player> if:<[player1].exists.not>
    - note <inventory[trade_inventory]> as:trade_<[player1].uuid>/<[player2].uuid>
    - define inv_script <inventory[trade_inventory].script>
    - inventory set slot:<[inv_script].data_key[data.item_slots.player_1_head]> o:player_head[skull_skin=<[player1].skull_skin>;display=<&a><[player1].name>;custom_model_data=100;flag=uuid:<[player1].uuid>] d:trade_<[player1].uuid>/<[player2].uuid>
    - inventory set slot:<[inv_script].data_key[data.item_slots.player_2_head]> o:player_head[skull_skin=<[player2].skull_skin>;display=<&a><[player2].name>;custom_model_data=101;flag=uuid:<[player2].uuid>] d:trade_<[player1].uuid>/<[player2].uuid>
    - foreach <[inv_script].data_key[data.item_slots.player_1_confirm]>|<[inv_script].data_key[data.item_slots.player_1_confirm2]>:
      - inventory set slot:<[value]> o:trade_confirm_button[flag=player:1] d:trade_<[player1].uuid>/<[player2].uuid>
    - foreach <[inv_script].data_key[data.item_slots.player_2_confirm]>|<[inv_script].data_key[data.item_slots.player_2_confirm2]>:
      - inventory set slot:<[value]> o:trade_confirm_button[flag=player:2] d:trade_<[player1].uuid>/<[player2].uuid>
    - inventory set slot:<[inv_script].data_key[data.item_slots.player_1_currency_button]> o:trade_currency_button[flag=player:1] d:trade_<[player1].uuid>/<[player2].uuid>
    - inventory set slot:<[inv_script].data_key[data.item_slots.player_2_currency_button]> o:trade_currency_button[flag=player:2] d:trade_<[player1].uuid>/<[player2].uuid>
    - inventory open d:trade_<[player1].uuid>/<[player2].uuid>
    - inventory open d:trade_<[player1].uuid>/<[player2].uuid> player:<[player2]>

trade_player_1_slot:
  type: task
  debug: false
  script:
    - if <player.uuid> != <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_1_head]>].flag[uuid]>:
      - determine cancelled
    - if <player.item_on_cursor.material.name> == air && !<context.item.exists>:
      - stop
    - if <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_1_confirm]>].script.name> == trade_cancel_confirm_button11:
      - foreach <context.inventory.script.data_key[data.item_slots.player_1_confirm]>|<context.inventory.script.data_key[data.item_slots.player_1_confirm2]>:
        - inventory set slot:<[value]> o:trade_confirm_button[flag=player:1] d:<context.inventory>
    - if <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_2_confirm]>].script.name> == trade_cancel_confirm_button21:
      - foreach <context.inventory.script.data_key[data.item_slots.player_2_confirm]>|<context.inventory.script.data_key[data.item_slots.player_2_confirm2]>:
        - inventory set slot:<[value]> o:trade_confirm_button[flag=player:2] d:<context.inventory>

trade_player_2_slot:
  type: task
  debug: false
  script:
    - if <player.uuid> != <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_2_head]>].flag[uuid]>:
      - determine cancelled
    - if <player.item_on_cursor.material.name> == air && !<context.item.exists>:
      - stop
    - if <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_1_confirm]>].script.name> == trade_cancel_confirm_button11:
      - foreach <context.inventory.script.data_key[data.item_slots.player_1_confirm]>|<context.inventory.script.data_key[data.item_slots.player_1_confirm2]>:
        - inventory set slot:<[value]> o:trade_confirm_button[flag=player:1] d:<context.inventory>
    - if <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_2_confirm]>].script.name> == trade_cancel_confirm_button21:
      - foreach <context.inventory.script.data_key[data.item_slots.player_2_confirm]>|<context.inventory.script.data_key[data.item_slots.player_2_confirm2]>:
        - inventory set slot:<[value]> o:trade_confirm_button[flag=player:2] d:<context.inventory>

trade_player_confirm:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - ratelimit <player> 2t
    - define number <context.item.flag[player]>
    - stop if:<context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_<[number]>_head]>].flag[uuid].equals[<player.uuid>].not>
    - foreach <context.inventory.script.data_key[data.item_slots.player_<[number]>_confirm]>|<context.inventory.script.data_key[data.item_slots.player_<[number]>_confirm2]>:
      - inventory set slot:<[value]> o:trade_cancel_confirm_button<[number]><[loop_index]>[flag=player:<[number]>] d:<context.inventory>
    - if <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_2_confirm]>].script.name> == trade_cancel_confirm_button21 && <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_1_confirm]>].script.name> == trade_cancel_confirm_button11:
      - inject trade_inventory_complete

trade_player_cancel_confirm:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - ratelimit <player> 2t
    - define number <context.item.flag[player]>
    - stop if:<context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_<[number]>_head]>].flag[uuid].equals[<player.uuid>].not>
    - foreach <context.inventory.script.data_key[data.item_slots.player_<[number]>_confirm]>|<context.inventory.script.data_key[data.item_slots.player_<[number]>_confirm2]>:
      - inventory set slot:<[value]> o:trade_confirm_button[flag=player:<[number]>] d:<context.inventory>


trade_inventory_complete:
  type: task
  debug: false
  script:
    - ratelimit <context.inventory> 2t
    - define player.1 <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_1_head]>].flag[uuid].as_player>
    - define player.2 <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_2_head]>].flag[uuid].as_player>
    - define inv_script <context.inventory.script>
    - define inverse <list[2|1]>
    - foreach <context.inventory.map_slots> key:slot as:item:
      - if <[inv_script].data_key[data.click_script_slots.<[slot]>].exists> && <[inv_script].data_key[data.click_script_slots.<[slot]>].starts_with[trade_player]>:
        - define number <[inverse].get[<[inv_script].data_key[data.click_script_slots.<[slot]>].substring[14,14]>]>
        - define target <[player.<[number]>]>
        - give <[item]> to:<player[<[player.<[number]>]>].inventory>
    - inventory set slot:<context.inventory.script.data_key[data.item_slots.player_1_confirm]> o:air d:<context.inventory>
    - inventory close

trade_inventory_cancel:
  type: task
  debug: false
  script:
    - ratelimit <context.inventory> 2t
    - stop if:<context.inventory.equals[<player.inventory>]>
    - define player.1 <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_1_head]>].flag[uuid].as_player>
    - define player.2 <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_2_head]>].flag[uuid].as_player>
    - if <[player.1].open_inventory.note_name.if_null[null]> == trade_<[player.1].uuid>/<[player.2].uuid> && <player> != <[player.1]>:
      - inventory close player:<[player.1]>
    - if <[player.2].open_inventory.note_name.if_null[null]> == trade_<[player.1].uuid>/<[player.2].uuid> && <player> != <[player.2]>:
      - inventory close player:<[player.2]>
    - if <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_1_confirm]>].material.name> != air:
      - inventory set slot:<context.inventory.script.data_key[data.item_slots.player_1_confirm]> o:air d:<context.inventory>
      - define inv_script <context.inventory.script>
      - foreach <context.inventory.map_slots> key:slot as:item:
        - if <[inv_script].data_key[data.click_script_slots.<[slot]>].exists> && <[inv_script].data_key[data.click_script_slots.<[slot]>].starts_with[trade_player]>:
          - define number <[inv_script].data_key[data.click_script_slots.<[slot]>].substring[14,14]>
          - define target <[player.<[number]>]>
          - give <[item]> to:<player[<[player.<[number]>]>].inventory>
    - note remove as:<context.inventory.note_name>

trade_sanitize:
  type: task
  debug: false
  script:
    - ratelimit <player> 1t
    - if !<list[LEFT|RIGHT].contains[<context.click>]>:
      - if <context.clicked_inventory> == <context.inventory>:
        - stop
      - if !<context.is_shift_click>:
        - determine cancelled
      - if <context.inventory.slot[<script[trade_inventory].data_key[data.item_slots.player_1_head]>].flag[uuid]> == <player.uuid>:
        - define number 1
      - else:
        - define number 2
      - foreach <server.flag[trade_slots.<[number]>]>:
        - if <context.inventory.slot[<[value]>].material.name> == air:
          - inventory set slot:<[value]> o:<context.item> d:<context.inventory>
          - if <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_1_confirm]>].script.name> == trade_cancel_confirm_button11:
            - foreach <context.inventory.script.data_key[data.item_slots.player_1_confirm]>|<context.inventory.script.data_key[data.item_slots.player_1_confirm2]>:
              - inventory set slot:<[value]> o:trade_confirm_button[flag=player:1] d:<context.inventory>
          - if <context.inventory.slot[<context.inventory.script.data_key[data.item_slots.player_2_confirm]>].script.name> == trade_cancel_confirm_button21:
            - foreach <context.inventory.script.data_key[data.item_slots.player_2_confirm]>|<context.inventory.script.data_key[data.item_slots.player_2_confirm2]>:
              - inventory set slot:<[value]> o:trade_confirm_button[flag=player:2] d:<context.inventory>
          - determine air
      - determine cancelled