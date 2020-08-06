Draft_NPC:
    type: assignment
    debug: false
    actions:
        on assignment:
            - inject NPC_Interaction path:Assignment
        on exit proximity:
            - inject NPC_Interaction path:Exit
        on click:
            - inject NPC_Interaction path:Click
        on damage:
            - inject NPC_Interaction path:Click
    Dialogue:
        Generic:
            - narrate format:npc "Greeting, opens Options List 1"
            - wait 1s
            - narrate format:npc "It's been one second."
            - run NPC_Interaction ID:<[ID]> def:o1
        QuickClick: QuickSelectOption
    Selections:
        QuickSelectOption:
            - narrate format:npc "This is the quick select script."
        # | ██  [ Selection 01 ] ██
        SelectionOne:
            - narrate format:npc "Selection One, does nothing"
        SelectionTwo:
            - narrate format:npc "Selection Two, opens Options List 1"
            - run NPC_Interaction ID:<[ID]> def:o1
        SelectionThree:
            - narrate format:npc "Selection Three, opens Options List 1"
            - run NPC_Interaction ID:<[ID]> def:o1
        SelectionFour:
            - narrate format:npc "Selection Four, opens Options List two"
            - run NPC_Interaction ID:<[ID]> def:o2
        # | ██  [ Selection 02 ] ██
        SelectionFive:
            - narrate format:npc "Selection Five, opens Options List 1, Dedupes Selection Four"
            - run NPC_Interaction ID:<[ID]> def:o1|SelectionFour
        SelectionSix:
            - narrate format:npc "Selection Six, opens Options List 1, Dedupes Selection Four"
            - run NPC_Interaction ID:<[ID]> def:o1|SelectionFour
    Options:
        o1:
            - "SelectionOne/Text for Option One"
            - "SelectionTwo/Text for Option Two"
            - "SelectionThree/Text for Option Three"
            - "SelectionFour/Text for Option Four"
        o2:
            - "SelectionFive/Text for Option Five"
            - "SelectionSix/Text for Option Six"
    
