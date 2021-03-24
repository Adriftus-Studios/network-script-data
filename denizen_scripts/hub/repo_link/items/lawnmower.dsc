lawn_mower_item:
    type: item
    material: wooden_hoe
    display name: <&a>Lawn Mower
    flags:
        size: 3

lawn_mower_cmd:
    type: command
    name: lawnmower
    usage: /lawnmower
    description: Gets the flower removing wand
    permission: adriftus.staff
    script:
    - give lawn_mower_item

lawn_mower_proc:
    type: procedure
    definitions: size
    script:
    - choose <[size]>:
        - case 3:
            - determine 5
        - case 5:
            - determine 7
        - case 7:
            - determine 9
        - case 9:
            - determine 3

lawn_mower_handler:
    type: world
    events:
        on player left clicks block with:lawn_mower_item:
        - ratelimit <player> 1s
        - determine passively cancelled
        - inventory flag slot:<player.held_item_slot> size:<proc[lawn_mower_proc].context[<context.item.flag[size]>]>
        - narrate "<&a>The size of your remover is now: <player.item_in_hand.flag[size]>x<player.item_in_hand.flag[size]>"
        on player right clicks block with:lawn_mower_item:
        - determine passively cancelled
        - modifyblock <context.location.relative[-<context.item.flag[size].sub[2]>,-<context.item.flag[size].sub[2]>,-<context.item.flag[size].sub[2]>].to_cuboid[<context.location.relative[<context.item.flag[size].sub[2]>,<context.item.flag[size].sub[2]>,<context.item.flag[size].sub[2]>]>].blocks[tall_grass|grass|dandelion|poppy|blue_orchid|allium|azure_bluet|red_tulip|orange_tulip|white_tulip|pink_tulip|oxeye_daisy|cornflower|lily_of_the_valley|wither_rose|sunflower|lilac|rose_bush|peony]> air
