BawbShop:
    type: task
    debug: false
    definitions: Menu
    script:
        - if !<player.has_flag[Behrry.Meeseeks.MeeseeksCount]>:
            - flag player Behrry.Meeseeks.MeeseeksCount:0

        - define Title "<&2>B<&6>a<&2>wb<&6>'<&2>s Meeseeks Shop"
        - define Inventory <inventory[generic[holder=hopper;title=<[Title]>]]>
        - define Action <[Menu].unescaped.as_list.map_get[Action]>

        - choose <[Action]>:
            - case MainMenu:
                #- define SoftMenu:->:<item[Action_Item].with[material=Diamond_Pickaxe;enchantments=silk_touch,1;flags=hide_all;display_name=<&3>M<&b>eeseek<&sp><&3>T<&b>ools;nbt=<list[Menu/BawbShop|Action/ToolMenu]>]>
                - define SoftMenu:|:blank|blank
                #- define SoftMenu:|:blank|<item[Action_Item].with[display_name=<&3>B<&b>uy<&sp><&3>M<&b>eeseeks;material=player_head;nbt=<list[Menu/BawbShop|Action/BuyPrompt]>;skull_skin=<server.flag[Behrry.Essentials.SavedHeads].map_get[MeeseeksBox]>]>
                - define SoftMenu:->:<item[Action_Item].with[display_name=<&3>B<&b>uy<&sp><&3>M<&b>eeseeks;material=player_head;nbt=<list[Menu/BawbShop|Action/BuyPrompt]>;skull_skin=786a4323-40b0-45eb-937c-9a90e6313d9b|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNWJiNDMzOTFhOWRiZmY5ZWFkYWUwN2I2ODYyNTk1YzkxZDA0YzU5MzhlMjNjMjg1YWM2MGM0Yjg3NjliMjQifX19]>
                #- define SoftMenu:|:blank|<item[Action_Item].with[material=globe_banner_pattern;enchantments=silk_touch,1;flags=hide_all;display_name=<&3>M<&b>eeseeks<&sp><&3>I<&b>nfo;nbt=<list[Menu/BawbShop|Action/Info]>]>
                - define SoftMenu:|:blank|blank
                - inventory set d:<[Inventory]> o:<[SoftMenu]>
                - inventory open d:<[Inventory]>

            #^- case ToolMenu:
            #^    - define Back <item[Action_Item].with[material=Red_stained_glass_pane;display_name=<&c>[<&7>Main<&sp>Menu<&c>];nbt=<list[Menu/BawbShop|Action/MainMenu]>;enchantments=silk_touch,1;flags=hide_all]>
            #^    - define SoftMenu:|:<item[Action_Item].with[material=Clock;display_name=Navigator]>|<item[Action_Item].with[material=player_head;display_name=<&3>M<&b>eeseeks<&sp><&3>T<&b>ransportation<&sp><&3>B<&b>ox;skull_skin=<server.flag[Behrry.Essentials.SavedHeads].map_get[Package]>]>|blank|blank|<[Back]>
            #^    - inventory set d:<[Inventory]> o:<[SoftMenu]>
            #^    - inventory open d:<[Inventory]>

            - case BuyPrompt:
                # % ██ [ Messeeks Price: ((M+1)*100,000)+((M)*50,000)      ] ██
                # % ██ [ Where (M) is the number of Meeseeks a player owns ] ██
                - define MeeseeksPrice <player.flag[Behrry.Meeseeks.MeeseeksCount].add[1].mul[100000].add[<player.flag[Behrry.Meeseeks.MeeseeksCount].mul[50000]>]>
                - define Accept <item[Action_Item].with[material=Lime_stained_glass_pane;display_name=<&3>B<&b>uy<&sp><&3>M<&b>eeseeks;nbt=<list[Menu/BawbShop|Action/BuyMeeseeks]>;lore=<&2>P<&a>urchase<&sp><&2>P<&a>rice<&2>:|<&e><[MeeseeksPrice].format_number><&sp>Coins;enchantments=silk_touch,1;flags=hide_all]>
                - define MeeseeksInfo <item[Action_Item].with[display_name=<&3>M<&b>eeseeks<&sp><&3>I<&b>nfo<&3>:;material=player_head;nbt=<list[Menu/BawbShop|Action/BuyPrompt]>;skull_skin=786a4323-40b0-45eb-937c-9a90e6313d9b|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNWJiNDMzOTFhOWRiZmY5ZWFkYWUwN2I2ODYyNTk1YzkxZDA0YzU5MzhlMjNjMjg1YWM2MGM0Yjg3NjliMjQifX19]>
                - define Decline <item[Action_Item].with[material=Red_stained_glass_pane;display_name=<&3>D<&b>ecline;nbt=<list[Menu/BawbShop|Action/MainMenu]>;lore=<&c>[<&7>Main<&sp>Menu<&c>];enchantments=silk_touch,1;flags=hide_all]>

                - define SoftMenu:|:<[Accept]>|<[Accept]>|<[MeeseeksInfo]>|<[Decline]>|<[Decline]>

                - inventory set d:<[Inventory]> o:<[SoftMenu]>
                - inventory open d:<[Inventory]>

            #^- case Info:
            # @ ██ [ Check for Unspawned Counts ] ██
            #^    - if !<player.has_flag[Behrry.Meeseeks.UnspawnedCount]>:
            #^        - flag player Behrry.Meeseeks.UnspawnedCount:0
            #^    - if <player.flag[Behrry.Meeseeks.UnspawnedCount]> > 0:
            #^        - define UnspawnedCt <player.flag[Behrry.Meeseeks.UnspawnedCount]>

            # @ ██ [ Check for Total Count ] ██
            #^    - if <player.flag[Behrry.Meeseeks.MeeseeksCount]> > 0:
            #^        - define MeeseeksCt <player.flag[Behrry.Meeseeks.MeeseeksCount]>
                

            - case BuyMeeseeks:
                - define MeeseeksPrice <player.flag[Behrry.Meeseeks.MeeseeksCount].add[1].mul[100000].add[<player.flag[Behrry.Meeseeks.MeeseeksCount].add[1].mul[50000]>]>
                #$ Beta Tester ShortTerm
                - flag server Bread.Game.Clicker.BetaTesters:->:<player.uuid>
                - advancement id:MeeseeksBetaTester icon:player_head[skull_skin=786a4323-40b0-45eb-937c-9a90e6313d9b|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNWJiNDMzOTFhOWRiZmY5ZWFkYWUwN2I2ODYyNTk1YzkxZDA0YzU5MzhlMjNjMjg1YWM2MGM0Yjg3NjliMjQifX19] "title:<&2>B<&a>eta <&2>T<&a>ester" "description:<&e>Research takes 5 seconds. YEAH, SCIENCE!"
                - advancement id:MeeseeksBetaTester grant:<player>
                    #$**TEMPORARY until Replacement, Recursive Logic can correct this afterwards**$#
            # $ ██ [ Currency Remove, Debug Mode                                  ] ██
            # $ ██ [ if <player.flag[Behrry.Economy.Coins]> >= <[MeeseeksPrice]>: ] ██
                - if <player.money> >= <[MeeseeksPrice]>:
                # $ ██ [ Currency Remove, Debug Mode                              ] ██
                # $ ██ [ flag player Behrry.Economy.Coins:-:<[MeeseeksPrice]>     ] ██
                    - take money <[MeeseeksPrice]>
                    - flag player Behrry.Meeseeks.MeeseeksCount:+:1
                    - flag player Behrry.Meeseeks.UnspawnedCount:+:1
                    - define Box "<item[Meeseeks_Box].with[material=player_head;display_name=<&3>M<&b>eeseeks<&sp><&3>T<&b>ransportation<&sp><&3>B<&b>ox;nbt=<list[uniquifier/<util.random.uuid>]>;skull_skin=2fb3eec1-a76d-4c75-a817-b81895a76c07|eyJ0aW1lc3RhbXAiOjE1ODU1MzA1OTYxNjcsInByb2ZpbGVJZCI6IjJmYjNlZWMxYTc2ZDRjNzVhODE3YjgxODk1YTc2YzA3IiwicHJvZmlsZU5hbWUiOiJQaW5reSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTgzMjRkMzhkYzE1ZjM4Nzc5ZDIyM2M0OTUzYzQ3ZTI2NDI4YjFlNzQ1MjQyOTE0NjAwNTdkNmQxZWY4ZWRmNiIsIm1ldGFkYXRhIjp7Im1vZGVsIjoic2xpbSJ9fX19;lore=<list[<&a>There's an unspawned|<&a>Meeseeks in here!]>]>"
                    - narrate "You bought a Meeseeks!"
                    - give <[Box]>
                - else:
                    - narrate format:Colorize_Red "Not Enough Coin."
                    - stop