#old:
    #Npc_Handler:
    #    type: world
    #    debug: true
    #    events:
    #        # $ ██ [ This should be an Action   ] ██
    #        on player right clicks NPC:
    #        # @ ██ [ Dedup item knock ] ██
    #            - if <context.item.script.name||null> == NPCWatch:
    #                - stop
    #        # @ ██ [ Dedup Cooldown ] ██
    #            - if <player.has_flag[scriptdedup.<script>]>:
    #                - stop
    #            - flag player scriptdedup.<script> duration:1t
    #        # @ ██ [ Check for blank flag ] ██
    #            - if !<npc.has_flag[Behrry.Meeseeks.PlayerAction]>:
    #                - flag npc Behrry.Meeseeks.PlayerAction:greet
    #        # @ ██ [ Run Action based on Player ] ██
    #            - if <npc.owner> != <player>:
    #                - inject Meeseeks_PlayerAction
    #            - else:
    #                - narrate "Whaaat? You haven't told me what to do in this scenario yet!"
    #        on player right clicks block with NpcWatch:
    #            #@ Check if player is the owner of the selected
    #            - if <player.selected_npc.owner||null> != <player>:
    #                - stop
    #        # @ ██ [  Check if player has an NPC selected ] ██
    #            - if <player.selected_npc||null> == null:
    #                - narrate "You must select an NPC to use this tool."
    #                - stop
    #        # @ ██ [  Check if player is actually clicking NPC ] ██
    #            - wait 1t
    #            - if <player.has_flag[Behrry.Meeseeks.TargetFix]>:
    #                - stop
    #        # @ ██ [  Definitions ] ██
    #            - define NPC <player.selected_NPC>
    #            - Define Loc <player.location.cursor_on>
    #        # @ ██ [  If directing, Check for cooldown ] ██
    #            - if !<player.has_flag[Behrry.Meeseeks.MoveHereCooldown]>:
    #                - flag player Behrry.Meeseeks.MoveHereCooldown duration:15s
    #                - random:
    #                    - narrate format:npc_selected "Heading there now!"
    #                    - narrate format:npc_selected "Yee-haw, Let's go!"
    #                    - narrate format:npc_selected "I'll move there, then."
    #                    - narrate format:npc_selected "You wanted me over here?"
    #                    - narrate format:npc_selected "I'm moving there now."
    #            - flag <[Npc]> Behrry.Meeseeks.Pathfinding.PlayerInduced
    #            - ~walk <[Npc]> <[Loc]>
    #            - flag <[Npc]> Behrry.Meeseeks.Pathfinding.PlayerInduced:!
    #
    #        # $ ██ [ This should be an Action   ] ██
    #        on player damages NPC with NPCWatch:
    #            - determine passively cancelled
    #            - if <npc.owner||null> != <player>:
    #                - stop
    #            - execute as_op "npc select <npc>"
    #        on player right clicks NPC with NPCWatch:
    #        # @ ██ [  Cool-off the Block event check ] ██
    #            - flag player Behrry.Meeseeks.TargetFix duration:2t
    #        # @ ██ [  Check if the NPC was told to move ] ██
    #            - if <npc.has_flag[Behrry.Meeseeks.Pathfinding.PlayerInduced]>:
    #                - walk stop
    #        # @ ██ [ Dedup Cooldown ] ██
    #            - if <player.has_flag[scriptdedup.<script>]>:
    #                - stop
    #            - flag player scriptdedup.<script> duration:1t
    #
    #        # @ ██ [ Run Action based on Player ] ██
    #            - if <npc.owner> != <player>:
    #                - narrate "You're not my dad!"
    #                - stop
    #            - else:
    #                - run Meeseeks_GUI_Builder def:Menu|<npc.id>
    #
    #Meeseeks_Shop_Handler:
    #    type: world
    #    debug: true
    #    events:
    #        on player clicks in *_Meeseeks_Menu_*:
    #            - determine passively cancelled
    #            - if !<util.list_numbers_to[9].contains[<context.slot>]> || <context.item.script.name||null> == blank:
    #                - stop
    #            - define NpcID <context.item.nbt[NpcID]>
    #            - choose <context.item.nbt[Action]>:
    #                - case Open:
    #                    - inventory open d:<npc[<[NpcID]>].inventory>
    #                - case Manage:
    #                    - flag player Behrry.Meeseeks.ShopMode:Select
    #                    - if <server.online_players_flagged[Behrry.Meeseeks.ActiveInventory].size> > 0:
    #                        - foreach <server.online_players_flagged[Behrry.Meeseeks.ActiveInventory]> as:Player:
    #                            - if <[Player].flag[Behrry.Meeseeks.ActiveInventory]> == <[NpcID]>:
    #                                - narrate targets:<[Player]> "The owner is now managing the shop."
    #                                - inventory player:<[Player]> close
    #                    - flag player Behrry.Meeseeks.ActiveInventory:<[NpcID]>
    #                    - run Meeseeks_GUI_Builder def:ManageShop|<[NpcID]>
    #                - case TradeInventory:
    #                    - stop
    #        on player closes *Meeseeks_*:
    #            # % ██ [ Meeseeks_Menu_<npc.id> ] ██
    #            - if <context.inventory.notable_name.contains[Menu]>:
    #                - stop
    #
    #            # % ██ [ Manage Shop: Meeseeks_ManageShop_<npc.id> ] ██
    #            # % ██ | Raw Shop:    Meeseeks_Shop_<npc.id>       | ██
    #            - if <context.inventory.notable_name.contains[ManageShop]>:
    #                - define NpcID <context.inventory.notable_name.after_last[_]>
    #                - define NewContents <context.inventory.list_contents.first.to[36]>
    #                - define ShopInventory <inventory[Meeseeks_Shop_<[NpcID]>]>
    #                - inventory clear d:<[ShopInventory]>
    #                - inventory set d:<[ShopInventory]> o:<[NewContents]>
    #
    #
    #            # % ██ [ Trade Shop: Meeseeks_Trade_<[NpcID]> ] ██
    #            - if <context.inventory.notable_name.contains[Trade]>:
    #                - define NpcID <context.inventory.notable_name.after_last[_]>
    #                - define NewContents <context.inventory.list_contents.first.to[36]>
    #                - define ShopInventory <inventory[Meeseeks_Shop_<[NpcID]>]>
    #                - inventory clear d:<[ShopInventory]>
    #                - note <[NewContents]> as:<[ShopInventory]>
    #            - flag player Behrry.Meeseeks.ActiveInventory:!
    #
    #
    #        on player clicks in Meeseeks_Manageshop_*:
    #            - if <util.list_numbers_to[36].parse[add[45]].contains[<context.raw_slot>]>:
    #                - if <list[Increase|Decrease].contains[<player.flag[Behrry.Meeseeks.ShopMode]>]>:
    #                    - determine passively cancelled
    #            - if <util.list_numbers_to[36].contains[<context.raw_slot>]>:
    #                - choose <player.flag[Behrry.Meeseeks.ShopMode]>:
    #                    - case Select:
    #                        - choose <context.action>:
    #                            - case PLACE_ALL PLACE_ONE PLACE_SOME:
    #                                - define Price 1
    #                                - wait 1t
    #                                - define Quantity <context.cursor_item.quantity>
    #                                - if <[Quantity]> == 1:
    #                                    - define Lore "<&e>Item Price<&6>:|<&a><[Price]> Coins"
    #                                    - define Nbt "Price/<[Price]>"
    #                                - else:
    #                                    - define Lore "<&e>Item Price<&6>:|<&a><[Price]> Coins|<&2>(<&a><[Price].mul[<[Quantity]>]> Total<&2>)"
    #                                    - define Nbt "Price/<[Price]>|TotalPrice/<[Price].mul[<[Quantity]>]>"
    #                                - inventory adjust d:<context.inventory> slot:<context.slot> lore:<[Lore]>
    #                                - inventory adjust d:<context.inventory> slot:<context.slot> nbt:<[Nbt]>
    #                            - case PICKUP_ALL PICKUP_HALF PICKUP_ONE PICKUP_SOME:
    #                                - inventory adjust d:<context.inventory> slot:<context.slot> lore:
    #                                - inventory adjust d:<context.inventory> slot:<context.slot> remove_nbt:Price|TotalPrice
    #                            - case MOVE_TO_OTHER_INVENTORY:
    #                                - determine passively cancelled
    #                                - if !<player.inventory.can_fit[<context.item>]>:
    #                                    - stop
    #                                - inventory adjust d:<context.inventory> slot:<context.slot> lore:
    #                                - inventory adjust d:<context.inventory> slot:<context.slot> remove_nbt:Price|TotalPrice
    #                                - inventory set d:<context.inventory> slot:<context.slot> o:air
    #                            #^  - case CLONE_STACK:
    #                            #^  - case COLLECT_TO_CURSOR:
    #                            #^  - case DROP_ALL_CURSOR:
    #                            #^  - case DROP_ALL_SLOT:
    #                            #^  - case DROP_ONE_CURSOR:
    #                            #^  - case DROP_ONE_SLOT:
    #                            #^  - case HOTBAR_MOVE_AND_READD:
    #                            #^  - case HOTBAR_SWAP:
    #                            #^  - case NOTHING:
    #                            #^  - case SWAP_WITH_CURSOR:
    #                            - default:
    #                                - determine cancelled
    #                    - case Increase:
    #                        - determine passively cancelled
    #                        - choose <context.click>:
    #                            - case left:
    #                                - define Add 1
    #                            - case right:
    #                                - define Add 10
    #                            - case shift_left:
    #                                - define Add 100
    #                            - case shift_right:
    #                                - define Add 1000
    #                        - define Price <context.item.nbt[Price].add[<[Add]>]>
    #                        - define Quantity <context.item.quantity>
    #                        - if <[Quantity]> == 1:
    #                            - define Lore "<&e>Item Price<&6>:|<&a><[Price].format_number> Coins"
    #                            - define Nbt "Price/<[Price]>"
    #                        - else:
    #                            - define Lore "<&e>Item Price<&6>:|<&a><[Price].format_number> Coins|<&2>(<&a><[Price].mul[<[Quantity]>].format_number> Total<&2>)"
    #                            - define Nbt "Price/<[Price]>|TotalPrice/<[Price].mul[<[Quantity]>]>"
    #                        - inventory adjust d:<context.inventory> slot:<context.slot> lore:<[Lore]>
    #                        - inventory adjust d:<context.inventory> slot:<context.slot> nbt:<[Nbt]>
    #                    - case Decrease:
    #                        - determine passively cancelled
    #                        - choose <context.click>:
    #                            - case left:
    #                                - define Add 1
    #                            - case right:
    #                                - define Add 10
    #                            - case shift_left:
    #                                - define Add 100
    #                            - case shift_right:
    #                                - define Add 1000
    #                        - define Price <context.item.nbt[Price].sub[<[Add]>]>
    #                        - if <[Price]> <= 0:
    #                            - define Price 1
    #                        - define Quantity <context.item.quantity>
    #                        - if <[Quantity]> == 1:
    #                            - define Lore "<&e>Item Price<&6>:|<&a><[Price].format_number> Coins"
    #                            - define Nbt "Price/<[Price]>"
    #                        - else:
    #                            - define Lore "<&e>Item Price<&6>:|<&a><[Price].format_number> Coins|<&2>(<&a><[Price].mul[<[Quantity]>].format_number> Total<&2>)"
    #                            - define Nbt "Price/<[Price]>|TotalPrice/<[Price].mul[<[Quantity]>]>"
    #                        - inventory adjust d:<context.inventory> slot:<context.slot> lore:<[Lore]>
    #                        - inventory adjust d:<context.inventory> slot:<context.slot> nbt:<[Nbt]>
    #            - else if <util.list_numbers_to[9].parse[add[36]].contains[<context.raw_slot>]>:
    #                - if <context.item.has_nbt[Action]>:
    #                    - determine passively cancelled
    #                    - flag player Behrry.Meeseeks.ShopMode:<context.item.nbt[Action]>
    #                    - wait 1t
    #                    - choose <context.item.nbt[Action]>:
    #                        - case Increase:
    #                            - inventory adjust d:<context.inventory> slot:40 material:eye_of_ender
    #                            - inventory adjust d:<context.inventory> slot:40 "display_name:<&6>[<&e>Increase Price<&6>]"
    #                            - inventory adjust d:<context.inventory> slot:40 "Lore:<&e>Left Click to add<&6>:<&a> 1 coin|<&e>Right Click to add<&6>:<&a> 10 coins|<&e>Shift-Left Click to add<&6>:<&a> 100 coins|<&e>Shift-Right Click to add<&6>:<&a> 1,000 coins"
    #
    #                            - inventory adjust d:<context.inventory> slot:41 material:ender_pearl
    #                            - inventory adjust d:<context.inventory> slot:41 "display_name:<&3>[<&b>Decrease Price<&3>]"
    #                            - inventory adjust d:<context.inventory> slot:41 "Lore:<&e>Click to toggle Price Decrease"
    #
    #                            - inventory adjust d:<context.inventory> slot:42 material:ender_pearl
    #                            - inventory adjust d:<context.inventory> slot:42 "display_name:<&3>[<&b>Select Items<&3>]"
    #                            - inventory adjust d:<context.inventory> slot:42 "Lore:<&e>Click to Select Price Tools"
    #
    #
    #                        - case Decrease:
    #                            - inventory adjust d:<context.inventory> slot:40 material:ender_pearl
    #                            - inventory adjust d:<context.inventory> slot:40 "display_name:<&3>[<&b>Increase Price<&3>]"
    #                            - inventory adjust d:<context.inventory> slot:40 "Lore:<&e>Click to toggle Price Increase"
    #    
    #                            - inventory adjust d:<context.inventory> slot:41 material:eye_of_ender
    #                            - inventory adjust d:<context.inventory> slot:41 "display_name:<&6>[<&e>Decrease Price<&6>]"
    #                            - inventory adjust d:<context.inventory> slot:41 "Lore:<&e>Left Click to remove<&6>:<&a> 1 coin|<&e>Right Click to remove<&6>:<&a> 10 coins|<&e>Shift-Left Click to remove<&6>:<&a> 100 coins|<&e>Shift-Right Click to remove<&6>:<&a> 1,000 coins"
    #
    #                            - inventory adjust d:<context.inventory> slot:42 material:ender_pearl
    #                            - inventory adjust d:<context.inventory> slot:42 "display_name:<&3>[<&b>Select Items<&3>]"
    #                            - inventory adjust d:<context.inventory> slot:42 "Lore:<&e>Click to Select Price Tools"
    #
    #
    #                        - case Select:
    #                            - inventory adjust d:<context.inventory> slot:40 material:ender_pearl
    #                            - inventory adjust d:<context.inventory> slot:40 "display_name:<&3>[<&b>Increase Price<&3>]"
    #                            - inventory adjust d:<context.inventory> slot:40 "Lore:<&e>Click to toggle Price Increase"
    #
    #                            - inventory adjust d:<context.inventory> slot:41 material:ender_pearl
    #                            - inventory adjust d:<context.inventory> slot:41 "display_name:<&3>[<&b>Decrease Price<&3>]"
    #                            - inventory adjust d:<context.inventory> slot:41 "Lore:<&e>Click to toggle Price Decrease"
    #
    #                            - inventory adjust d:<context.inventory> slot:42 material:eye_of_ender
    #                            - inventory adjust d:<context.inventory> slot:42 "display_name:<&6>[<&e>Select Items<&6>]"
    #                            - inventory adjust d:<context.inventory> slot:42 "Lore:<&e>Adjusting Item Stock"
    #                            
    #        on player drags in Meeseeks_ManageShop_*:
    #            - if <player.flag[Behrry.Meeseeks.ShopMode]> != Select:
    #                - determine passively cancelled
    #            - if <context.slots.size> == 1:
    #                - define Price 1
    #                - define Lore "<&e>Item Price<&6>:|<&a><[Price]> Coins"
    #                - define Nbt "Price/<[Price]>
    #                - wait 1t
    #                - define Quantity <context.item.quantity>
    #
    #                - if <[Quantity]> == 1:
    #                    - define Lore "<&e>Item Price<&6>:|<&a><[Price]> Coins"
    #                    - define Nbt "Price/<[Price]>"
    #                - else:
    #                    - define Lore "<&e>Item Price<&6>:|<&a><[Price]> Coins|<&2>(<&a><[Price].mul[<[Quantity]>]> Total<&2>)"
    #                    - define Nbt "Price/<[Price]>|TotalPrice/<[Price].mul[<[Quantity]>]>"
    #
    #                - inventory adjust d:<context.inventory> slot:<context.slots.first> lore:<[Lore]>
    #                - inventory adjust d:<context.inventory> slot:<context.slots.first> nbt:<[Nbt]>
    #            - else:
    #                - determine cancelled
    #                #^ - if <context.inventory.slot[<context.slots>].filter[material.name.is[==].to[air].not].size> > 0:
    #                #^     - determine cancelled
    #                #^ - define Price 1
    #                #^ - wait 1t
    #                #^ - define Quantity <context.item.quantity>
    #                #^ - if <context.slots.size> == 1:
    #                #^     - define Lore "<&e>Item Price<&6>:|<&a><[Price]> Coins"
    #                #^     - define Nbt "Price/<[Price]>
    #                #^     - inventory adjust d:<context.inventory> slot:<context.slots.first> lore:<[Lore]>
    #                #^     - inventory adjust d:<context.inventory> slot:<context.slots.first> nbt:<[Nbt]>
    #                #^ - else:
    #                #^     - determine cancelled
    #                #^     #^- foreach <context.slots> as:Slot:
    #                #^     #^- define Lore "<&e>Item Price<&6>:|<&a><[Price]> Coins|<&2>(<&a><[Price].mul[<[Quantity]>]> Total<&2>)"
    #                #^     #^- define Nbt "Price/<[Price]>|TotalPrice/<[Price].mul[<[Quantity]>]>"
    #                #^     #^- inventory adjust d:<context.inventory> slot:<[Slot]> lore:<[Lore]>
    #                #^     #^- inventory adjust d:<context.inventory> slot:<[Slot]> nbt:<[Nbt]>
    #
    #        on player clicks in Meeseeks_Trade*:
    #            - determine passively cancelled
    #            - if !<util.list_numbers_to[36].contains[<context.raw_slot>]>:
    #                - stop
    #            - if <context.item.material.name> == air || <context.action> == nothing:
    #                - stop
    #            - choose <context.click>:
    #                - case "Left":
    #                    - define Quantity 1
    #                - case "shift_left":
    #                    - define Quantity 10
    #                - case "right":
    #                    - define Quantity 64
    #                - default:
    #                    - stop
    #            - if <[Quantity]> > <context.item.quantity>:
    #                - define Quantity <context.item.quantity>
    #            - define Item <context.item.with[quantity=<[Quantity]>;remove_nbt=<list[Price|TotalPrice]>;lore=li@]>
    #            - if !<player.inventory.can_fit[<[Item]>]>:
    #                - narrate format:Colorize_Red "Not enough room for item!"
    #                - stop
    #            - give <[Item]>
    #            - wait 1t
    #            - if <[Quantity]> == <context.item.quantity>:
    #                - inventory set d:<context.inventory> slot:<context.slot> o:air
    #            - else:
    #                - inventory set d:<context.inventory> slot:<context.slot> o:<context.item.with[quantity=<Context.item.quantity.sub[<[Quantity]>]>]>
    #Meeseeks_PlayerAction:
    #    type: task
    #    debug: true
    #    script:
    #        - choose <npc.flag[Behrry.Meeseeks.PlayerAction]>:
    #            - case "Greet":
    #                - if <player.has_flag[Behrry.Meeseeks.GreetCooldown]>:
    #                    - stop
    #                - flag player Behrry.Meeseeks.GreetCooldown duration:5s
    #                - narrate format:NPC "Howdy There! I haven't been told what to do, so nobody controls what I say!"
    #            - case "Trade":
    #                - if <npc.owner.has_flag[Behrry.Meeseeks.ActiveInventory]>:
    #                    - if <npc.owner.flag[Behrry.Meeseeks.ActiveInventory]> == <npc.id>:
    #                        - narrate "The owner is currently managing the shop."
    #                        - stop
    #                - flag player Behrry.Meeseeks.ActiveInventory:<npc.id> duration:10m
    #                - flag player Behrry.Meeseeks.TradeMode:Purchase
    #                - flag player Behrry.Meeseeks.TradeQuantity:1
    #                - run Meeseeks_GUI_Builder def:Trade|<npc.id>
    #
    #
    ## - ██ [ To-do: Text Wrapping Procedure for DWrapped - something like <proc[TextWrapper].context[<[Def]>|#]> ] ██
    ## ^ ██ - define DWrapped <[Description].replace[regex:((.{1,28})(\h+\R?|\R)|.{28})].with[$1|<&3>].as_list>     ██
    #Meeseeks_GUI_Builder:
    #    type: task
    #    debug: true
    #    definitions: Gui|NpcID|Mode
    #    Menu:
    #        Open Inventory: "<&3>Check your |<&3>Meeseek's bag"
    #        Manage Shop: "<&3>Adjust pricing and stock|<&3>of your Meeseeks Shop"
    #        #Trader: "<&3>Opens the trading screen|<&3>that Player's see."
    #        #Equip: "<&3>Give your Meeseek|<&3>with Armor and Weapons"
    #    ManageShop:
    #        Increase Price: "<&e>Click to toggle Price Increase"
    #        Select Items: "<&e>Adjusting Item Stock"
    #        Decrease Price: "<&e>Click to toggle Price Decrease"
    #    Trade:
    #        Mode: "<&e>Left Click to buy<&6>: <&a>1|<&e>Shift-Left Click to buy<&6>: <&a>10|<&e>Right Click to buy<&6>: <&a>All"
    #        #Increase: "<&6>[<&e>Click to Increase<&6>]"
    #        #Decrease: "<&6>[<&e>Click to Decrease<&6>]"
    #    MenuBuilder:
    #        - repeat <[Size]>:
    #                - if <util.list_numbers_to[9].remove[<util.list_numbers_to[<[SoftMenu].size>].parse[add[<[Math]>]]>].contains[<[Value]>]>:
    #                    - define HardMenu:->:Blank
    #                - else:
    #                    - define MenuItem <[SoftMenu].get[<[Value].sub[<[Math]>]>]>
    #                    - define Description <script.data_key[<[Gui]>.<[SoftMenu].get[<[Value].sub[<[Math]>]>]>]>
    #                    - if <[Mode]||null> == <[MenuItem].split.first>:
    #                        - define Material eye_of_ender
    #                    - else:
    #                        - define Material ender_pearl
    #                    - define HardMenu:->:<item[nbt_item].with[material=<[Material]>;nbt=<list[Action/<[MenuItem].split.first>|NpcID/<[NpcID]>]>;display_name=<&b><[MenuItem]>;lore=<[Description].parsed.split[|]>]>
    #    script:
    #        - define SoftMenu <script.list_keys[<[Gui]>]>
    #        - define Size <[SoftMenu].size.div[9].round_up.mul[9]>
    #        - choose <[Gui]>:
    #            - case Menu:
    #                - define InventoryName <player.uuid>_Meeseeks_Menu_<[NpcID]>
    #                - define Math 1
    #                - inject Locally MenuBuilder Instantly
    #                - define Inventory <inventory[generic[size=<[Size]>;contents=<[HardMenu]>;Title=<&2>Meeseeks<&sp>Menu]]>
    #            - case ManageShop:
    #                - define InventoryName Meeseeks_ManageShop_<[NpcID]>
    #                - define Math 3
    #                - inject Locally MenuBuilder Instantly
    #            - case Trade:
    #                - define InventoryName Meeseeks_Trade_<[NpcID]>
    #                - define Math 4
    #                - inject Locally MenuBuilder Instantly
    #                - define Inventory <inventory[generic[size=<[Size].add[36]>;Title=<&2>Meeseeks<&sp>Shop]]>
    #                - inventory set d:<[Inventory]> o:<inventory[Meeseeks_Shop_<[NpcID]>].list_contents> slot:1
    #                - inventory set d:<[Inventory]> o:<[HardMenu]> slot:37
    #                - note <[Inventory]> as:<[InventoryName]>
    #        - inventory open d:<inventory[<[InventoryName]>]>
    #
    #
    #Meeseeks_Command:
    #    type: command
    #    name: meeseeks
    #    debug: true
    #    usage: /meeseeks <&lt>Command<&gt>
    #    description: Interacts with your meeseeks.
    #    permission: test
    #    Args:
    #        - Select
    #        - Skin
    #        - Rename
    #        #-Set the Actions:
    #        - SetAction
    #        #-Open the Menu:
    #        - Menu
    #        #-Edit the Shop:
    #        - ManageShop
    #        #-Trade the Shop:  // Note: Owners only VIEW the shop - you can't trade with a meeseek you own.
    #        - TradeInventory
    #    SubArgs:
    #        SetAction:
    #            - Greet
    #            - Trade
    #    tab complete:
    #        - define Arg1 <script.data_key[Args]>
    #        - define Arg2 <script.data_key[SubArgs.SetAction]>
    #        - define SubArgs <script.list_keys[SubArgs].as_list>
    #
    #        - if <context.args.size> == 0:
    #            - Determine <[Arg1]>
    #        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
    #            - determine <[Arg1].filter[starts_with[<context.args.first>]]>
    #
    #        - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
    #            - if <context.args.first.contains_any[<[SubArgs]>]>:
    #                - determine <script.data_key[SubArgs.<context.args.first>]>
    #
    #        - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
    #            - if <context.args.first.contains_any[<[SubArgs]>]>:
    #                - determine <script.data_key[SubArgs.<context.args.first>].filter[starts_with[<context.args.get[2]>]]>
    #    script:
    #        - if <context.args.size> == 0:
    #            - stop
    #        - define Arg1 <context.args.first>
    #        - choose <[Arg1]>:
    #            - case Select:
    #                - if <player.target||null> == null:
    #                    - narrate "Look at the Meeseeks."
    #                    - stop
    #                - if <player.selected_npc> == <player.target>:
    #                    - narrate "You already have this Meeseeks selected."
    #                    - stop
    #                - else:
    #                    - execute as_op "npc select"
    #            - case skin:
    #                - execute as_op "npc skin <context.args.remove[1|2].separated_by[<&sp>]>"
    #            - case Rename:
    #                - define Nickname <context.args.get[3]>
    #                # @ ██ [  Check if name is null ] ██
    #                - if <[Nickname]> == null:
    #                    - narrate format:Colorize_Red "You must specify a name."
    #                    - stop
    #                # @ ██ [  same nickname ? ] ██
    #                #^- if <[Nickname].parse_color> == <[User].flag[behrry.essentials.display_name]||>:
    #                #^    - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
    #                #^    - stop
    #                # @ ██ [  alphanumerical ? ] ██
    #                #^- if !<[Nickname].matches[[a-zA-Z0-9-_\&]+]>:
    #                #^    - narrate "<proc[Colorize].context[Nicknames should be alphanumerical.|red]>"
    #                #^    - stop
    #                # @ ██ [  too long ? ] ██
    #                #^- if <[Nickname].parse_color.strip_color.length> > 16:
    #                #^    - narrate "<proc[Colorize].context[Nicknames should be less than 16 charaters.|red]>"
    #                #^    - stop
    #                # @ ██ [  blacklisted ? ] ██
    #                #^- if <[Nickname].contains_any[&k]>:
    #                #^    - narrate "<proc[Colorize].context[Obfuscated names are blacklisted.|red]>"
    #                #^    - stop
    #                - narrate "Not Implemented yet."
    #            - case SetAction:
    #                # @ ██ [ Check Args ] ██
    #                - define Arg2 <context.args.get[2].to_titlecase||null>
    #                - if <[Arg2]> == null || <context.args.size> > 2 || !<script.data_key[SubArgs.SetAction].contains[<[Arg2]>]>:
    #                    - narrate "<&e>Available SetAction Commands<&6>: <&a><script.data_key[SubArgs.SetAction].separated_by[<&6>, <&a>]>"
    #                    - stop
    #
    #                # @ ██ [ Check if NPC selected ] ██
    #                - if <player.selected_npc||null> == null:
    #                    - narrate format:Colorize_Red "You must first select a Meeseeks."
    #                    - stop
    #
    #                # @ ██ [ Determine Sub-Command ] ██
    #                - if <npc.flag[Behrry.Meeseeks.PlayerAction]> == <[Arg2]>:
    #                    - narrate "<&e><npc.name><proc[Colorize].context['s player action is already set as:|green]> <&e><[Arg2]>"
    #                - else:
    #                    - flag <npc> Behrry.Meeseeks.PlayerAction:<[Arg2]>
    #                    - narrate "<&e><npc.name><proc[Colorize].context['s player action set to:|green]> <&e><[Arg2]>"
    #
    #            - case Menu:
    #                - run Meeseeks_GUI_Builder def:Menu|<npc.id>
    #            - case RawShop:
    #                # $ ██ [ Developmental View of Raw Shop ] ██
    #                # @ ██ [ Check if Developer ] ██
    #                - if !<player.has_flag[test]>:
    #                    - stop
    #                # @ ██ [ Check if NPC selected ] ██
    #                - if <player.selected_npc||null> == null:
    #                    - narrate format:Colorize_Red "You must first select a Meeseeks."
    #                    - stop
    #                # @ ██ [ Check if the inventory exists ] ██
    #                - if <inventory[Meeseeks_Shop_<npc.id>]||null> == null:
    #                    - note <inventory[generic[size=36]> as:Meeseeks_Shop_<npc.id>
    #
    #                - inventory open d:<inventory[Meeseeks_Shop_<npc.id>]>
    #            - case ManageShop:
    #                # @ ██ [ Check if NPC selected ] ██
    #                - if <player.selected_npc||null> == null:
    #                    - narrate format:Colorize_Red "You must first select a Meeseeks."
    #                    - stop
    #
    #                # @ ██ [ Check if the inventory exists ] ██
    #                - if <inventory[Meeseeks_Shop_<npc.id>]||null> == null:
    #                    - note <inventory[generic[size=36]> as:Meeseeks_Shop_<npc.id>
    #
    #                # @ ██ [ Open the Shop Manager ] ██
    #                - note <inventory[generic[size=36;Title=<&2>Meeseek<&sp>Shop]]> as:Meeseeks_ManageShop_<npc.id>
    #                - run Meeseeks_GUI_Builder def:ManageShop|<npc.id>
    #
    #            - default:
    #                - narrate "<&e>Available Commands<&6>: <&a><script.data_key[Args].separated_by[<&6>, <&a>]>"
    #
    #debug_events:
    #    type: world
    #    debug: false
    #    events:
    #        on player clicks in inventory:
    #        # $ ██ [ -- Debug ----------- -- $# ] ██
    #            - if <list[Behr_Riley|Behrry].contains[<player.name>]>:
    #                - inject InvDebugPrint Instantly
    #        # $ ██ [ -- ----------------- -- $# ] ██
    #        # ^    - if <context.inventory.id_holder.type> != NPC:
    #        # ^        - stop
    #        # ^    - if <context.inventory.id_holder.owner> != <player>:
    #        # ^        - stop
    #        on player drags in inventory:
    #        # $ ██ [ -- Debug ----------- -- $# ] ██
    #            - if <list[Behr_Riley|Behrry].contains[<player.name>]>:
    #                - inject InvDebugPrint2
    #        # $ ██ [ -- ----------------- -- $# ] ██
    #        # ^    - if <context.inventory.id_holder.type> != NPC:
    #        # ^        - stop
    #        # ^    - if <context.inventory.id_holder.owner> != <player>:
    #        # ^        - stop
    #
