Meeseeks:
    type: assignment
    debug: false
    actions:
        on assignment:
            - flag npc ItemPrices:<map>
            - if !<server.has_flag[Meeseeks.LockedChests]>:
                - flag server Meeseeks.LockedChests:->:<map>
        #on exit proximity:
            #- inject NPC_Interaction path:Exit
        on click:
            - run Meeseeks_Click_Trigger
        on damage:
            - run Meeseeks_Click_Trigger

BlankClear:
    type: item
    debug: false
    debug: false
    display name: <&r>
    material: glass_pane
action_item2:
    type: item
    debug: false
    material: stick
Meeseeks_Configurator_Stick:
    type: item
    debug: false
    material: wither_rose
    display name: <&b>M<&3>eeseeks <&b>C<&3>onfigurator
    mechanisms:
        hides: all
Meeseeks_Key:
    type: item
    debug: false
    material: tripwire_hook
    mechanisms:
        hides: enchants
        enchantments: silk_touch,1|VANISHING_CURSE,1
Meeseeks_Box:
    type: item
    debug: false
    material: player_head
    display name: <&b>M<&3>eeseeks <&b>B<&3>ox
    mechanisms:
        hides: enchants
        enchantments: VANISHING_CURSE,1
        skull_skin: 2fb3eec1-a76d-4c75-a817-b81895a76c07|eyJ0aW1lc3RhbXAiOjE1ODU1MzA1OTYxNjcsInByb2ZpbGVJZCI6IjJmYjNlZWMxYTc2ZDRjNzVhODE3YjgxODk1YTc2YzA3IiwicHJvZmlsZU5hbWUiOiJQaW5reSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTgzMjRkMzhkYzE1ZjM4Nzc5ZDIyM2M0OTUzYzQ3ZTI2NDI4YjFlNzQ1MjQyOTE0NjAwNTdkNmQxZWY4ZWRmNiIsIm1ldGFkYXRhIjp7Im1vZGVsIjoic2xpbSJ9fX19
    lore:
        - <empty>
        - <&7>There<&8>'<&7>s a Meeseeks in here<&8>!
General_Meeseeks_Handler:
    type: world
    debug: false
    events:
        on player places Meeseeks_Box:
            - define Loc <context.location>
            - flag player Behrry.Meeseeks.UnspawnedCount:--
            - take iteminhand
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
            - adjust <[Npc]> lookclose:true