SpawnMeeseeks:
    type: task
    debug: false
    definitions: Loc
    script:
        - if !<player.has_flag[Behrry.Meeseeks.UnspawnedCount]>:
            - flag player Behrry.Meeseeks.UnspawnedCount:0
        - if <player.flag[Behrry.Meeseeks.UnspawnedCount]> > 0:
            - flag player Behrry.Meeseeks.UnspawnedCount:-:1
            - take item_in_hand
            - create player Meeseeks <[Loc].add[0.5,1.1,0.5]> save:Meeseeks
            - foreach <[Loc].add[0.5,0.2,0.5].points_between[<[Loc].add[0.5,2.5,0.5]>].distance[0.01]> as:Area:
                - playeffect <[Area]> effect:CLOUD visibility:125 quantity:1 offset:0.5
                - if <[Loop_Index].mod[20]> == 0:
                    - playeffect <[Area]> effect:CAMPFIRE_COSY_SMOKE visibility:125 quantity:1 offset:0.25
                    - playeffect <[Area]> effect:FLAME visibility:125 quantity:1 offset:0
                    - playsound <[Loc]> ENTITY_PHANTOM_FLAP volume:2
                    - wait 1t
            - define Npc <entry[Meeseeks].created_npc>
            - assignment set script:Meeseeks npc:<[Npc]>
            - adjust <[Npc]> owner:<player>
            #- adjust <[Npc]> speed:1.35
            #- vulnerable state:true npc:<[Npc]>
            #- trait state:true Pushable npc:<[Npc]>
            #- execute as_op "npc select <[Npc].id>" silent
            #- follow <player> followers:<[Npc]>
            - flag <[Npc]> Behrry.Meeseeks.Mode:None
            - flag <[Npc]> Interaction.Dialogue.Generic.Owner:Meeseeks_Operator
            - flag <[Npc]> Interaction.Dialogue.Generic.Player:Meeseeks_Operator
            - flag player Behrry.Meeseeks.OwnedMeeseeks:->:<[Npc].id>
            - flag player Behrry.Meeseeks.ActiveFollow:->:<[Npc].id>
        - else:
            - narrate "Spawn Selected Meeseeks"

