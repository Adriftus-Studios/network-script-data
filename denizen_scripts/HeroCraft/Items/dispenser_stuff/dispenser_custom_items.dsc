dispenser_custom_handling:
  type: world
  debug: false
  events:
    on block dispenses item:
      - if <context.item.has_flag[custom_dispense]>:
        - determine passively cancelled
        - wait 5t
        - inject custom_dispense_inventory_process

custom_dispense_inventory_process:
  type: task
  debug: false
  script:
    - define inventory_contents <context.location.inventory.list_contents>
    - if <context.location.has_flag[doorchime]>:
      - stop
    - flag <context.location> doorchime expire:500t
    - foreach <[inventory_contents]> as:item:
      - if !<[item].has_flag[custom_dispense]>:
        - foreach next
      - else if <[item].flag[custom_dispense]> == note:
        - define instrument <[item].flag[instrument]>
        - define pitch <[item].flag[pitch]>
        - playsound sound:block_note_block_<[instrument]> pitch:<[pitch]> <context.location>
        - wait 5t
      - else if <[item].flag[custom_dispense]> == pause:
        - wait <[item].flag[pause_duration]>t
      - else if <[item].flag[custom_dispense]> == confetti:
        - define direction <context.location.material.direction>
        - define location <context.location.center.add[<context.velocity.normalize>]>
        - inject confetti_charge_task
      - else if <[item].flag[custom_dispense]> == visual:
        - define particle <[item].flag[particle]>
        - define color <[item].flag[color]>
        - playeffect <[particle]> color:<[color]> <context.location>
    - flag <context.location> doorchime:!

confetti_charge_task:
  type: task
  debug: false
  script:
    - repeat 3:
      - playeffect effect:redstone at:<[location]> visibility:50 quantity:20 special_data:<util.random.int[1].to[3]>|<util.random.int[100].to[255]>,<util.random.int[100].to[255]>,<util.random.int[100].to[255]> offset:0.25
      - wait 5t
