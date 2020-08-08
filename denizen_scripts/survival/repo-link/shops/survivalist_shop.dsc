survivalistAssignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        on click:
        - inject survivalistInventoryInject

survivalistInventory:
    type: inventory
    inventory: chest
    title: <&2>Sur<&a>viv<&2>al<&a>ist
    definitions:
        filler: <item[white_stained_glass_pane].with[display_name=<&f>]>
        backpack_9: <item[chest].with[nbt=item/Backpack9;display_name=<&a>Backpack;lore=<&e>Slots:<&sp><&a>9|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack9.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack9.Prices].after[/]>]>
        backpack_18: <item[chest].with[nbt=item/Backpack18;display_name=<&a>Backpack;lore=<&e>Slots:<&sp><&a>18|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack18.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack18.Prices].after[/]>]>
        backpack_27: <item[chest].with[nbt=item/Backpack27;display_name=<&a>Backpack;lore=<&e>Slots:<&sp><&a>27|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack27.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack27.Prices].after[/]>]>
        backpack_36: <item[chest].with[nbt=item/Backpack36;display_name=<&a>Backpack;lore=<&e>Slots:<&sp><&a>36|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack36.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack36.Prices].after[/]>]>
        backpack_45: <item[chest].with[nbt=item/Backpack45;display_name=<&a>Backpack;lore=<&e>Slots:<&sp><&a>45|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack45.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack45.Prices].after[/]>]>
        backpack_54: <item[chest].with[nbt=item/Backpack54;display_name=<&a>Backpack;lore=<&e>Slots:<&sp><&a>54|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack54.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack54.Prices].after[/]>]>
        grappling_hook: <item[tripwire_hook].with[nbt=item/GrapplingHook;display_name=<&a>Grappling<&sp>Hook;lore=<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.GrapplingHook.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.GrapplingHook.Prices].after[/]>]>
        mushroom_home: <item[mushroom_home].with[nbt=item/MushroomHome;lore=<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.MushroomHome.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.MushroomHome.Prices].after[/]>]>
    slots:
    - [filler] [filler] [filler] [filler] [] [filler] [filler] [filler] [filler]
    - [filler] [backpack_9] [backpack_18] [backpack_27] [backpack_36] [backpack_45] [backpack_54] [grappling_hook] [filler]
    - [filler] [mushroom_home] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

survivalistInventoryInject:
    type: task
    script:
    - define inventory <inventory[survivalistInventory]>
    - give "<item[player_head].with[skull_skin=<player.skull_skin>;display_name=<&e><&o><player.name>;lore=<&a>Money: <&e><player.money>]>" to:<[inventory]> slot:5
    - inventory open d:<[inventory]>

survivalistHandler:
    type: world
    events:
        on player clicks item in survivalistInventory:
        - determine passively cancelled
        - if <context.item.has_nbt[item]>:
            - inventory set d:<player.open_inventory> o:<context.item> slot:41
            - inventory set d:<player.open_inventory> o:<item[green_wool].with[nbt=action/buy|key/<context.item.nbt[item]>;display_name=<&c>Buy<&sp>1;lore=<&a>Price:<&sp><script[survivalistData].data_key[Items.<context.item.nbt[item]>.Prices].before[/]>]> slot:51
            - inventory set d:<player.open_inventory> o:<item[red_wool].with[nbt=action/sell|key/<context.item.nbt[item]>;display_name=<&c>Sell<&sp>1;lore=<&a>Price:<&sp><script[survivalistData].data_key[Items.<context.item.nbt[item]>.Prices].after[/]>]> slot:49
            - stop
        - if <context.item.has_nbt[action]>:
            - choose <context.item.nbt[action]>:
                - case buy:
                    - if <player.money> >= <script[survivalistData].data_key[Items.<context.item.nbt[key]>.Prices].before[/]>:
                        - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
                        - give <script[survivalistData].parsed_key[Items.<context.item.nbt[key]>.Item]>
                        - money take quantity:<script[survivalistData].data_key[Items.<context.item.nbt[key]>.Prices].before[/]>
                        - inventory set "o:<item[player_head].with[skull_skin=<player.skull_skin>;display_name=<&e><&o><player.name>;lore=<&a>Money: <&e><player.money>]>" to:<player.open_inventory> slot:5
                    - else:
                        - narrate "<&c>You don't have enough money"
                        - playsound <player> sound:ENTITY_VILLAGER_NO volume:0.6 pitch:1.4
                - case sell:
                    - if <player.inventory.list_contents.filter[has_nbt[backpack_slots]].filter[nbt[backpack_slots].is[==].to[<context.item.nbt[key].after[Backpack]>]].size> > 0:
                        - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
                        - take slot:<player.inventory.find[<player.inventory.list_contents.filter[has_nbt[backpack_slots]].filter[nbt[backpack_slots].is[==].to[<context.item.nbt[key].after[Backpack]>]].first>]>
                        - money give quantity:<script[survivalistData].data_key[Items.<context.item.nbt[key]>.Prices].after[/]>
                        - inventory set "o:<item[player_head].with[skull_skin=<player.skull_skin>;display_name=<&e><&o><player.name>;lore=<&a>Money: <&e><player.money>]>" to:<player.open_inventory> slot:5
                    - else:
                        - narrate "<&c>You don't have enough money"
            - stop

survivalistData:
    type: data
    Items:
        Backpack9:
            Item: <item[Backpack]>
            Prices: 500/300
        Backpack18:
            Item: "<item[chest].with[nbt=backpack_slots/18|backpack_contents/<list>|unique/<server.current_time_millis>;display_name=<&a>Backpack;lore=<&e>Slots<&co> <&a>18|<&a>|<&e>Hold in Hand|<&b>Place block to open]>"
            Prices: 700/500
        Backpack27:
            Item: "<item[chest].with[nbt=backpack_slots/27|backpack_contents/<list>|unique/<server.current_time_millis>;display_name=<&a>Backpack;lore=<&e>Slots<&co> <&a>27|<&a>|<&e>Hold in Hand|<&b>Place block to open]>"
            Prices: 900/700
        Backpack36:
            Item: "<item[chest].with[nbt=backpack_slots/36|backpack_contents/<list>|unique/<server.current_time_millis>;display_name=<&a>Backpack;lore=<&e>Slots<&co> <&a>36|<&a>|<&e>Hold in Hand|<&b>Place block to open]>"
            Prices: 1100/900
        Backpack45:
            Item: "<item[chest].with[nbt=backpack_slots/45|backpack_contents/<list>|unique/<server.current_time_millis>;display_name=<&a>Backpack;lore=<&e>Slots<&co> <&a>45|<&a>|<&e>Hold in Hand|<&b>Place block to open]>"
            Prices: 1300/1100
        Backpack54:
            Item: "<item[chest].with[nbt=backpack_slots/54|backpack_contents/<list>|unique/<server.current_time_millis>;display_name=<&a>Backpack;lore=<&e>Slots<&co> <&a>54|<&a>|<&e>Hold in Hand|<&b>Place block to open]>"
            Prices: 1500/1300
        GrapplingHook:
            Item: <item[grappling_hook]>
            Prices: 100/50
        MushroomHome:
            Item: <item[mushroom_home].with[nbt=owner/<player.uuid>]>
            Prices: 2000/1500