Meeseeks_Operator:
    type: task
    debug: false
    definitions: NbtData|NpcID
    script:
    # @ ██ [ Default to Operator Menu                      ] ██
        - if !<[NbtData].exists>:
            - if <player> == <npc.owner>:
                - define Action OperatorMenu
            - else if <npc.has_flag[Meeseeks.Shop.Inventory]>:
                - define Action ShopView
            - else:
                - narrate format:NPC Howdy!
                - stop
        - else:
            - define Action <[NbtData].unescaped.as_list.map_get[Action]>

    # @ ██ [ Determine Option                              ] ██
        - choose <[Action]>:

        # @ ██ [ Main Operator Menu                        ] ██
            - case OperatorMenu:

            # @ ██ [ Determine Definitions                 ] ██
                - define Title "<npc.name>'s Menu"
                - define Type HOPPER
                - define Inventory <inventory[generic[holder=<[Type]>;title=<[Title]>]]>

            # @ ██ [ Build Menu                            ] ██
            # % ██ [ View Shop                             ] ██
                - define DisplayName "<&3>V<&b>iew <&3>S<&b>hop"
                - define Lore "<list[<&a>View <npc.name>'s Shop].escaped>"
                - define Nbt <list[Menu/Meeseeks_Operator|Action/ShopView|NpcID/<npc.id>].escaped>
                - define ViewShop <proc[action_item_builder].context[ender_pearl|<[DisplayName]>|<[Nbt]>|true|<[Lore]>]>
            # % ██ [ Manage Shop                           ] ██
                - define DisplayName "<&3>M<&b>anage <&3>S<&b>hop"
                - define Lore "<list[<&a>Manage <npc.name>'s Shop].escaped>"
                - define Nbt <list[Menu/Meeseeks_Operator|Action/ManageShop|NpcID/<npc.id>].escaped>
                - define ManageShop <proc[action_item_builder].context[ender_pearl|<[DisplayName]>|<[Nbt]>|true|<[Lore]>]>
            # % ██ [ Open Shop                           ] ██
                - define DisplayName "<&3>O<&b>pen <&3>S<&b>hop"
                - define Lore "<list[<&a>Open <npc.name>'s Shop].escaped>"
                - define Nbt <list[Menu/Meeseeks_Operator|Action/OpenShop|NpcID/<npc.id>].escaped>
                - define OpenShop <proc[action_item_builder].context[emerald_block|<[DisplayName]>|<[Nbt]>|true|<[Lore]>]>
            # % ██ [ Close Shop                           ] ██
                - define DisplayName "<&3>C<&b>lose <&3>S<&b>hop"
                - define Lore "<list[<&a>Close <npc.name>'s Shop].escaped>"
                - define Nbt <list[Menu/Meeseeks_Operator|Action/CloseShop|NpcID/<npc.id>].escaped>
                - define CloseShop <proc[action_item_builder].context[redstone_block|<[DisplayName]>|<[Nbt]>|true|<[Lore]>]>
            # % ██ [ Close Shop                           ] ██
                - define DisplayName "<&3>C<&b>lose <&3>M<&b>enu"
                - define Nbt <list[Menu/Meeseeks_Operator|Action/Close|NpcID/<npc.id>].escaped>
                - define Close <proc[action_item_builder].context[barrier|<[DisplayName]>|<[Nbt]>|true]>

                - choose <npc.flag[Behrry.Meeseeks.Mode]>:
                    - case SetupShop:
                        - if <npc.has_flag[Behrry.Meeseeks.ReManage]>:
                            - define SoftMenu:|:<[ManageShop]>|<[OpenShop]>|<[CloseShop]>|blank|<[Close]>
                        - else:
                            - define SoftMenu:|:<[ViewShop]>|<[ManageShop]>|<[OpenShop]>|<[CloseShop]>|<[Close]>
                    - case None:
                        - if <player.has_flag[Behrry.Meeseeks.Shop.Open]>:
                            - if <player.flag[Behrry.Meeseeks.Shop.Open].contains[<npc.id>]>:
                                - define SoftMenu:|:<[ViewShop]>|<[ManageShop]>|<[CloseShop]>|blank|<[Close]>
                            - else:
                                - define SoftMenu:|:<[ManageShop]>|blank|blank|blank|<[Close]>
                        - else:
                            - define SoftMenu:|:<[ManageShop]>|blank|blank|blank|<[Close]>

            # @ ██ [ Open Inventory                        ] ██
                - inventory set d:<[Inventory]> o:<[SoftMenu]>
                - inventory open d:<[Inventory]>

        # @ ██ [ Close Menu                                ] ██
            - case close:
                - inventory close

        # @ ██ [ Close Shop                                ] ██
            - case CloseShop:
                - flag player Behrry.Meeseeks.Shop.Open:<-:<npc.id>
                - flag <npc> Meeseeks.Shop.Inventory:!
                - flag <npc> Behrry.Meeseeks.Mode:None

                - define NbtData <list[Menu/Meeseeks_Operator|Action/OperatorMenu|NpcID/<npc.id>].escaped>
                - define WhileFlag Behrry.Particles.RadiusSwirl
                - if <npc.has_flag[<[WhileFlag]>]>:
                    - if <queue.exists[<npc.flag[<[WhileFlag]>].as_queue.id||null>]>:
                        - queue <npc.flag[<[WhileFlag]>].as_queue> clear
                - flag <npc> <[WhileFlag]>:<queue>

                - if !<server.has_flag[Meeseeks.Shop.ChestLock]>:
                    - flag server Meeseeks.Shop.ChestLock
                - foreach <npc.flag[Meeseeks.Shop.ChestLocks]> as:Chest:
                    - flag <npc> Meeseeks.Shop.ChestLocks:<-:<[Chest]>
                    - flag server Meeseeks.Shop.ChestLock:<-:<[Chest]>/<player.uuid>/<npc.id>
                    

                - narrate format:Colorize_Red "Your shop is now closed."
                - run Meeseeks_Operator def:<[NbtData]> npc:<npc>

        # @ ██ [ Open Shop                                 ] ██
            - case OpenShop:
                - flag player Behrry.Meeseeks.Shop.Open:->:<npc.id>
                - flag <npc> Behrry.Meeseeks.Mode:None
                - flag <npc> Behrry.Meeseeks.ReManage
                - define NbtData <list[Menu/Meeseeks_Operator|Action/ShopView|NpcID/<npc.id>].escaped>
                - define WhileFlag Behrry.Particles.RadiusSwirl
                - if <npc.has_flag[<[WhileFlag]>]>:
                    - if <queue.exists[<npc.flag[<[WhileFlag]>].as_queue.id||null>]>:
                        - queue <npc.flag[<[WhileFlag]>].as_queue> clear
                - flag <npc> <[WhileFlag]>:<queue>
                - inventory close
                - narrate format:Colorize_Green "Your shop is now open!"
                #- run Meeseeks_Operator def:<[NbtData]> npc:<npc>

        # @ ██ [ Manage Shop                               ] ██
            - case ManageShop:
                - flag <npc> Behrry.Meeseeks.ReManage:!
                - flag <npc> Behrry.Meeseeks.Mode:SetupShop
                - flag <npc> Meeseeks.Shop.Inventory:!
                
                - follow stop
                - run Entity_Particle_RadiusSwirl_Layered def:<npc>|Behrry.Particles.RadiusSwirl|4|4|4|3|Villager_Happy|0.45
                - run Meeseeks_Operator

                - inject locally ChestChecks Instantly
                - inject locally PriceBuilderSingles Instantly
                - inject locally InventoryBuilder Instantly
                - inventory open d:<npc.flag[Meeseeks.Shop.Inventory].get[<[Page]>].as_inventory>

                #- For when closing the players out of the inventory
                #^- if <npc.has_flag[Meeseeks.Shop.ActivePlayersViewing]>:
                #^    - foreach <npc.flag[Meeseeks.Shop.ActivePlayersViewing]> as:PlayerUUID:
                #^        - inventory close player:<player[<[PlayerUUID]>]>
                #^- if <npc.has_flag[Meeseeks.Shop.Inventory]>:
                #^    - note as:MeeseeksShop_<npc.id> remove

        # @ ██ [ Player Shop View                          ] ██
            #- Run Meeseeks_Operator def:NBTDATA|NpcID
            - case ShopView:

            # @ ██ [ Determine Page                        ] ██
                - if <[NbtData].unescaped.as_list.map_get[Page]||null> == null:
                    - define Page 1
                - else:
                    - define Page <[NbtData].unescaped.as_list.map_get[Page]>

            # @ ██ [ Check if NPC has a shop inventory yet ] ██
            
                - flag <npc> Meeseeks.Shop.Inventory:!
                - if <npc.has_flag[Meeseeks.Shop.Inventory]>:
                    - inventory open d:<npc.flag[Meeseeks.Shop.Inventory].get[<[Page]>].as_inventory>
                    - flag <npc> Meeseeks.Shop.ActivePlayersViewing:->:<player.uuid>
                - else:
                    - inject locally ChestChecks Instantly
                    - inject locally PriceBuilderMulties Instantly
                    - inject locally InventoryBuilder Instantly
                    - flag <npc> Meeseeks.Shop.ActivePlayersViewing:->:<player.uuid>
                # @ ██ [ Determine Page                        ] ██
                    - if <[NbtData].unescaped.as_list.map_get[Page]||null> == null:
                        - define Page 1
                    - else:
                        - define Page <[NbtData].unescaped.as_list.map_get[Page]>
                    - inventory open d:<npc.flag[Meeseeks.Shop.Inventory].get[<[Page]>].as_inventory>
    ChestChecks:
    # $ ██ [ To-Do: Settings                               ] ██
    # @ ██ [ Determine radius setting                      ] ██
        - if <npc.has_flag[Meeseeks.Shop.Settings.ChestRadius]>:
            - define Radius <npc.flag[Meeseeks.Shop.Settings.ChestRadius]>
        - else:
            - define Radius 4.5

    # @ ██ [ Build full chest list with chests around NPC  ] ██
        - repeat 3:
            - define ChestNearList:|:<npc.location.add[0,<[value]>,0].find.blocks[chest|trapped_chest|barrel].within[<[Radius]>]>
            - define ChestNear <[ChestNearList].deduplicate>

    # @ ██ [ Check if any chests exist                     ] ██
        - if <[ChestNear].is_empty>:
            - narrate "<&e>No Chests Near. <&a>Place a chest in the radius."
            - stop

    # @ ██ [ Check if other NPCs have hold of chests       ] ██
    #$ for removing a chest lock:
    #$ /ex flag server Meeseeks.Shop.ChestLock:<-:<player.cursor_on>/<server.flag[Meeseeks.Shop.ChestLock].map_get[<player.cursor_on>]>
        - foreach <[ChestNear]> as:Chest:
            - if !<server.has_flag[Meeseeks.Shop.ChestLock]>:
                - flag server Meeseeks.Shop.ChestLock
            - if <server.flag[Meeseeks.Shop.ChestLock].parse[before[/]].contains[<[Chest]>]>:
                - define ChestData <server.flag[Meeseeks.Shop.ChestLock].map_get[<[Chest]>].split[/]>
                - if <[ChestData].first> != <npc.owner.uuid>:
                    - narrate "<proc[Colorize].context[Chest locked by player:|red]> <proc[User_Display_Simple].context[<player[<[ChestData].first>]>]>"
                    - stop
            - else:
                - flag <npc> Meeseeks.Shop.ChestLocks:->:<[Chest]>
                - flag server Meeseeks.Shop.ChestLock:->:<[Chest]>/<player.uuid>/<npc.id>
                    #$ To-Do: Settings
                    #^ - else if <player.has_flag[placeholder for checking if two meeseeks can hold at the same time]>:
                    #^    - narrate "Your other meeseeks: <[ChestData].get[3]> has a hold already"
                    #^    - stop
            
    ChestLocker:
        - foreach <[ChestData]> as:Chest:
            - define UUID <util.random.uuid>
            - adjust <[Chest]> lock:<[UUID]>Key
            - give "<item[tripwire_hook].with[display_name=<util.random.uuid.to_secret_colors>Key;nbt=<list[ChestLockKey/<[UUID]>|NpcID/<npc.ID>]>;lore=<&a>Unlocks <npc.name>'s Chests]>"

    ChestUnlocker:
        - foreach <[ChestData]> as:Chest:
            - adjust <[Chest]> lock
            #- events to catch:
            #^ on player drops action_item:
            #^     - if <context.item.has_nbt[ChestLockKey]>:
            #^         - remove <context.entity>
            - inventory remove d:<player.inventory> o:<player.inventory.list_contents.filter[has_nbt[ChestLockKey]]>

    PriceBuilderSingles:
    # @ ██ [ Check for price list flag                     ] ██
        - if !<npc.has_flag[Meeseeks.Shop.ItemPrices]>:
            - flag <npc> Meeseeks.Shop.ItemPrices

    # @ ██ [ Build Item List || Pricing Tagger || SINGLE ITEM MODE ] ██
        - flag player Behrry.Meeseeks.Shop.PriceModifier:1
        - define Display "<&2><&m>==<&6>[<&a>Shop Manage Help<&6>]<&2><&m>=="
        - define "Lore:!|:<&3><&m>----<&6>[<&b>Click Actions:<&6>]<&3><&m>----"
        - define "Lore:->:<&3>left<&b>-<&3>click<&b>: <&2>+<&a>1 Coin"
        - define "Lore:->:<&3>shit<&b>+<&3>left<&b>-<&3>click<&b>: <&2>+<&a>10 Coins"
        - define "Lore:->:<&3>right<&b>-<&3>click<&b>: <&4>-<&c>1 Coins"
        - define "Lore:->:<&3>shift<&b>+<&3>right<&b>-<&3>click<&b>: <&4>-<&c>10 Coins"
        - define "Lore:->:<&3>Ctrl<&b>+<&e>Q<&b>: <&c>reset price"
        - define "Lore:->:<&3><&m>----<&6>[<&b>Price Multiplier:<&6>]<&3><&m>----"
        - define "Lore:->:<&3>Number<&b>-<&3>key<&b>-<&e>1<&b>: <&a>1<&2>x <&a>Coin"
        - define "Lore:->:<&3>Number<&b>-<&3>key<&b>-<&e>2<&b>: <&a>10<&2>x <&a>Coins"
        - define "Lore:->:<&3>Number<&b>-<&3>key<&b>-<&e>3<&b>: <&a>100<&2>x <&a>Coins"
        - define "Lore:->:<&3>Number<&b>-<&3>key<&b>-<&e>4<&b>: <&a>1<&2>,<&a>000<&2>x <&a>Coins"
        - define HelpItem <item[action_item].with[material=Emerald_Block;display_name=<[Display]>;lore=<[Lore]>]>

        - define Display "<&b>M<&3>ain <&b>M<&3>enu"
        - define ManageBack <item[action_item].with[material=barrier;nbt=<list[menu/Meeseeks_Operator|Action/OperatorMenu|NpcID/<npc.id>]>;display_name=<[Display]>]>
        - foreach <[ChestNear]> as:Chest:
            - foreach <[Chest].inventory.list_contents.filter[material.name.is[!=].to[air]].parse[with[quantity=1]].deduplicate> as:Item:
                - if !<npc.flag[Meeseeks.Shop.ItemPrices].unescape_contents.parse[before[/]].contains[<[Item]>]>:
                    - flag <npc> Meeseeks.Shop.ItemPrices:|:<[Item].escaped>/1
                    - define Price 1
                #- else:
                #    - define Price <npc.flag[Meeseeks.Shop.ItemPrices].unescape_contents.map_get[<[Item].with[quantity=1].escaped>]>
                - else if <npc.flag[Meeseeks.Shop.ItemPrices].unescape_contents.map_get[<[Item].with[quantity=1]>]||invalid> != invalid:
                    - define Price <npc.flag[Meeseeks.Shop.ItemPrices].unescape_contents.map_get[<[Item].with[quantity=1]>]>
                - else:
                    - narrate "There was an error with pricing! Adjusting to 1."
                    - define Price 1
                
                #@ Build Item List || Generate Inventory Contents
                - define "Lore:!|:<&3><&m>==<&6>[<&b>Click to Adjust<&6>]<&3><&m>=="
                - if <[Item].max_stack> > 1:
                    - define "Lore:->:<&e>Item Price<&6>: <&a><[Price].format_number> Coins"
                    - define "Lore:->:<&e>Price <&6>(<&e>10x<&6>): <&a><[Price].mul[10].format_number> Coins"
                    - define "Lore:->:<&e>Price <&6>(<&e><[Item].max_stack>x<&6>): <&a><[Price].mul[<[Item].max_stack>].format_number> Coins"
                - else:
                    - define "Lore:->:<&e>Item Price<&6>: <&a><[Price].format_number> Coins"

                - define NewItem <[Item].with[nbt=<list[InventoryOrigin/<[Chest]>|price/<[Price]>]>;lore=<[Lore]>]>
                - define Lore:!
                - define ShopContents:->:<[NewItem]>

                - define Lore:!

    PriceBuilderMulties:
    # @ ██ [ Check for price list flag                     ] ██
        - if !<npc.has_flag[Meeseeks.Shop.ItemPrices]>:
            - flag <npc> Meeseeks.Shop.ItemPrices

    # @ ██ [ Build Item List || Pricing Tagger || MULTI ITEM MODE ] ██
        - define Display "<&2><&m>==<&6>[<&a>Shop Button Help<&6>]<&2><&m>=="
        - define "Lore:!|:<&3><&m>----<&6>[<&b>Click Actions:<&6>]<&3><&m>----"
        - define "Lore:->:<&3>left<&b>-<&3>click<&3>: <&a>Buy <&e>1
        - define "Lore:->:<&3>Right<&b>-<&3>Click<&3>: <&a>Buy <&e>10
        - define "Lore:->:<&3>Shift<&b>-<&3>Click<&3>: <&a>Buy <&e>Stack
        - define HelpItem <item[action_item].with[material=Emerald_Block;display_name=<[Display]>;lore=<[Lore]>]>

        - define Display "<&b>C<&3>lose <&b>S<&3>hop"
        - define ManageBack <item[action_item].with[material=barrier;nbt=<list[menu/Meeseeks_Operator|Action/Close|NpcID/<npc.id>]>;display_name=<[Display]>]>

        - foreach <[ChestNear]> as:Chest:
            - foreach <[Chest].inventory.list_contents.exclude[<item[air]>]> as:Item:
                - if !<npc.flag[Meeseeks.Shop.ItemPrices].unescape_contents.parse[before[/]].contains[<[Item]>]>:
                # $ ██ [ Possibly create economic S&D slope procedure? ] ██
                    #- Yaml Key for reference pricing for each item?
                    #^ - define GenericPricing <yaml[ItemPriceList].read[<[Item].material>]>
                    #^ - flag player Meeseeks.Shop.ItemPrices:|:<[Item].escaped>/<[GenericPricing]>
                    - flag <npc> Meeseeks.Shop.ItemPrices:|:<[Item].escaped>/1
                    - define Price 1
                - else:
                    - define Price <npc.flag[Meeseeks.Shop.ItemPrices].unescape_contents.map_get[<[Item].with[quantity=0]>]>
                
                #@ Build Item List || Generate Inventory Contents
                - define "Lore:!|:<&3>--<&6>[<&b>Click to Buy<&6>]<&3>--"
                - if <[Item].quantity> > 1:
                    - define "Lore:->:<&e>Item Price<&6>: <&a><[Price]> Coins"
                    - define "Lore:->:<&e>Total Price<&6>: <&a><[Price].mul[<[Item].quantity>]> Coins"
                - else:
                    - define "Lore:->:<&e>Item Price<&6>: <&a><[Price]> Coins"
                - define NewItem <[Item].with[nbt=<list[InventoryOrigin/<[Chest]>|price/<[Price]>]>;lore=<[Lore]>]>

                - define Lore:!
            
                - define ShopContents:->:<[NewItem]>
            #- define ShopContents:|:<[Chest].inventory.list_contents.exclude[<item[air]>]>
    InventoryBuilder:
        - if !<[ShopContents].exists>:
            - define ShopContents:|:air
    # @ ██ [ Determine Definitions [1/2]                   ] ██
        - define Title "<&3><npc.owner.flag[Behrry.Essentials.Display_name]||<npc.owner.name>><&r><&2>'s Shop"
        - define TotalSize <[ShopContents].size>
        - define InventorySize <[TotalSize].div[9].round_up.mul[9].min[45].add[9]>
        - define TotalPages  <[TotalSize].div[<[InventorySize].sub[9]>].round_up>

    # @ ██ [ Build Inventories                             ] ██
        - repeat <[TotalPages]>:
            # @ ██ [ Determine Definitions [2*/2]          ] ██
            - define Page <[Value]>
            - define Math1 <[InventorySize].sub[9].mul[<[Page].sub[1]>].add[1]>
            - define Math2 <[InventorySize].sub[9].mul[<[Page].sub[1]>].add[<[InventorySize].sub[9]>]>
            - define ItemList <[ShopContents].get[<[Math1]>].to[<[Math2]>]>

        # @ ██ [ Build Softmenu                            ] ██
            - define SoftMenu:!
            - if <[Page]> != 1:
                - define SoftMenu:->:<item[action_item].with[material=tipped_arrow;display_name=<&3>L<&b>ast<&sp><&3>P<&b>age;potion_effects=<list[jump,true,false]>;nbt=<list[Menu/Meeseeks_Operator|Action/ShopView|NpcID/<npc.id>|Page/<[Page].sub[1]>]>]>
            - else:
                - define SoftMenu:->:Blank
            - define SoftMenu:|:blank|blank|blank|<[HelpItem]>|blank|<[ManageBack]>|blank
            - if <[Page]> != <[TotalPages]>:
                - define SoftMenu:->:<item[action_item].with[material=tipped_arrow;display_name=<&3>N<&b>ext<&sp><&3>P<&b>age;potion_effects=<list[instant_heal,false,false]>;nbt=<list[Menu/Meeseeks_Operator|Action/ShopView|NpcID/<npc.id>|Page/<[Page].add[1]>]>]>
            - else:
                - define SoftMenu:->:Blank

            - define Inventory<[Page]> <inventory[generic[Title=<[Title]>;Size=<[InventorySize]>]]>
            - inventory set d:<[Inventory<[Page]>]> slot:<[InventorySize].sub[8]> o:<[SoftMenu]>
            - inventory set d:<[Inventory<[Page]>]> slot:1 o:<[ItemList]>

            - note <[Inventory<[Page]>]> as:MeeseeksShop<[Page]>_<npc.id>
            - flag <npc> Meeseeks.Shop.Inventory:->:MeeseeksShop<[Page]>_<npc.id>