Global_Inventory_Handler:
    type: world
    debug: false
    abuse_prevention_click:
        - if <context.clicked_inventory.inventory_type||outside> == player:
            - stop
        - if <context.clicked_inventory.inventory_type||outside> == crafting:
            - if <context.raw_slot||<context.raw_slots.numerical.first>> >= 6:
                - stop
        - if <context.clicked_inventory.contains.scriptname[blank]>:
            - stop
        - determine passively cancelled
        - inventory update
    events:
        on player clicks in Meeseeks_Inventory* priority:-1:
            #^- if <context.clicked_inventory||invalid> == invalid:
            #^    - stop

            - if <context.click> == number_key:
                - determine passively cancelled
                - if <context.inventory.size> == 9:
                    - stop
                - define npc <context.inventory.note_name.before_last[_].after_last[_]>
                - define x <element[10].power[<context.hotbar_button.sub[1]>]>
                - flag player Behrry.Meeseeks.Shop.PriceModifier:<[x]>
                - define HelpSlot 3
                - inject Meeseeks_Shop.Color npc:<[NPC]>
                - inject Meeseeks_Shop.Help npc:<[NPC]>
                - inventory set d:<context.inventory> slot:<context.inventory.size.sub[4]> o:<[Help]>
                - stop
            - else if <context.raw_slot> < <context.inventory.size.sub[9]>:
                - if <context.item.has_nbt[Menu]>:
                    - determine passively cancelled
                    - define NewAction <context.inventory.note_name.after_last[_]>
                    - run npc:<context.item.nbt[NPC]> <script[<context.item.nbt[Menu]>]> def:<list_single[<context.item.nbt.exclude[Action/<context.item.nbt[Action]||null>].include[Action/<[NewAction]>Click]>].include[<context.click>|<context.raw_slot>]>

        on item moves from inventory to inventory:
            - if <context.destination.location.is_lockable>:
                - if <context.destination.location.is_locked>:
                    - determine cancelled
            - if <context.origin.location.is_lockable>:
                - if <context.origin.location.is_locked>:
                    - determine cancelled
        on player closes Meeseeks_Inventory*:
            - define npc <context.inventory.note_name.before_last[_].after_last[_]>
            - flag <npc[<[NPC]>]> ActiveUsers:<-:<player>
            - note as:<context.inventory.note_name> remove
        on player drops Meeseeks_Key:
            - remove <context.entity>
        on player drops Meeseeks_Box:
            - determine cancelled
        on player right clicks block with:Meeseeks_Key priority:-1:
            - if <list[chest|barrel|trapped_chest].contains[<context.location.material.name||<player.cursor_on.material.name>>]>:
                - stop
            - determine passively cancelled
            - define PLoc <player.eye_location.below[0.2]>
            - define TLoc <player.item_in_hand.nbt[LockLoc].as_location.center.above[0.5]>
            - define Steps <[PLoc].points_between[<[TLoc]>].distance[0.1]>
            - foreach <[Steps]> as:Loc:
                - if <[Loop_Index]> < <[Steps].size.div[2].add[3]>:
                    - define i:++
                - else:
                    - define i:--
                - define y <[i].mul[0.5].power[1.3].div[<[i]>].sub[1]>
                - define ParticleColor <color[<util.random.int[230].to[250]>,<util.random.int[200].to[220]>,0]>
                - playeffect effect:redstone at:<[Loc].above[<[y]>]> offset:0 special_data:1|<[ParticleColor]>
                - if <[Loop_Index].mod[5]> == 0:
                    - wait 1t
                - if <[Loop_Index].mod[10]> == 0:
                    - playeffect effect:end_rod at:<[Loc].above[<[y]>]> offset:0
            - repeat 180:
                - define ParticleColor <color[<util.random.int[230].to[250]>,<util.random.int[200].to[220]>,0]>
                - playeffect effect:redstone at:<[Loc].add[<location[0,0,0.66].rotate_around_y[<[value].to_radians.mul[10]>]>]> offset:0 special_data:1|<[ParticleColor]>
                - if <[value].mod[4]> == 0:
                    - wait 1t
                - if <[value].mod[10]> == 0:
                    - playeffect effect:end_rod at:<[Loc].add[<location[0,0,0.66].rotate_around_y[<[value].to_radians.mul[10]>]>]> offset:0
        on player clicks in inventory:
            - if <context.clicked_inventory.inventory_type||invalid> != player:
                - if <player.inventory.slot[<context.hotbar_button>].has_script>:
                    - if <list[Meeseeks_Key|Meeseeks_Box].contains[<player.inventory.slot[<context.hotbar_button>].scriptname>]>:
                        - determine cancelled
            - if <list[shift_left|shift_right|middle|control_drop].contains[<context.click>]>:
                - if <context.item.has_script>:
                    - if <list[Meeseeks_Key|Meeseeks_Box].contains[<context.item.scriptname>]>:
                        - determine cancelled
        on player clicks in inventory with:Meeseeks_Key|Meeseeks_Box:
            - inject locally abuse_prevention_click
        on player drags Meeseeks_Key|Meeseeks_Box in inventory:
            - inject locally abuse_prevention_click
        on player places Meeseeks_Key:
            - determine cancelled
        on player breaks chest|barrel|trapped_chest:
            - if <context.location.is_locked>:
                - if <player.gamemode> != creative:
                    - determine passively cancelled
                    - narrate format:colorize_red "Locked Chests cannot be broken."
                - else:
                    - narrate format:colorize_yellow "Locked Chest Removed."
                - run Chest_Unlock_Task def:<context.location>

        #on player clicks chest|barrel|trapped_chest with Meeseeks_Key:
        on player clicks chest|barrel|trapped_chest:
            - if <context.location.is_locked>:
                - define Chest <context.location>
                - define LockedChests <server.flag[Meeseeks.LockedChests].as_map>
                - if !<player.item_in_hand.has_script>:
                    - inject Meeseeks_Chest_locked_Display_Task
                    - stop
                - if <player.item_in_hand.scriptname> != Meeseeks_Key:
                    - inject Meeseeks_Chest_locked_Display_Task
                    - stop
                - if <[LockedChests].keys.contains[<[Chest].simple>]> || <[LockedChests].keys.contains[<[Chest].add[<[Chest].material.relative_vector||0,0,0>].simple>]>:
                    - if <npc[<[LockedChests].get[<[Chest].simple>].first>].owner> == <player> || <npc[<[LockedChests].get[<[Chest].add[<[Chest].material.relative_vector||0,0,0>].simple>].first>].owner> == <player>:
                        - if <[Chest].lock.after[ey].from_secret_colors> == <context.item.nbt[UUID]> || <[Chest].add[<[Chest].material.relative_vector||0,0,0>].lock.after[ey].from_secret_colors> == <context.item.nbt[UUID]>:
                            - take <context.item>
                            - adjust <[Chest]> lock
                            - adjust <[Chest].add[<[Chest].material.relative_vector||0,0,0>]> lock
                            - define LockedChests <[LockedChests].exclude[<[Chest].simple>|<[Chest].add[<[Chest].material.relative_vector||0,0,0>]>]>
                            - flag server Meeseeks.LockedChests:<[LockedChests]>
                            - narrate format:Colorize_yellow "Chest Unlocked."
                            - stop
                    - else:
                        - inject Meeseeks_Chest_locked_Display_Task
                        #- run Meeseeks_Chest_locked_Display_Task def:<[Chest]>|<[LockedChests]>
                        
        on player clicks BlankClear in inventory:
            - determine cancelled
        on player clicks action_item2 in inventory:
            - determine passively cancelled
            - if <context.item.has_nbt[Menu]>:
                - if <context.item.has_nbt[NPC]>:
                    - run npc:<context.item.nbt[NPC]> <script[<context.item.nbt[Menu]>]> def:<list_single[<context.item.nbt>].include[<context.click>|<context.raw_slot>]>
                - else:
                    - run <script[<context.item.nbt[Menu]>]> def:<list_single[<context.item.nbt>].include[<context.click>|<context.raw_slot>]>

Meeseeks_Click_Trigger:
    type: task
    debug: false
    script:
        - if <npc.owner> == <player>:
            - run Meeseeks_Shop def:<list_single[<list[Action/Home]>]>
        - else:
            - if <player.item_in_hand.has_script>:
                - if <player.item_in_hand.scriptname> == Meeseeks_Configurator_Stick:
                    - run Meeseeks_Shop def:<list_single[<list[Action/Home]>]>
            - if <npc.has_flag[ShopOpen]>:
                - run Meeseeks_Shop def:<list_single[<list[Action/Shop|Page/1]>]> npc:<npc>
            - else:
                - narrate format:npc "I'm not open right now, Check back later!"


