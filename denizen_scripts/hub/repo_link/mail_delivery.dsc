mail_delivery_events:
  type: world
  debug: false
  events:
    on player clicks block_flagged:mailbox:
    - if <player.has_flag[mail_delivery.current]>:
      - define number <context.location.flag[mailbox]>
      - define inventory <inventory[mail_delivery_mailbox_inventory]>
      - flag <[inventory]> mailbox:<[number]>
      - inventory open d:<[inventory]> player:<player>
    on player clicks in mail_delivery_mailbox_inventory:
    - if <context.cursor_item.flag[mailbox_number].if_null[null1]> == <context.inventory.flag[mailbox].if_null[null2]>:
      - narrate pass
      - narrate <context.raw_slot>

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