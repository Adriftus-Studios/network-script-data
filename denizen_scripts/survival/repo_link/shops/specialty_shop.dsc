specialty_shop_assignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        on click:
        - define inventory <inventory[specialtyInventory]>
        - if <player.has_flag[teleportation_recipe]>:
            - define item <item[teleportation_shard].with[nbt=item/Teleportation_Shard;lore=<&a>Buy<&sp>Price:<&sp><&e><script[specialtyData].data_key[Items.Teleportation_Shard.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[specialtyData].data_key[Items.Teleportation_Shard.Prices].after[/]>]>
            - give <[item]> to:<[inventory]>
        - inventory open d:<[inventory]>

specialtyInventory:
    type: inventory
    inventory: chest
    title: Specialty Shop
    definitions:
        filler: white_stained_glass_pane[display_name=<&f>]
        head: <item[player_head].with[skull_skin=<player.skull_skin>;display_name=<&e><&o><player.display_name>;lore=<&a>Money:<&sp><&e><player.money>]>
    slots:
    - [filler] [filler] [filler] [filler] [head] [filler] [filler] [filler] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

specialtyHandler:
    type: world
    events:
        on player clicks item in specialtyInventory:
        - determine passively cancelled
        - if <context.item.has_nbt[item]>:
            - inventory set d:<player.open_inventory> o:<context.item> slot:41
            - inventory set d:<player.open_inventory> o:<item[green_wool].with[nbt=action/buy|key/<context.item.nbt[item]>;display_name=<&c>Buy<&sp>1;lore=<&c>Price:<&sp><script[specialtyData].data_key[Items.<context.item.nbt[item]>.Prices].before[/]>]> slot:51
            - inventory set d:<player.open_inventory> o:<item[green_wool].with[nbt=action/buy|key/<context.item.nbt[item]>;display_name=<&c>Buy<&sp>32;lore=<&c>Price:<&sp><script[specialtyData].data_key[Items.<context.item.nbt[item]>.Prices].before[/].mul[32]>;quantity=32]> slot:52
            - inventory set d:<player.open_inventory> o:<item[green_wool].with[nbt=action/buy|key/<context.item.nbt[item]>;display_name=<&c>Buy<&sp>64;lore=<&c>Price:<&sp><script[specialtyData].data_key[Items.<context.item.nbt[item]>.Prices].before[/].mul[64]>;quantity=64]> slot:53
            - inventory set d:<player.open_inventory> o:<item[red_wool].with[nbt=action/sell|key/<context.item.nbt[item]>;display_name=<&a>Sell<&sp>1;lore=<&a>Price:<&sp><script[specialtyData].data_key[Items.<context.item.nbt[item]>.Prices].after[/]>]> slot:49
            - inventory set d:<player.open_inventory> o:<item[red_wool].with[nbt=action/sell|key/<context.item.nbt[item]>;display_name=<&a>Sell<&sp>32;lore=<&a>Price:<&sp><script[specialtyData].data_key[Items.<context.item.nbt[item]>.Prices].after[/].mul[32]>;quantity=32]> slot:48
            - inventory set d:<player.open_inventory> o:<item[red_wool].with[nbt=action/sell|key/<context.item.nbt[item]>;display_name=<&a>Sell<&sp>64;lore=<&a>Price:<&sp><script[specialtyData].data_key[Items.<context.item.nbt[item]>.Prices].after[/].mul[64]>;quantity=64]> slot:47
            - stop
        - else if <context.item.has_nbt[action]>:
            - choose <context.item.nbt[action]>:
                - case buy:
                    - if <player.money> >= <script[specialtyData].data_key[Items.<context.item.nbt[key]>.Prices].before[/].mul[<context.item.quantity>]>:
                        - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
                        - give <script[specialtyData].parsed_key[Items.<context.item.nbt[key]>.Item]> quantity:<context.item.quantity>
                        - money take quantity:<script[specialtyData].data_key[Items.<context.item.nbt[key]>.Prices].before[/].mul[<context.item.quantity>]>
                        - inventory adjust slot:5 "lore:<&a>Money<&co> <&e><player.money>" d:<player.open_inventory>
                    - else:
                        - narrate "<&c>You don't have enough money"
                        - playsound <player> sound:ENTITY_VILLAGER_NO volume:0.6 pitch:1.4
                - case sell:
                    - if <player.inventory.contains.scriptname[<context.item.nbt[key]>]>:
                        - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
                        - take scriptname:<context.item.nbt[key]> quantity:<context.item.quantity.min[<player.inventory.quantity[<context.item>]>]>
                        - money give quantity:<script[specialtyData].data_key[Items.<context.item.nbt[key]>.Prices].after[/].mul[<context.item.quantity>].min[<player.inventory.quantity[<context.item>]>]>
                        - inventory adjust slot:5 "lore:<&a>Money<&co> <&e><player.money>" d:<player.open_inventory>
                    - else:
                        - narrate "<&c>You don't have the specified item!"

specialtyData:
    type: data
    Items:
        Teleportation_Shard:
            Item: <item[teleportation_shard]>
            Prices: 500/250
