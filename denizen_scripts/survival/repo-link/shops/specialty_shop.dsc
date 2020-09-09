specialty_shop_assignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        on click:
        - define inventory <inventory[specialtyInventory]>
        - inventory open d:<[inventory]>

specialtyInventory:
    type: inventory
    inventory: chest
    title: Specialty Shop
    definitions:
        filler: <item[white_stained_glass_pane].with[display_name=<&f>]>
        head: <item[player_head].with[skull_skin=<player.skull_skin>;display_name=<&e><&o><player.display_name>;lore=<&a>Money: <&e><player.money>]>
    procedural items:
    - if <player.has_flag[teleportation_recipe]>:
        - define item <item[teleportation_shard].with[nbt=item/Teleportation_Shard;lore=<&a>Buy<&sp>Price:<&sp><&e><script[specialtyData].data_key[Items.Teleportation_Shard.Prices].before[/]>|<&c>Sell<&sp>Price:<&sp><script[specialtyData].data_key[Items.Teleportation_Shard.Prices].after[/]>]>
        - determine <list[<[item]>]>
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
            - inventory set d:<player.open_inventory> o:<item[green_wool].with[nbt=action/buy|key/<context.item.nbt[item]>;display_name=<&c>Buy<&sp>1;lore=<&a>Price:<&sp><script[specialtyData].data_key[Items.<context.item.nbt[item]>.Prices].before[/]>]> slot:51
            - inventory set d:<player.open_inventory> o:<item[red_wool].with[nbt=action/sell|key/<context.item.nbt[item]>;display_name=<&c>Sell<&sp>1;lore=<&a>Price:<&sp><script[specialtyData].data_key[Items.<context.item.nbt[item]>.Prices].after[/]>]> slot:49
            - stop
        - if <context.item.has_nbt[action]>:
            - choose <context.item.nbt[action]>:
                - case buy:
                    - if <player.money> >= <script[specialtyData].data_key[Items.<context.item.nbt[key]>.Prices].before[/]>:
                        - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
                        - give <script[specialtyData].parsed_key[Items.<context.item.nbt[key]>.Item]>
                        - money take quantity:<script[specialtyData].data_key[Items.<context.item.nbt[key]>.Prices].before[/]>
                        - give "<item[player_head].with[skull_skin=<player.skull_skin>;display_name=<&e><&o><player.name>;lore=<&a>Money: <&e><player.money>]>" to:<player.open_inventory> slot:5
                    - else:
                        - narrate "<&c>You don't have enough money"
                        - playsound <player> sound:ENTITY_VILLAGER_NO volume:0.6 pitch:1.4
                - case sell:
                    - if <player.inventory.contains.scriptname[<context.item.nbt[key]>]>:
                        - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
                        - take slot:<player.inventory.find.scriptname[<context.item.nbt[key]>]>
                        - money give quantity:<script[specialtyData].data_key[Items.<context.item.nbt[key]>.Prices].after[/]>
                        - give "<item[player_head].with[skull_skin=<player.skull_skin>;display_name=<&e><&o><player.display_name>;lore=<&a>Money: <&e><player.money>]>" to:<player.open_inventory> slot:5
                    - else:
                        - narrate "<&c>You don't have the specified item!"

specialtyData:
    type: data
    Items:
        Teleportation_Shard:
            Item: <item[teleportation_shard]>
            Prices: 500/250
