MobInv:
    type: command
    name: mobinv
    debug: false
    description: Opens a villager, or a mob's inventory.
    usage: /mobinv
    permission: behrry.essentials.mobinv
    script:
    # % ██ [ Check args ] ██
        - if <context.args.first||null> != null:
            - inject Command_Syntax Instantly

    # % ██ [ Define mob ] ██
        - define Mob <player.target||null>

    # % ██ [ Check mob ] ██
        - if <[Mob]> == null || <[Mob].is_player>:
            - narrate format:Colorize_red "Target must be a valid entity."
            - stop
        
    # % ██ [ Check if is sheep ] ██
        - if <[Mob].entity_type> == sheep:
            - if <[Mob].is_sheared>:
                - define Wool <item[air]>
            - else:
                - define Wool <item[blank].with[material=<player.target.color>_wool]>
            - define Inventory <inventory[generic[size=9;contents=<item[Blank]>|<item[Blank]>|<item[Blank]>|<item[Blank]>|<[Wool]>|<item[Blank]>|<item[Blank]>|<item[Blank]>|<item[Blank]>]]>
            - inventory open d:<[Inventory]>
            - stop

    # % ██ [ Check if the inventory is valid ] ██
        - if <[Mob].inventory||null> == null:
            - narrate format:Colorize_red "Target must have a valid inventory."
            - stop
        
    # % ██ [ Check if is villager ] ██
        - if <[Mob].entity_type> == Villager:
            - define Inventory <player.uuid>VillagerInventory_<[Mob].uuid>
            - note as:<[Inventory]> <inventory[generic[size=9;contents=<[Mob].inventory.list_contents>]]>
            - inventory open d:<[Inventory]>

MobInv_Handler:
    type: world
    debug: false
    events:
        on player right clicks villager|Sheep:
            - if <player.is_sneaking>:
                - run MobInv path:script
        #on player clicks in *SheepInventory*:
        #    - determine passively cancelled
        on player clicks in *VillagerInventory*:
            - define Whitelist <list[Wheat_Seeds|Beetroot_Seeds|Bread|Carrot|Potato|Beetroot|Wheat]>
            - if !<[Whitelist].contains[<context.item.material.name||null>]>:
                - determine passively cancelled
        on player closes *SheepInventory*|*VillagerInventory*:
            - define Inventory <context.inventory>
            - inventory clear d:<[Inventory]>
            - inventory set d:<[Inventory]> o:<[Inventory].list_contents>
            - note as:<[Inventory]> remove
