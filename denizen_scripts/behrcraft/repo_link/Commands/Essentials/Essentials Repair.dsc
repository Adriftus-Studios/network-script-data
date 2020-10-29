repair_command:
  type: command
  name: repair
  debug: false
  description: repairs an item you're holding.
  usage: /repair
  adminusage: /repair
  permission: behr.essentials.repair
  equipment:
    - foreach 37|38|39|40|41 as:slot:
      - if <player.inventory.slot[<[slot]>].repairable>:
        - inventory adjust slot:<[slot]> durability:0
        - define count:++
  inventory:
    - foreach <player.inventory.list_contents> as:slot:
      - if <player.inventory.slot[<[slot]>].repairable>:
        - inventory adjust slot:<[slot]> durability:0
        - define count:++
  chest:
    - define inventory <player.cursor_on.inventory>
    - foreach <[inventory].list_contents> as:slot:
      - if <[inventory].slot[<[slot]>].repairable>:
        - inventory adjust slot:<[slot]> durability:0 d:<[inventory]>
        - define count:++
  script:
  # % ██ [ check for args ] ██
    - if <context.args.size> > 1:

      # % ██ [ run as moderator ] ██
      - if <context.args.size> > 2:
        - inject command_syntax

      - if !<player.in_group[moderator]>:
        - inject admin_permission_denied

      # % ██ [ repair everyything ] ██
      - if <context.args.first.contains_any[all|everything|full]>:
        - run locally inventory
        - run locally equipment
        - if <[count]||invalid> == invalid:
          - narrate format:colorize_yellow "No items to repair."
        - else:
          - narrate format:colorize_green "Repaired <[count]> items."

      # % ██ [ repair just the inventory ] ██
      - else if <context.args.first.contains_any[inventory|inv|player]>
        - run locally inventory
        - if <[count]||invalid> == invalid:
          - narrate format:colorize_yellow "No items to repair."
        - else:
          - narrate format:colorize_green "Repaired <[count]> items."

      # % ██ [ repair a chest ] ██
      - else if <context.args.first.contains_any[chest]>
        - if <player.cursor_on.inventory||invalid> == invalid:
          - define reason "You must look at a chest to use this."
          - inject command_error
        - run locally chest
        - if <[count]||invalid> == invalid:
          - narrate format:colorize_yellow "No items to repair."
        - else:
          - narrate format:colorize_green "Repaired <[count]> items."

      - else:
        - inject command_syntax

    # % ██ [ run as self ] ██
    - else:
      
    # % ██ [ check item ] ██
      - if !<player.item_in_hand.repairable>:
        - define reason "item cannot be repaired."
        - inject command_error
      
    # % ██ [ repair item ] ██
      - inventory adjust slot:<player.held_item_slot> durability:0
      - if <player.item_in_hand.has_display>:
        - narrate format:colorize_green "You repaired your <player.item_in_hand.material.display_name>"
      - else:
        - narrate format:colorize_green "You repaired your <player.item_in_hand.material.name>"
