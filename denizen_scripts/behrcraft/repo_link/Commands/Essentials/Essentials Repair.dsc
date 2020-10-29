Repair_Command:
  type: command
  name: repair
  debug: false
  description: Repairs an item you're holding.
  usage: /repair
  adminusage: /repair
  permission: behr.essentials.repair
  script:
  # % ██ [ Check for args ] ██
    - if <context.args.size> > 1:
      # % ██ [ Run as Moderator ] ██
      - if !<player.in_group[Moderator]>:
        - inject Admin_Permission_Denied
      - if <context.args.size> > 2:
        - inject Command_Syntax

    # % ██ [ Run as Self ] ██
    - else:
      
    # % ██ [ Check Item ] ██
      - if !<player.item_in_hand.repairable>:
        - narrate "Item cannot be repaired."
        - stop
      
    # % ██ [ Repair Item ] ██
      - inventory adjust slot:<player.held_item_slot> durability:0
