repair_command:
  type: command
  name: repair
  debug: false
  description: repairs an item you're holding.
  usage: /repair
  adminusage: /repair
  permission: behr.essentials.repair
  script:
  # % ██ [ check for args         ] ██
    - if <context.args.size> > 1:

      - if <context.args.size> > 2:
        - inject command_syntax

      # % ██ [ run as moderator   ] ██
      - if !<player.in_group[moderator]>:
        - inject admin_permission_denied

      # % ██ [ repair equipped    ] ██
      - if <context.args.first.contains_any[equipment|equipped]>:
        - define list <player.inventorys.slot[37|38|39|40|41]>
        - define inventory <player.inventory>

      # % ██ [ repair everything  ] ██
      - else if <context.args.first.contains_any[all|everything|full|inventory|inv|player]>
        - define list <player.inventorys.list_contents>
        - define inventory <player.inventory>

      # % ██ [ repair a chest     ] ██
      - else if <context.args.first.contains_any[chest]>
        - if <player.cursor_on.inventory||invalid> == invalid:
          - define reason "You must look at a chest to use this."
          - inject command_error
        - define list <player.cursor_on.inventory.list_contents>
        - define inventory <player.cursor_on.inventory>

      - else:
        - inject command_syntax
      
    # % ██ [ repair items         ] ██
      - define count 0
      - foreach <[list]> as:slot:
        - if <[inventory].slot[<[slot]>].repairable>:
          - inventory adjust slot:<[slot]> durability:0 d:<[inventory]>
          - define count:++

      - if <[count]> == 0:
        - narrate format:colorize_yellow "No items to repair."
      - else:
        - narrate format:colorize_green "Repaired <[count]> items."

    # % ██ [ run as self          ] ██
    - else:
      
    # % ██ [ check item           ] ██
      - if !<player.item_in_hand.repairable>:
        - define reason "item cannot be repaired."
        - inject command_error
      
    # % ██ [ repair item          ] ██
      - inventory adjust slot:<player.held_item_slot> durability:0
      - if <player.item_in_hand.has_display>:
        - narrate "<proc[colorize].context[You repaired your|green]> <player.item_in_hand.material.display_name><&2>."
      - else:
        - narrate format:colorize_green "You repaired your <player.item_in_hand.material.name>."
