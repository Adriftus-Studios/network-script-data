100_bank_note:
  type: item
  debug: false
  material: feather
  display name: <&a>$100 Bank Note
  lore:
    - <&a>Exhchange at a Bank
    - <&a>Worth $100
  flags:
    worth: 100
    bank_note: true
  mechanisms:
    custom_model_data: 600

1000_bank_note:
  type: item
  debug: false
  material: feather
  display name: <&a>$1,000 Bank Note
  lore:
    - <&a>Exhchange at a Bank
    - <&a>Worth $1,000
  flags:
    worth: 1000
    bank_note: true
  mechanisms:
    custom_model_data: 601

10000_bank_note:
  type: item
  debug: false
  material: feather
  display name: <&a>$10,000 Bank Note
  lore:
    - <&a>Exhchange at a Bank
    - <&a>Worth $10,000
  flags:
    worth: 10000
    bank_note: true
  mechanisms:
    custom_model_data: 602

bank_npc_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: <&a>This is a Bank... shh...
  definitions:
    purchase_bank_note_100: <item[purchase_bank_note].with[flag=worth:10000;lore=<&a>Worth $100;display=<&a>Purchase Bank Note;custom_model_data=600]>
    purchase_bank_note_1000: <item[purchase_bank_note].with[flag=worth:10000;lore=<&a>Worth $1,000;display=<&a>Purchase Bank Note;custom_model_data=601]>
    purchase_bank_note_10000: <item[purchase_bank_note].with[flag=worth:10000;lore=<&a>Worth $10,000;display=<&a>Purchase Bank Note;custom_model_data=602]>
  slots:
    - [purchase_bank_note_100] [] [] [] [purchase_bank_note_1000] [] [] [] [purchase_bank_note_10000]

purchase_bank_note:
  type: item
  debug: false
  material: feather
  flags:
    run_script: purchase_bank_note_task

purchase_bank_note_task:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - if <player.money> >= <context.item.flag[worth]>:
      - money take quantity:<context.item.flag[worth]>
      - define uuid <util.random_uuid>
      - flag server bank_notes.<[uuid]>:<context.item.flag[worth]>
      - give <item[<context.item.flag[worth]>_bank_note].with[flag=uuid:<[uuid]>]>
      - narrate "<&a>You have purchased a Bank Note!"
    - else:
      - narrate "<&c>You lack the funds to purchase this."

bank_npc_assignment:
  type: assignment
  debug: false
  actions:
    on_assignment:
      - trigger name:click state:true
    on click:
      - if <player.item_in_hand.has_flag[bank_note]>:
        - if <server.has_flag[bank_notes.<player.item_in_hand.flag[uuid]>]>:
          - money give quantity:<player.item_in_hand.flag[worth]>
          - flag server bank_notes.<player.item_in_hand.flag[uuid]>:!
          - take iteminhand quantity:1
          - narrate "<&a>You have exchanged your bank note!"
          - narrate "<&a>Your Balance<&co> <player.formatted_money>"
        - else:
          - title "title:<&c>This Bank Note is a Forgery!!!" "subtitle:The Police Have Been Alerted" fade_in:1t stay:4s fade_out:1s
      - else:
        - inventory open d:bank_npc_inventory