Admin_Meeseeks_Command:
    type: command
    name: adminmeeseeks
    usage: /AdminMeeseeks (Flag/Spawn/NewBox)
    permission: test
    debug: false
    PlayerFlags:
        - Behrry.Meeseeks.OwnedMeeseeks
        - Behrry.Meeseeks.ActiveFollow
        - Behrry.Meeseeks.UnspawnedCount
        - Behrry.Meeseeks.MeeseeksCount
    NpcFlags:
        - Behrry.Meeseeks.Mode
        - Interaction.Dialogue.Generic
        - Meeseeks.Shop.Inventory
        - Meeseeks.Shop.ItemPrices
        - Behrry.Particles.RadiusSwirl
    tab complete:
        - define Arg1 <list[Flag|ListFlags|Spawn|NewBox]>

        - define Arg2FlagArgs <script.data_key[PlayerFlags]>
        - define Arg2SpawnArgs <server.match_player[_Behr].flag[Behrry.Meeseeks.OwnedMeeseeks]||>
        - define Arg2ListFlagsArgs <server.online_players.parse[name]>

        - inject MultiArg_With_MultiArgs_Command_Tabcomplete Instantly
    aliases:
        - am
    script:
        - if <context.args.size> < 1:
            - inject Command_Syntax Instantly
        - define Arg1 <context.args.first>
        - choose <[Arg1]>:
            - case Flag:
                - define Value <context.raw_args.after[<context.args.get[2><&sp>]>
                - if <[Value]> == !:
                    - narrate "<&e>Flag<&6>: <&a><context.args.get[2]> <&c>removed"
                - else if <[Value].starts_with[-<&lt>]>:
                    - flag <context.args.get[2]>:<context.raw_args.after[-<&lt>]>
                    - narrate "<&e>Flag<&6>: <&a><context.args.get[2]><&e> inserted<&6>:<&a><context.raw_args.after[<context.args.get[-<&lt>]>"
                - else:
                    - flag <context.args.get[2]>:<context.raw_args.after[<context.args.get[2]><&sp>]>
                    - narrate "<&e>Flag<&6>: <&a><context.args.get[2]><&e> set to<&6>:<&a><context.raw_args.after[<context.args.get[<context.args.get[2]><&sp>]>"
            - case ListFlags:
                - if <context.args.get[2]||null> == null:
                    - define List <script.data_key[PlayerFlags]>
                    - define User <player>
                - else if <context.args.get[2].is_integer>:
                    - define List <script.data_key[NpcFlags]>
                    - if <npc[<context.args.get[2]>]||invalid> == invalid:
                        - narrate invalid:<context.args.get[2]>
                        - stop
                    - define User <npc[<context.args.get[2]>]>
                - else:
                    - define List <script.data_key[PlayerFlags]>
                    - define User <context.args.get[2]>
                    - inject Player_Verification
                - flag server TestingTarget:<[User]>
                - define Hover "<&e>Click to <&a>Insert <&e><[User].name>"
                - define Text "<&b><&m>--------- <&e>Flags for<&6>: <&a><[User].name> <&b><&m>---------"
                - define Command "ex flag <&lt>server.flag[TestingTarget]<&gt> "
                - narrate <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
                - foreach <[List]> as:Flag:
                    - define Hover "<&e>Shift<&6>+<&e>Click to <&a>Insert"
                    - define Text "<&e>- <[Flag]> <&b>== <&a><[User].flag[<[Flag]>]||null>"
                    - define Insert <[Flag]>
                    - narrate <proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Insert]>]>

