totem_test:
  type: task
  debug: false
  definitions: cmd
  script:
    - define item <player.item_in_hand>
    - inventory set slot:<player.held_item_slot> o:totem_of_undying[custom_model_data=<[cmd]>]
    - animate <player> animation:TOTEM_RESURRECT for:<player>
    - inventory set slot:<player.held_item_slot> o:<[item]>