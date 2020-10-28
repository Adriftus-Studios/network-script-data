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
        backpack_9: <item[Backpack_9].with[nbt=item/Backpack_9;lore=<&e>Slots:<&sp><&a>9|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack_9.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack_9.Prices].after[/]>]>
        backpack_18: <item[Backpack_18].with[nbt=item/Backpack_18;lore=<&e>Slots:<&sp><&a>18|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack_18.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack_18.Prices].after[/]>]>
        backpack_27: <item[Backpack_27].with[nbt=item/Backpack_27;lore=<&e>Slots:<&sp><&a>27|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack_27.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack_27.Prices].after[/]>]>
        backpack_36: <item[Backpack_36].with[nbt=item/Backpack_36;lore=<&e>Slots:<&sp><&a>36|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack_36.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack_36.Prices].after[/]>]>
        backpack_45: <item[Backpack_45].with[nbt=item/Backpack_45;lore=<&e>Slots:<&sp><&a>45|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack_45.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack_45.Prices].after[/]>]>
        backpack_54: <item[Backpack_54].with[nbt=item/Backpack_54;lore=<&e>Slots:<&sp><&a>54|<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Backpack_54.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Backpack_54.Prices].after[/]>]>
        grappling_hook: <item[grappling_hook].with[nbt=item/Grappling_Hook;lore=<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Grappling_Hook.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Grappling_Hook.Prices].after[/]>]>
        mushroom_home: <item[mushroom_home].with[nbt=item/Mushroom_Home;lore=<&a>Buy<&sp>Price:<&sp><&e><script[survivalistData].data_key[Items.Mushroom_Home.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[survivalistData].data_key[Items.Mushroom_Home.Prices].after[/]>]>
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
    - give "<item[player_head].with[skull_skin=<player.skull_skin>;display_name=<&e><&o><player.display_name>;lore=<&a>Money: <&e><player.money>]>" to:<[inventory]> slot:5
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
                    - if <player.inventory.contains.scriptname[<context.item.nbt[key]>]>:
                    # - if <player.inventory.list_contents.filter[has_nbt[backpack_slots]].filter[nbt[backpack_slots].is[==].to[<context.item.nbt[key].after[Backpack]>]].size||0> > 0 || <player.inventory.contains[<script[survivalistData].parsed_key[Items.<context.item.nbt[key]>.Item]>]>:
                        - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
                        - take slot:<player.inventory.find.scriptname[<context.item.nbt[key]>]>
                        - money give quantity:<script[survivalistData].data_key[Items.<context.item.nbt[key]>.Prices].after[/]>
                        - inventory set "o:<item[player_head].with[skull_skin=<player.skull_skin>;display_name=<&e><&o><player.display_name>;lore=<&a>Money: <&e><player.money>]>" to:<player.open_inventory> slot:5
                    - else:
                        - narrate "<&c>You don't have the specified item!"
            - stop

survivalistData:
    type: data
    Items:
        Backpack_9:
            Item: <item[Backpack_9]>
            Prices: 500/300
        Backpack_18:
            Item: <item[Backpack_18]>
            Prices: 700/500
        Backpack_27:
            Item: <item[Backpack_27]>
            Prices: 900/700
        Backpack_36:
            Item: <item[Backpack_36]>
            Prices: 1100/900
        Backpack_45:
            Item: <item[Backpack_45]>
            Prices: 1300/1100
        Backpack_54:
            Item: <item[Backpack_54]>
            Prices: 1500/1300
        Grappling_Hook:
            Item: <item[grappling_hook]>
            Prices: 5000/1500
        Teleportation_Shard:
            Item: <item[teleportation_shard]>
            Prices: 500/250
        Mushroom_Home:
            Item: <item[mushroom_home].with[nbt=owner/<player.uuid>]>
            Prices: 2000/1500