Inventory_Debug:
    type: task
    debug: false
    script:
        - announce to_console <&c><element[].pad_right[120].with[=]>
        - announce to_console "<&e><&lt>context.item<&gt> <&b>| <&a><context.item> <&b>| <&3> returns the ItemTag the player has clicked on.
        - announce to_console "<&e><&lt>context.inventory<&gt> <&b>| <&a><context.inventory> <&b>| <&3> returns the InventoryTag (the 'top' inventory, regardless of which slot was clicked).
        - announce to_console "<&e><&lt>context.clicked_inventory<&gt> <&b>| <&a><context.clicked_inventory||NULL OUTSIDE> <&b>| <&3> returns the InventoryTag that was clicked in.
        - announce to_console "<&e><&lt>context.cursor_item<&gt> <&b>| <&a><context.cursor_item> <&b>| <&3> returns the item the Player is clicking with.
        - announce to_console "<&e><&lt>context.click<&gt> <&b>| <&a><context.click> <&b>| <&3> returns an ElementTag with the name of the click type. Click type list: http://bit.ly/2IjY198
        - announce to_console "<&e><&lt>context.slot_type<&gt> <&b>| <&a><context.slot_type> <&b>| <&3> returns an ElementTag with the name of the slot type that was clicked.
        - announce to_console "<&e><&lt>context.slot<&gt> <&b>| <&a><context.slot> <&b>| <&3> returns an ElementTag with the number of the slot that was clicked.
        - announce to_console "<&e><&lt>context.raw_slot<&gt> <&b>| <&a><context.raw_slot> <&b>| <&3> returns an ElementTag with the raw number of the slot that was clicked.
        - announce to_console "<&e><&lt>context.is_shift_click<&gt> <&b>| <&a><context.is_shift_click> <&b>| <&3> returns true if 'shift' was used while clicking.
        - announce to_console "<&e><&lt>context.action<&gt> <&b>| <&a><context.action> <&b>| <&3> returns the inventory_action. See !language Inventory Actions.
        - announce to_console "<&e><&lt>context.hotbar_button<&gt> <&b>| <&a><context.hotbar_button> <&b>| <&3> returns an ElementTag of the button pressed as a number, or 0 if no number button was pressed.


