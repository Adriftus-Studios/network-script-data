sycthe_wooden:
  type: item
  material: wooden_hoe
  display name: <&r>Wooden Scythe
  flags:
    size: 3
    size_max: 3
    mechanisms:
        custom_model_data: 10025

sycthe_stone:
  type: item
  material: iron_hoe
  display name: <&r>Iron Scythe
  flags:
    size: 3
    size_max: 4
    mechanisms:
        custom_model_data: 10050

sycthe_iron:
  type: item
  material: iron_hoe
  display name: <&r>Iron Scythe
  flags:
    size: 3
    size_max: 5
    mechanisms:
        custom_model_data: 10075

sycthe_golden:
  type: item
  material: golden_hoe
  display name: <&r>Golden Scythe
  flags:
    size: 3
    size_max: 6
    mechanisms:
        custom_model_data: 10100

sycthe_diamond:
  type: item
  material: diamond_hoe
  display name: <&r>Diamond Scythe
  flags:
    size: 3
    size_max: 7
    mechanisms:
        custom_model_data: 10125

sycthe_netherite:
  type: item
  material: netherite_hoe
  display name: <&r>Netherite Scythe
  flags:
    size: 3
    size_max: 8
    mechanisms:
        custom_model_data: 10150

lawn_mower_proc:
  type: procedure
  definitions: size
  script:
  - choose <[size]>:
    - case 3:
      - determine 5
    - case 4:
      - determine 6
    - case 5:
      - determine 7
    - case 6:
      - determine 8
    - case 7:
      - determine 9
    - case 8:
      - determine 3


lawn_mower_handler:
  type: world
  events:
    on player left clicks block with:sycthe_*:
      - ratelimit <player> 1s
      - determine passively cancelled
      - if <player.item_in_hand.flag[size]> < <script[<player.item_in_hand.script.name>].data_key[flags.size_max]>:
        - inventory flag slot:<player.held_item_slot> size:<proc[lawn_mower_proc].context[<context.item.flag[size]>]>
        - wait 1t
        - narrate "<&6>The size of your remover is now: <&e><player.item_in_hand.flag[size]><&6>x<&e><player.item_in_hand.flag[size]>"
      - else:
        - inventory flag slot:<player.held_item_slot> size:3
        - wait 1t
        - narrate "<&6>The size of your remover is now: <&e><player.item_in_hand.flag[size]><&6>x<&e><player.item_in_hand.flag[size]>"
    on player right clicks block with:sycthe_*:
      - determine passively cancelled
      - modifyblock <context.location.relative[-<context.item.flag[size].sub[2]>,-<context.item.flag[size].sub[2]>,-<context.item.flag[size].sub[2]>].to_cuboid[<context.location.relative[<context.item.flag[size].sub[2]>,<context.item.flag[size].sub[2]>,<context.item.flag[size].sub[2]>]>].blocks[tall_grass|grass|dandelion|poppy|blue_orchid|allium|azure_bluet|red_tulip|orange_tulip|white_tulip|pink_tulip|oxeye_daisy|cornflower|lily_of_the_valley|wither_rose|sunflower|lilac|rose_bush|peony]> air
