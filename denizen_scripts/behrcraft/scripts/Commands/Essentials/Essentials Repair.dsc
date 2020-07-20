Repair_Command:
    type: command
    name: Repair
    debug: false
    description: Repairs an item you're holding.
    # $ admindescription: Repairs an item you or a specified player is holding.
    usage: /repair
    adminusage: /repair
    permission: Behrry.Essentials.Repair
    script:
    # @ ██ [ Check for args ] ██
        - if <context.args.size> > 1:
            # @ ██ [ Run as Moderator ] ██
            - if !<player.in_group[Moderator]>:
                - inject Admin_Permission_Denied Instantly
            - if <context.args.size> > 2:
                - inject Command_Syntax Instantly
            
        # $ ██ [ Check if All ] ██
        #^  - if <context.args.get[1]> == all:
        #^     - foreach inventory slots as:Item:
        #^         - if <[Item].max_durability||null> == null:
        #^             - foreach next
        #^         - define slot itemslot
        #^         - take item
        #^         - give item .with[durability=0]
        
        # @ ██ [ Run as Self ] ██
        - else:
            # $ ██ [ To-Do: Determine Different based on Sponsor Levels ] ██
            ##@ Check if player has flags
            #- if !<player.has_flag[Behrry.Essentials.Repair.Limit]>:
            #    - flag player Behrry.Essentials.RepairLimit:3
            #- if !<player.has_Flag[Behrry.Essentials.Repair.Cooldown]>:
            #    - flag player Behrry.Essentials.RepairLimit:0

            ##@ Check Flags
            #- if <player.flag[Behrry.Essentials.Repair.Cooldown]||0> > <player.flag[Behrry.Essentials.Repair.Limit]>:
            #    - narrate "Repair Limit Cooldown"
            #    - stop
            
            #@ Check Item
            - if <player.item_in_hand.max_durability||null> == null:
                - narrate "Item cannot be repaired."
                - stop
            
            #@ Repair Item
            - define Item <player.item_in_hand>
            - take iteminhand
            - give <[Item].with[durability=0]>
            