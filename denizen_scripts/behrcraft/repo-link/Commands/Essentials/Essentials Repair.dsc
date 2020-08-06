Repair_Command:
    type: command
    name: Repair
    debug: false
    description: Repairs an item you're holding.
    # $ admindescription: Repairs an item you or a specified player is holding.
    usage: /repair
    adminusage: /repair
    permission: Behr.Essentials.Repair
    script:
    # % ██ [ Check for args ] ██
        - if <context.args.size> > 1:
            # % ██ [ Run as Moderator ] ██
            - if !<player.in_group[Moderator]>:
                - inject Admin_Permission_Denied
            - if <context.args.size> > 2:
                - inject Command_Syntax
            
        # $ ██ [ Check if All ] ██
        #^  - if <context.args.first> == all:
        #^     - foreach inventory slots as:Item:
        #^         - if <[Item].max_durability||null> == null:
        #^             - foreach next
        #^         - define slot itemslot
        #^         - take item
        #^         - give item .with[durability=0]
        
        # % ██ [ Run as Self ] ██
        - else:
            # $ ██ [ To-Do: Determine Different based on Sponsor Levels ] ██
            ##@ Check if player has flags
            #- if !<player.has_flag[Behr.Essentials.Repair.Limit]>:
            #    - flag player Behr.Essentials.RepairLimit:3
            #- if !<player.has_Flag[Behr.Essentials.Repair.Cooldown]>:
            #    - flag player Behr.Essentials.RepairLimit:0

            ##@ Check Flags
            #- if <player.flag[Behr.Essentials.Repair.Cooldown]||0> > <player.flag[Behr.Essentials.Repair.Limit]>:
            #    - narrate "Repair Limit Cooldown"
            #    - stop
            
        # % ██ [ Check Item ] ██
            - if <player.item_in_hand.max_durability||null> == null:
                - narrate "Item cannot be repaired."
                - stop
            
        # % ██ [ Repair Item ] ██
            - define Item <player.item_in_hand>
            - take iteminhand
            - give <[Item].with[durability=0]>