Meeseeks_Chest_locked_Display_Task:
    type: task
    debug: false
    script:
        - define Owner <npc[<[LockedChests].get[<[Chest].simple>].first>].owner>
        - if <player.has_flag[Meeseeks.Message.LockedSpam.<context.location.simple>]>:
            - stop
        - if <context.location.material.relative_vector||invalid> != invalid:
            - if <player.has_flag[Meeseeks.Message.LockedSpam.<context.location.add[<context.location.material.relative_vector>].simple>]>:
                - stop
        - flag player Meeseeks.Message.LockedSpam.<context.location.simple> duration:3s
        - if <[Owner]> != <player>:
            - narrate "<&4>T<&c>his chest is locked by<&2>: <&e><[Owner].name>"
        - else:
            - narrate "<&4>Y<&c>ou need your key to unlock that<&4>!"
        - choose <context.location.material.name>:
            - case chest trapped_chest:
                - if <context.location.material.relative_vector||invalid> != invalid:
                    - define Loc <cuboid[<context.location>|<context.location.add[<context.location.material.relative_vector>]>].center.above[0.1]>
                - else:
                    - define Loc <context.location.center.above[0.1]>
                - displayitem <item[player_head].with[skull_skin=<[Owner].uuid>]> <[Loc].below[1.05]> save:di
                - mount <entry[di].dropped>|armor_stand[gravity=false;visible=false] <[Loc].below[1.05]> save:he
                - spawn armor_stand[marker=true;visible=false;invulnerable=true;custom_name_visible=true;custom_name=<[Owner].display_name||<[Owner].name>>] <[Loc]> save:as
                - define Entities <entry[he].mounted_entities.include[<entry[as].spawned_entity>]>
            - case barrel:
                - define Loc <context.location.center>
                - displayitem <item[player_head].with[skull_skin=<[Owner].uuid>]> <[Loc].below[0.95]> save:di
                - adjust <entry[di].dropped> custom_name_visible:true
                - adjust <entry[di].dropped> custom_name:<[Owner].display_name||<[Owner].name>>
                - mount <entry[di].dropped>|armor_stand[gravity=false;visible=false] <[Loc].below[0.95]> save:he
                - define Entities <entry[he].mounted_entities>
        - repeat 30:
            - define ParticleColor <color[<util.random.int[230].to[250]>,<util.random.int[200].to[220]>,0]>
            - playeffect effect:redstone at:<[Loc].above[0.6]> offset:0.05 special_data:0.8|<[ParticleColor]>
            - wait 2t
        #- wait 3s
        - remove <[Entities]>

Chest_Unlock_Task:
    type: task
    debug: false
    definitions: Chest
    script:
        - define Chest <[Chest].as_location>
        - define LockedChests <server.flag[Meeseeks.LockedChests].as_map>
        - if <[LockedChests].keys.contains[<[Chest].simple>]>:
            #- if <npc[<[LockedChests].get[<[Chest].simple>].first>].owner> == <player>:
                #- if <[Chest].lock.after[ey].from_secret_colors> == <context.item.nbt[UUID]>:
            - define LockedChests <[LockedChests].exclude[<[Chest].simple>]>
            - flag server Meeseeks.LockedChests:<[LockedChests]>
            - adjust <[Chest]> lock
        - if <[LockedChests].keys.contains[<[Chest].add[<[Chest].material.relative_vector||0,0,0>].simple>]>:
            - define LockedChests <[LockedChests].exclude[<[Chest].add[<[Chest].material.relative_vector||0,0,0>].simple>]>
            - flag server Meeseeks.LockedChests:<[LockedChests]>
            - adjust <[Chest].add[<[Chest].material.relative_vector||0,0,0>]> lock