#
InvDebugPrint:
    type: task
    debug: false
    script:
        - announce to_console format:Colorize_Red "Event: On Player CLICKS In Inventory"
        - announce to_console "<proc[Colorize].context["<&lt>context.item<&gt>|Yellow]>       <&4><&lt>[<&c>i1<&4>]<&gt> <&a>~ <&a><context.item||INVALID> <&c>/<&4>[<&c>pickup<&4>] <&3>returns the ItemTag the player has clicked on."
        - announce to_console "<proc[Colorize].context["<&lt>context.cursor_item<&gt>|Yellow]><&4><&lt>[<&c>i2<&4>]<&gt> <&a>~ <&a><context.cursor_item||INVALID> <&c>/<&4>[<&c>place <&4>] <&3>returns the item the Player is clicking with."
        - announce to_console "<proc[Colorize].context["<&lt>context.inventory<&gt>|Yellow]>         <&a>~ <&a><context.inventory||INVALID> <&3>returns the InventoryTag (the 'top' inventory, regardless of which slot was clicked)."
        - announce to_console "<proc[Colorize].context["<&lt>context.clicked_inventory<&gt>|Yellow]> <&a>~ <&a><context.clicked_inventory||INVALID> <&3>returns the InventoryTag that was clicked in."
        - announce to_console "<proc[Colorize].context["<&lt>context.click<&gt>|Yellow]>             <&a>~ <&a><context.click||INVALID> <&3>returns an ElementTag with the name of the click type. Click type list: http://bit.ly/2IjY198"
        - announce to_console "<proc[Colorize].context["<&lt>context.slot_type<&gt>|Yellow]>         <&a>~ <&a><context.slot_type||INVALID> <&3>returns an ElementTag with the name of the slot type that was clicked."
        - announce to_console "<proc[Colorize].context["<&lt>context.slot<&gt>|Yellow]>              <&a>~ <&a><context.slot||INVALID> <&3>returns an ElementTag with the number of the slot that was clicked."
        - announce to_console "<proc[Colorize].context["<&lt>context.raw_slot<&gt>|Yellow]>          <&a>~ <&a><context.raw_slot||INVALID> <&3>returns an ElementTag with the raw number of the slot that was clicked."
        - announce to_console "<proc[Colorize].context["<&lt>context.is_shift_click<&gt>|Yellow]>    <&a>~ <&a><context.is_shift_click||INVALID> <&3>returns true if 'shift' was used while clicking."
        - announce to_console "<proc[Colorize].context["<&lt>context.action<&gt>|Yellow]>            <&a>~ <&a><context.action||INVALID> <&3>returns the inventory_action. See !language Inventory Actions."
        - announce to_console "<proc[Colorize].context["<&lt>context.hotbar_button<&gt>|Yellow]>     <&a>~ <&a><context.hotbar_button||INVALID> <&3>returns an ElementTag of the button pressed as a number, or 0 if no number button was pressed."
        - announce to_console "<&c>-------------------"
InvDebugPrint2:
    type: task
    debug: false
    script:
        - announce to_console format:Colorize_Red "Event: On Player DRAGS In Inventory"
        - announce to_console "<proc[Colorize].context[<&gt>context.item<&lt>|yellow]> <&a>~<context.item||INVALID> <&3>returns the ItemTag the player has dragged.
        - announce to_console "<proc[Colorize].context[<&gt>context.inventory<&lt>|yellow]> <&a>~<context.inventory||INVALID> <&3>returns the InventoryTag (the 'top' inventory, regardless of which slot was clicked).
        - announce to_console "<proc[Colorize].context[<&gt>context.clicked_inventory<&lt>|yellow]> <&a>~<context.clicked_inventory||INVALID> <&3>returns the InventoryTag that was clicked in.
        - announce to_console "<proc[Colorize].context[<&gt>context.slots<&lt>|yellow]> <&a>~<context.slots||INVALID> <&3>returns a ListTag of the slot numbers dragged through.
        - announce to_console "<proc[Colorize].context[<&gt>context.raw_slots<&lt>|yellow]> <&a>~<context.raw_slots||INVALID> <&3>returns a ListTag of the raw slot numbers dragged through.