#$ Spirals particles around an entity
#- run Entity_Particle_RadiusSwirl_Layered def:<npc>|Behrry.Particles.RadiusSwirl|4|4|4|3|Villager_Happy|0.45
#^ definitions:Target|WhileFlag|Radius of cylinder|Density of Particles|Speed of Spiral|Number of layers|Particle Effect|Offset
Entity_Particle_RadiusSwirl_Layered:
    type: task
    debug: false
    definitions: Target|WhileFlag|Radius|Density|Speed|Layers|Particle|Offset
    script:
        #@ Definition Check & Defaults [ 1-2 / 8 ]
        - if !<[Target].exists>:
            - narrate format:Colorize_Red "Missing Target"
            - stop
        - if !<[WhileFlag].exists>:
            - define Flag Test

        #@ Check for active queue to remove & replace
        - if <[Target].has_flag[<[WhileFlag]>]>:
            - if <queue.exists[<[Target].flag[<[WhileFlag]>].as_queue.id||null>]>:
                - queue <[Target].flag[<[WhileFlag]>].as_queue> clear
        - flag <[Target]> <[WhileFlag]>:<queue>

        #@ Definition Check & Defaults [ 3-8 / 8 ]
        #- Check defs?
        #^- define Definitions <list[Radius|Density|Speed|Layers|Particle|Offset]>
        #^- define Defaults <list[4|4|4|3|Villager_Happy|0,0.45,0]>
        - if !<[Radius].exists>:
            - define Radius 4
        - if !<[Density].exists>:
            - define Density 4
        - if !<[Speed].exists>:
            - define Speed 4
        - if !<[Layers].exists>:
            - define Layers 3
        - if !<[Particle].exists>:
            - define Particle Villager_Happy
        - if !<[Offset].exists>:
            - define Offset 0,0.45,0

        #@ Display Particles
        - while <[Target].has_flag[<[WhileFlag]>]>:
            - repeat <element[360].div[<[Density]>]>:
                - define Int1 <[value]>
                - repeat <[Layers]>:
                    - playeffect offset:0 at:<[Target].location.add[<location[<[Radius]>,<[Value].sub[1].add[<[Offset]>]>,0].rotate_around_y[<[Int1].to_radians.mul[<[Density]>]>]>]> effect:<[Particle]>
                    - playeffect offset:0 at:<[Target].location.add[<location[-<[Radius]>,<[Value].sub[1].add[<[Offset]>]>,0].rotate_around_y[<[Int1].to_radians.mul[<[Density]>]>]>]> effect:<[Particle]>
                    - playeffect offset:0 at:<[Target].location.add[<location[0,<[Value].sub[1].add[<[Offset]>]>,-<[Radius]>].rotate_around_y[<[Int1].to_radians.mul[<[Density]>]>]>]> effect:<[Particle]>
                    - playeffect offset:0 at:<[Target].location.add[<location[0,<[Value].sub[1].add[<[Offset]>]>,<[Radius]>].rotate_around_y[<[Int1].to_radians.mul[<[Density]>]>]>]> effect:<[Particle]>
                - wait <[Speed]>t