Meeseeks_Shop:
    type: task
    debug: false
    definitions: NBT|Click|Slot
    script:
        - foreach <[NBT].exclude[menu|npc]> as:Pair:
            - define <[Pair].before[/]> <[Pair].after[/].unescaped>
        - choose <[Action]>:
            - case Home:
                - inject locally AuraClear
                - inject locally Color
                - define ShopStatus <item[action_item2].with[material=book;nbt=menu/Meeseeks_Shop|npc/<npc>|action/StatusChange]>
                - if <npc.has_flag[ShopOpen]>:
                    - define ShopStatus "<[ShopStatus].with[display_name=<&b><&m>      <[c]><&lb> <&b>S<&3>tatus<&b>: <[c]><&rb><&b><&m>      ;lore=<empty>|<&7>Your shop is<&8>: <&a>Open|<&3>Click <&7>to open shop.;enchantments=silk_touch,1;hides=all]>"
                - else:
                    - define ShopStatus "<[ShopStatus].with[display_name=<&b><&m>       <[c]><&lb> <&b>S<&3>tatus<&b>: <[c]><&rb><&b><&m>       ;lore=<empty>|<&7>Your shop is<&8>: <&c>Closed|<&3>Click <&7>to open shop.]>"
                - define KeyBox "<item[action_item2].with[display_name=<&b><&m>     <[c]><&lb> <&b>K<&3>ey <&b>B<&3>ox <[c]><&rb><&b><&m>     ;lore=<empty>|<&3>Click <&7>to obtain Keys.;material=ender_chest;nbt=menu/Meeseeks_Shop|action/KeyBox|npc/<npc>]>"
                - define PreviewShop "<item[action_item2].with[display_name=<&b><&m>    <[c]><&lb> <&b>P<&3>review <&b>S<&3>hop <[c]><&rb><&b><&m>    ;lore=<empty>|<&3>Click <&7>to Preview Shop.;material=enchanted_book;nbt=menu/Meeseeks_Shop|page/1|action/Preview|npc/<npc>]>"
                - define ManageShop "<item[action_item2].with[display_name=<&b><&m>    <[c]><&lb> <&b>M<&3>anage <&b>S<&3>hop <[c]><&rb><&b><&m>    ;lore=<empty>|<&3>Click <&7>to Manage Shop.;material=writable_book;enchantments=silk_touch,1;hides=all;nbt=menu/Meeseeks_Shop|page/1|action/Manage|npc/<npc>]>"
                - define inventory "<inventory[generic[holder=hopper;Title=<&b>M<&3>eeseeks <&b>C<&3>onfigurator;contents=BlankClear|<[ShopStatus]>|<[KeyBox]>|<[PreviewShop]>|<[ManageShop]>]]>"
                
                - inventory open d:<[Inventory]>

            - case KeyBox:
                - inject locally ChestRadius
                - if <[ChestList]||null> != null:
                    - foreach <[ChestList].filter[is_locked]> as:Chest:
                        - if <[LockedChests].keys.contains[<[Chest].simple>]>:
                            - if <[LockedChests].get[<[Chest].simple>].first> == <npc.id>:
                                - define UUID <[LockedChests].get[<[Chest].simple>].get[2]>
                                - define Key "<item[Meeseeks_Key].with[nbt=UUID/<[UUID]>|LockLoc/<[Chest].simple>;display_name=<&b>K<&3>ey<[UUID].to_secret_colors>;lore=<empty>|<&7>Unlocks chest at<&8>:|<&e><[Chest].simple.before_last[,].replace[,].with[<&6>, <&e>]>]>"
                                - if <player.inventory.contains[<[Key]>]>:
                                    - foreach next
                                - define Keys:->:<[Key]>
                - else:
                    - narrate format:colorize_red "No chests near to lock."
                    - stop
                - if <[Keys]||null> == null:
                    - define Keys <list>

                - define HelpSlot 4
                - inject locally Color
                - inject locally help
                - define size <[Keys].size.div[9].round_up.mul[9].max[0].min[36]>
                - define back "<item[action_item2].with[hides=all;enchantments=silk_touch,1;display_name=<&b><&m>    <[c]><&lb> <&b>M<&3>ain <&b>M<&3>enu <[c]><&rb><&b><&m>    ;lore=<empty>|<&3>Click <&7>to go back.;nbt=menu/Meeseeks_Shop|action/Home|npc/<npc>;material=tipped_arrow;potion_effects=<[BackProperty]>,true,false;hides=all]>"
                - define inventory "<inventory[generic[size=<[Size].add[9]>;Title=<&b>K<&3>ey <&b>B<&3>ox;contents=<[Keys]>]]>"
                - inventory set d:<[inventory]> slot:<[Size].add[1]> o:<[Back]>|Blank|Blank|Blank|<[Help]>|Blank|Blank|Blank|Blank
                - inventory open d:<[Inventory]>

            - case Shop Preview Manage:
                - inject locally InventoryCache
                - inject locally ChestRadius
                - inject locally color
                - if <[ChestList]||null> == null:
                    - if <npc.has_flag[ShopOpen]>:
                        - narrate format:Colorize_Red "Shop closed! No chests near."
                        - flag npc ShopOpen:!
                        - if <[Action]> == Shop:
                            - stop
                    - define PreCount 0
                    - inject locally ArrowKeys
                - else:
                    - define ItemPrices <npc.flag[ItemPrices].as_map>
                    - define Inventories <[ChestList].filter[is_locked].parse[inventory].deduplicate>
                    - if <list[Shop|Preview].contains[<[Action]>]>:
                        - define PreCount <[Inventories].parse[list_contents.filter[material.name.is[!=].to[Air]]].combine.size>
                        - inject locally ArrowKeys
                        - foreach <[Inventories]> as:Inventory:
                            - define ChestLoc <[Inventory].location>
                            - foreach <[Inventory].list_contents.filter[material.name.is[!=].to[Air]]> as:Item:
                                - define i:++
                                - if <[i]> < <[Size].mul[<[Page].sub[1]>]> || <[i]> > <[Size].mul[<[Page]>]>:
                                    - foreach next
                                - inject locally PricedItemLore
                                - define Items:->:<[Item].with[lore=<[Lore]>;nbt=menu/Meeseeks_Shop|action/PreviewClick|npc/<npc>|Origin/<[ChestLoc]>|Price/<[Price]>]>
                    - else:
                        - define Contents <[Inventories].parse[list_contents.filter[material.name.is[!=].to[Air]].parse[with[quantity=1]]].combine.deduplicate>
                        - define PreCount <[Contents].size>
                        - inject locally ArrowKeys
                        - foreach <[Contents]> as:Item:
                            - if <[Loop_Index]> < <[Size].mul[<[Page].sub[1]>]> || <[Loop_Index]> > <[Size].mul[<[Page]>]>:
                                - foreach next
                            - inject locally PricedItemLore
                            - define Items:->:<[Item].with[lore=<[Lore]>;nbt=menu/Meeseeks_Shop|action/ManageClick|npc/<npc>|Price/<[Price]>]>
                - if <[Items]||null> != null:
                    - define Size <[Items].size.div[9].round_up.mul[9].max[9].min[36]>
                    - define ItemList <[Items]>
                    - define ItemList <[ItemList].include[<item[blank].repeat_as_list[<[Size].sub[<[Items].size>].mod[10]>]>]>
                    - if <list[Shop|Preview].contains[<[Action]>]>:
                        - define HelpSlot 2
                    - else:
                        - define HelpSlot 3
                        - define x 1
                - else:
                    - if <npc.has_flag[ShopOpen]>:
                        - narrate format:Colorize_Red "Shop closed! No items for sale."
                        - flag npc ShopOpen:!
                    - define Size 0
                    - define HelpSlot 1
                    - define ItemList <list>
                - inject locally Help
                - choose <[Action]>:
                    - case Preview Manage:
                        - define back "<item[action_item2].with[display_name=<&b><&m>    <[c]><&lb> <&b>M<&3>ain <&b>M<&3>enu <[c]><&rb><&b><&m>    ;lore=<empty>|<&3>Click <&7>to go back.;nbt=menu/Meeseeks_Shop|action/Home|npc/<npc>;material=tipped_arrow;potion_effects=<[BackProperty]>,true,false;enchantments=silk_touch,1;hides=all]>"
                    - case Shop:
                        - define back <item[Blank]>
                - define inventory "<inventory[generic[size=<[Size].add[9]>;Title=<&2><npc.owner.name><&b>'<&3>s <&b>S<&3>hop;contents=<[ItemList]>]]>"
                - inventory set d:<[inventory]> slot:<[Size].add[1]> o:<[Back]>|<[ArrowSlot1]>|Blank|Blank|<[Help]>|Blank|Blank|Blank|<[ArrowSlot2]>
                
                - note <[Inventory]> as:Meeseeks_Inventory_<npc.id>_<[Action]>
                - inventory open d:<Inventory[Meeseeks_Inventory_<npc.id>_<[Action]>]>

            - case StatusChange:
                - if <npc.has_flag[ShopOpen]>:
                    - flag npc ShopOpen:!
                    - define status <&c>Closed
                - else:
                    - inject locally ChestRadius
                    - if !<[Chestlist]||null> == null:
                        - narrate format:Colorize_Red "No items available for sale. Lock chests nearby to setup shop."
                        - stop
                    - if <[ChestList].filter[is_locked].parse[inventory].deduplicate.parse[list_contents.filter[material.name.is[!=].to[Air]]].size> == 0:
                        - narrate format:Colorize_Red "No items available for sale. Lock chests nearby to setup shop."
                        - stop
                    - flag npc ShopOpen
                    - define status <&a>Open
                - inject locally Color
                - wait 1t
                - inventory adjust d:<player.open_inventory> slot:2 "display_name:<&b><&m>      <[c]><&lb> <&b>S<&3>tatus<&b>: <[c]><&rb><&b><&m>      "
                - inventory adjust d:<player.open_inventory> slot:2 "lore:<empty>|<&7>Your shop is<&8>: <[Status]>|<&3>Click <&7>to close shop."
                - inventory adjust d:<player.open_inventory> slot:3 "display_name:<&b><&m>     <[c]><&lb> <&b>K<&3>ey <&b>B<&3>ox <[c]><&rb><&b><&m>     "
                - inventory adjust d:<player.open_inventory> slot:4 "display_name:<&b><&m>    <[c]><&lb> <&b>P<&3>review <&b>S<&3>hop <[c]><&rb><&b><&m>    "
                - inventory adjust d:<player.open_inventory> slot:5 "display_name:<&b><&m>    <[c]><&lb> <&b>M<&3>anage <&b>S<&3>hop <[c]><&rb><&b><&m>    "
            - case RadiusControl:
                - if <[Click].contains[Left]>:
                    - inventory close
                    - narrate "<&3>Surrounding the NPC is the area in which it can reach<&b>."
                    - inject locally AuraClear
                    - flag <npc> RadiusAura:<queue.id>
                    - while <npc.has_flag[RadiusAura]> && <player.is_online> && <npc.is_spawned> && <npc.location.distance[<player.location>]> < 15:
                        - repeat 90:
                            - define i <[Value]>
                            - repeat 3:
                                - playeffect offset:0 at:<npc.location.add[<location[4,<[Value].sub[1].add[0.45]>,0].rotate_around_y[<[i].to_radians.mul[4]>]>]> effect:Villager_Happy
                                - playeffect offset:0 at:<npc.location.add[<location[-4,<[Value].sub[1].add[0.45]>,0].rotate_around_y[<[i].to_radians.mul[4]>]>]> effect:Villager_Happy
                                - playeffect offset:0 at:<npc.location.add[<location[0,<[Value].sub[1].add[0.45]>,-4].rotate_around_y[<[i].to_radians.mul[4]>]>]> effect:Villager_Happy
                                - playeffect offset:0 at:<npc.location.add[<location[0,<[Value].sub[1].add[0.45]>,4].rotate_around_y[<[i].to_radians.mul[4]>]>]> effect:Villager_Happy
                            - wait 4t
                - else if <[Click].contains[right]>:
                    - inject locally ChestRadius
                    - if <[ChestList]||null> == null:
                        - narrate format:Colorize_Red "No Un-Locked Chests Near."
                        - stop
                    - else if <[ChestList].filter[inventory.list_contents.is_empty.not].is_empty>:
                        - narrate format:colorize_red "No items to sell."
                        - stop
                    - else:
                        - foreach <[ChestList].filter[is_locked.not].filter[inventory.list_contents.is_empty.not]> as:Chest:
                            - define UUID <util.random.uuid>
                            - define LockedChests <[LockedChests].with[<[Chest].simple>].as[<list[<npc.id>|<[UUID]>]>]>
                            - adjust <[Chest]> lock:<&b>K<&3>ey<[UUID].to_secret_colors>
                            - if <npc.has_flag[ShopOpen]>:
                                - if !<npc.flag[ItemPrices].as_map.keys.contains[<[Chest].inventory.list_contents.filter[material.name.is[!=].to[Air]].parse[with[quantity=1]].deduplicate>]>:
                                    - narrate format:Colorize_Yellow "New shop items found! Shop closed until price verified."
                                    - flag npc ShopOpen:!
                        - flag server Meeseeks.LockedChests:<[LockedChests]>
                        - run Meeseeks_Shop def:<list_single[<list[menu/Meeseeks_Shop|action/KeyBox|npc/<npc>]>]>
            - case PreviewClick ShopClick:
                - if <npc.owner> != <player>:
                    - choose <[Click]>:
                        - case Left:
                            - define Quantity 1
                        - case right:
                            - define Quantity 10
                        - case Shift_Left Shift_Right:
                            - define Quantity 64
                        - default:
                            - stop

                    - define Item <player.open_inventory.slot[<[Slot]>]>
                    - define StackQuantity <[Item].quantity>
                # @ ██ [ Check Player Coins ] ██
                    - if <player.money> < <[StackQuantity].mul[<[Price]>]>:
                    #- if <player.flag[Behrry.Economy.Coins]> < <[StackQuantity].mul[<[Price]>]>:
                        - narrate format:Colorize_Red "Not enough coin."
                        - stop

                # @ ██ [ Check Player Space ] ██
                    - define StrippedItem <[Item].with[remove_nbt=<[Item].nbt_keys>;lore=]>
                    - if <[StackQuantity]> > <[Quantity]>:
                        - define TakeQuantity <[Quantity]>
                        - take from:<player.open_inventory> slot:<[Slot]> quantity:<[TakeQuantity]>
                    - else:
                        - define TakeQuantity <[StackQuantity]>

                # @ ██ [ Check player inventory size ] ██
                    - if !<player.inventory.can_fit[<[StrippedItem].with[quantity=<[TakeQuantity]>]>]>:
                        - repeat <[TakeQuantity]>:
                            - if <player.inventory.can_fit[<[StrippedItem].with[quantity=<[TakeQuantity].sub[<[Value]>]>]>]>:
                                - define TakeQuantity <[TakeQuantity].sub[<[Value]>]>
                                - repeat stop
                            - else if <[Value]> == <[TakeQuantity]>:
                                - narrate format:Colorize_Red "Not enough space."
                                - stop
                    - define TotalPrice <[Price].mul[<[TakeQuantity]>]>

                    - money take quantity:<[TotalPrice]>
                    - money give quantity:<[TotalPrice]> players:<npc.owner>
                    #- flag player Behrry.Economy.Coins:-:<[TotalPrice]>
                    #- flag <npc.owner> Behrry.Economy.Coins:+:<[TotalPrice]>
                    
                    - take <[StrippedItem]> quantity:<[TakeQuantity]> from:<[Origin].as_location.inventory>
                    - if <[Origin].as_location.inventory.is_empty>:
                        #$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                        - run Chest_Unlock_Task def:<[Origin]>
                    - if <[StrippedItem].has_display>:
                        - narrate "<&e>You bought<&6>: <&6>[<&a><[TakeQuantity]><&2>x<&6>] <&a><[StrippedItem].display><&e> <&e>for<&6>: <&6>[<&a><[TotalPrice]> coins<&6>]"
                    - else:
                        - narrate "<&e>You bought<&6>: <&6>[<&a><[TakeQuantity]><&2>x<&6>] <&a><[StrippedItem].material.name.replace[_].with[ ]> <&e>for<&6>: <&6>[<&a><[TotalPrice]> coins<&6>]"
                    - give <[StrippedItem]> quantity:<[TakeQuantity]>
                    - if  <[StackQuantity]> != <[TakeQuantity]>:
                        - inject locally PricedItemLore
                        - inventory adjust d:<player.open_inventory> slot:<[Slot]> lore:<[Lore]>
                    - else:
                        - inventory set d:<player.open_inventory> slot:<[Slot]> o:blank


            - case ManageClick:
                    - define Item <player.open_inventory.slot[<[Slot]>].with[lore=;remove_nbt=menu|action|npc|Price].with[quantity=1]>
                    - if !<player.has_flag[Behrry.Meeseeks.Shop.PriceModifier]>:
                        - flag player Behrry.Meeseeks.Shop.PriceModifier:1
                    - define Multiplier <player.flag[Behrry.Meeseeks.Shop.PriceModifier]>
                    - choose <[Click]>:
                        - case left:
                            - define Price <[Price].add[<[Multiplier].mul[1]>]>
                        - case shift_left:
                            - define Price <[Price].add[<[Multiplier].mul[10]>]>
                        - case right:
                            - define Price <[Price].sub[<[Multiplier].mul[1]>]>
                        - case shift_right:
                            - define Price <[Price].sub[<[Multiplier].mul[10]>]>
                        - case control_drop:
                            - define Price 1
                        - default:
                            - stop

                    #@ Check if price is invalid
                    - if <[Price]> < 1:
                        - stop
                    - if <[Price]> >= 2147483647:
                        - define Price 2147483647
                        
                    #@ Build Item List || Generate Inventory Contents
                    - inject locally PricedItemLore
                    - define nbt price/<[Price]>
                    - flag npc ItemPrices:<npc.flag[ItemPrices].as_map.with[<[Item]>].as[<[Price]>]>
                    - wait 1t
                    - inventory adjust d:<player.open_inventory> slot:<[Slot]> lore:<[Lore]>
                    - inventory adjust d:<player.open_inventory> slot:<[Slot]> nbt:<[nbt]>


    AuraClear:
        - if <npc.has_flag[RadiusAura]>:
            - if <queue.exists[<npc.flag[RadiusAura]>]>:
                - queue <queue[<npc.flag[RadiusAura]>]> clear
    Color:
        - if <npc.has_flag[ShopOpen]>:
            - define c <&a>
            - define HelpMaterial emerald_block
            - define BackProperty JUMP
        - else:
            - define c <&c>
            - define HelpMaterial redstone_block
            - define BackProperty INSTANT_HEAL
    Help:
        - choose <[HelpSlot]>:
            - case 1:
                - define Help "<item[action_item2].with[material=<[HelpMaterial]>;enchantments=silk_touch,1;hides=all;display_name=<&3><&m>   <&b><&m>      <[c]><&lb> <&b>S<&3>hop <&b>H<&3>elp <[c]><&rb><&b><&m>      <&3><&m>   ;lore=<empty>|<&7>Place Chests within <&3>4<&7> blocks|<&3>Left<&b>-<&3>Click <&7>for radius aura.|<&3>Right<&b>-<&3>Click <&7>to lock chests;nbt=menu/Meeseeks_Shop|action/RadiusControl|npc/<npc>]>"
            - case 2:
                - define Help "<item[BlankClear].with[material=<[HelpMaterial]>;enchantments=silk_touch,1;hides=all;display_name=<&b><&m>      <[c]><&lb> <&b>S<&3>hop <&b>H<&3>elp <[c]><&rb><&b><&m>      ;lore=<empty>|<&3>Left<&b>-<&3>Click<&b>: <&a>Buy <&e>1|<&3>Right<&b>-<&3>Click<&b>: <&a>Buy <&e>10|<&3>Shift<&b>-<&3>Click<&b>: <&a>Buy <&e>Stack]>"
            - case 3:
                - if !<player.has_flag[Behrry.Meeseeks.Shop.PriceModifier]>:
                    - flag player Behrry.Meeseeks.Shop.PriceModifier:1
                - define pD <element[<&sp>].repeat[<player.flag[Behrry.Meeseeks.Shop.PriceModifier].length>]>
                - if <[x]> == 1:
                    - define LoreSet "<&3>Multiplier<&b>-<&6>[<&e>1<&6>]<&b>: <&2>+<&a><[x].format_number.replace[,].with[<&2>,<&a>]>x Coin"
                - else:
                    - define LoreSet "<&3>Multiplier<&b>-<&6>[<&e><[x].log[10].round_up.add[1]><&6>]<&b>: <&2>+<&a><[x].div[1000].mul[1000].format_number.replace[,].with[<&2>,<&a>]><&2>x <&a>Coins"
                - define Help "<item[BlankClear].with[material=<[HelpMaterial]>;enchantments=silk_touch,1;hides=all;display_name=<&b><&m><[pD]>      <[c]><&lb> <&b>S<&3>hop <&b>H<&3>elp <[c]><&rb><&b><&m><[pD]>      ;lore=<empty>|<&b><&m><[pD]>     <[c]><&lb> <&b>C<&3>lick <&b>A<&3>ctions <[c]><&rb><&b><&m><[pD]>     |<&3>Left<&b>-<&3>Click<&b>: <&2>+<&a><[x].format_number.replace[,].with[<&2>,<&a>]> Coin|<&3>Shift<&b>+<&3>Left<&b>-<&3>Click<&b>: <&2>+<&a><[x].mul[10].format_number.replace[,].with[<&2>,<&a>]> Coins|<&3>Right<&b>-<&3>Click<&b>: <&4>-<&c><[x].format_number.replace[,].with[<&4>,<&c>]> Coins|<&3>Shift<&b>+<&3>Right<&b>-<&3>Click<&b>: <&4>-<&c><[x].mul[10].format_number.replace[,].with[<&4>,<&c>]> Coins|<&3>Ctrl<&b>+<&e>Q<&b>: <&c>reset price|<empty>|<&b><&m><[pD]>    <[c]><&lb> <&b>P<&3>rice <&b>M<&3>ultiplier <[c]><&rb><&b><&m><[pD]>    |<&3>Number<&b>-<&3>key<&b>-<&e>1<&b>: <&a><[x].format_number.replace[,].with[<&2>,<&a>]><&2>x <&a>Coin|<&3>Number<&b>-<&3>key<&b>-<&e>2<&b>: <&a><[x].mul[10].format_number.replace[,].with[<&2>,<&a>]><&2>x <&a>Coins|<&3>Number<&b>-<&3>key<&b>-<&e>3<&b>: <&a><[x].mul[100].format_number.replace[,].with[<&2>,<&a>]><&2>x <&a>Coins|<&3>Number<&b>-<&3>key<&b>-<&e>4<&b>: <&a><[x].mul[1000].format_number.replace[,].with[<&2>,<&a>]><&2>x <&a>Coins|<empty>|<&b><&m><[pD]>   <[c]><&lb> <&b>C<&3>urrent <&b>M<&3>ultiplier<&b>: <[c]><&rb><&b><&m><[pD]>   |<[LoreSet]>]>"
            - case 4:
                - define Help "<item[action_item2].with[material=<[HelpMaterial]>;enchantments=silk_touch,1;hides=all;display_name=<&3><&m>   <&b><&m>      <[c]><&lb> <&b>S<&3>hop <&b>H<&3>elp <[c]><&rb><&b><&m>      <&3><&m>   ;lore=<empty>|<&7>Place Chests within <&3>4<&7> blocks|<&3>Left<&b>-<&3>Click <&7>for radius aura.|<&3>Right<&b>-<&3>Click <&7>to lock chests;nbt=menu/Meeseeks_Shop|action/RadiusControl|npc/<npc>]>"
    ArrowKeys:
        - define Size <[PreCount].div[9].round_up.mul[9].max[9].min[36]>
        - inject locally Color
        - if <[PreCount]> > <[Size]> && <[Page]> != 1:
            - define ArrowSlot1 "<item[Action_Item2].with[material=tipped_arrow;potion_effects=<[BackProperty]>,true,false;display_name=<&b><&m>    <[c]><&lb> <&b>P<&3>revious <&b>P<&3>age<[c]><&rb><&b><&m>    ;lore=<empty>|<&3>Click <&7>for previous page.;nbt=menu/Meeseeks_Shop|page/<[page].sub[1]>|action/<[Action]>|npc/<npc>;hides=all;enchantments=silk_touch,1]>"
        - else:
            - define ArrowSlot1 <item[Blank]>
        - if <[PreCount]> > <[Size].mul[<[Page]>]>:
            - define ArrowSlot2 "<item[Action_Item2].with[material=tipped_arrow;potion_effects=<[BackProperty]>,true,false;display_name=<&b><&m>    <[c]><&lb> <&b>N<&3>ext <&b>P<&3>age<[c]><&rb><&b><&m>    ;lore=<empty>|<&3>Click <&7>for next page.;nbt=menu/Meeseeks_Shop|page/<[page].add[1]>|action/<[Action]>|npc/<npc>;hides=all;enchantments=silk_touch,1]>"
        - else:
            - define ArrowSlot2 <item[Blank]>
    ChestRadius:
        - repeat 3:
            - define ChestsNear:|:<npc.location.add[0,<[Value]>,0].find.blocks[chest|barrel|trapped_chest].within[4]>
        - if !<server.has_flag[Meeseeks.LockedChests]>:
            - flag server Meeseeks.LockedChests:->:<map[<empty>/<empty>]>
        - define LockedChests <server.flag[Meeseeks.LockedChests].as_map>
        - foreach <[ChestsNear].deduplicate> as:Chest:
            - if <[LockedChests].keys.contains[<[Chest].simple>]>:
                - if <[LockedChests].get[<[Chest].simple>].first> != <npc.id>:
                    - foreach next
            - if <[Chest].material.half||invalid> != invalid:
                - if <[LockedChests].keys.contains[<[Chest].add[<[Chest].material.relative_vector>].simple>]>:
                    - if <[ChestList].contains[<[Chest].add[<[Chest].material.relative_vector>]>]||false> || <[LockedChests].get[<[Chest].add[<[Chest].material.relative_vector>].simple>].first> != <npc.id>:
                        - foreach next
            - define ChestList:->:<[Chest]>

    PricedItemLore:
        - if <[Action]> == PreviewClick:
            - wait 1t
            - define ItemPrices <npc.flag[ItemPrices].as_map>
            - if <player.open_inventory.slot[<[Slot]>].has_script>:
                - if <player.open_inventory.slot[<[Slot]>].scriptname> == blank:
                    - stop
            - define Item <[StrippedItem].with[quantity=<[StackQuantity].sub[<[TakeQuantity]>]>]>
        - if <list[Preview|PreviewClick|Manage|Shop].contains[<[Action]>]>:
            - if !<[ItemPrices].keys.contains[<[Item].with[quantity=1]>]>:
                - define ItemPrices <[ItemPrices].with[<[Item].with[quantity=1]>].as[1]>
                - flag npc ItemPrices:<npc.flag[ItemPrices].as_map.with[<[Item]>].as[1]>
            - define Price <[ItemPrices].get[<[Item].with[quantity=1]>]>

        - choose <[Action]>:
            - case Shop Preview PreviewClick:
                - define Lore "<list[<empty>|<&3><&m>   <&6>[ <&b>C<&3>lick to <&b>B<&3>uy <&6>]<&b><&m>   ]>"
                - if <[Item].quantity> > 1:
                    - define Lore "<[Lore].include[<&e>Item Price<&6>: <&a><[Price]> Coins|<&e>Total Price<&6>: <&a><[Price].mul[<[Item].quantity>]> Coins]>"
                - else:
                    - define lore "<[Lore].include[<&e>Item Price<&6>: <&a><[Price]> Coins]>"
            - case Manage ManageClick:
                - define "Lore:!|:<empty>|<&3><&m>   <&6>[ <&b>C<&3>lick to <&b>A<&3>djust <&6>]<&3><&m>   "
                - if <[Item].max_stack> > 1:
                    - define "Lore:->:<&e>Item Price<&6>: <&a><[Price].format_number> Coins"
                    - define "Lore:->:<&e>Price <&6>(<&e>10x<&6>): <&a><[Price].mul[10].format_number> Coins"
                    - define "Lore:->:<&e>Price <&6>(<&e><[Item].max_stack>x<&6>): <&a><[Price].mul[<[Item].max_stack>].format_number> Coins"
                - else:
                    - define "Lore:->:<&e>Item Price<&6>: <&a><[Price].format_number> Coins"
    InventoryCache:
        - flag npc ActiveUsers:->:<player>
        - if <npc.flag[ActiveUsers].size> > 1 && <inventory[Meeseeks_Inventory_<npc.id>_<[Action]>]||invalid> != invalid:
            - inventory open d:<inventory[Meeseeks_Inventory_<npc.id>_<[Action]>]>
            - stop




#| PlayBook - - - - Debug Process - - |#
#% - Buy a Meeseeks from Bawb

#% - try to steal the box
#%   - store it in a chest
#%   - craft with it
#%   - place it
#%   - put it in an item frame
#%   - drop it
#%   - hotbar-swap it
#%   - shift-button swap it

#%   - Place the Meeseeks in a bat environment

#%   - open shop without items or chests to sell from
#%   - open shop with chests but no items for sale
#%   - open shop with 1 item
#%   - open shop with 8 items
#%   - open shop with 9 items
#%   - open shop with 18 items
#%   - open shop with 27 items
#%   - open shop with 34 items
#%   - open shop with 35 items
#%   - open shop with 36 items
#%   - open shop with >36 items with multiples of one material
#%   - open shop with >36 *different* items
#%   - open shop with >72 *different* items


#%   - try and steal a key
#%   - store it in a chest
#%   - craft with it
#%   - place it
#%   - put it in an item frame
#%   - drop it
#%   - hotbar-swap it
#%   - shift-button swap it

#%   - try and break a locked chest
#%   - try and force a locked chest to break
#%   - try and steal from the locked chest
