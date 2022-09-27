scythe_wooden:
  type: item
  material: wooden_hoe
  display name: <&r>Wooden Scythe
  lore:
  - <&6>Current Size<&co> <&e>3
  flags:
    custom_durability:
      max: 120
      current: 0
    size: 3
    size_max: 3
  mechanisms:
    custom_model_data: 10025

scythe_stone:
  type: item
  material: iron_hoe
  display name: <&r>Iron Scythe
  lore:
  - <&6>Current Size<&co> <&e>4
  flags:
    custom_durability:
      max: 260
      current: 0
    size: 4
    size_max: 4
  mechanisms:
    custom_model_data: 10050

scythe_iron:
  type: item
  material: iron_hoe
  display name: <&r>Iron Scythe
  lore:
  - <&6>Current Size<&co> <&e>5
  flags:
    custom_durability:
      max: 500
      current: 0
    size: 5
    size_max: 5
  mechanisms:
    custom_model_data: 10075

scythe_golden:
  type: item
  material: golden_hoe
  display name: <&r>Golden Scythe
  lore:
  - <&6>Current Size<&co> <&e>6
  flags:
    custom_durability:
      max: 600
      current: 0
    size: 6
    size_max: 6
  mechanisms:
    custom_model_data: 10100

scythe_diamond:
  type: item
  material: diamond_hoe
  display name: <&r>Diamond Scythe
  lore:
  - <&6>Current Size<&co> <&e>7
  flags:
    size: 7
    size_max: 7
    custom_durability:
      max: 3000
      current: 0
  mechanisms:
    custom_model_data: 10125

scythe_netherite:
  type: item
  material: netherite_hoe
  display name: <&r>Netherite Scythe
  lore:
  - <&6>Current Size<&co> <&e>8
  flags:
    size: 8
    size_max: 8
    custom_durability:
      max: 4000
      current: 0
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
    on player left clicks block with:scythe_*:
      - determine passively cancelled
      - ratelimit <player> 1s
      - if <player.item_in_hand.flag[size]> < <script[<player.item_in_hand.script.name>].data_key[flags.size_max]>:
        - inventory flag slot:<player.held_item_slot> size:<proc[lawn_mower_proc].context[<context.item.flag[size]>]>
        - wait 1t
        - inventory adjust slot:<player.held_item_slot> "lore:<&6>Current Size<&co> <&e><player.item_in_hand.flag[size]>"
        - narrate "<&6>The size of your remover is now: <&e><player.item_in_hand.flag[size]><&6>x<&e><player.item_in_hand.flag[size]>"

      - else:
        - inventory flag slot:<player.held_item_slot> size:3
        - wait 1t
        - inventory adjust slot:<player.held_item_slot> "lore:<&6>Current Size<&co> <&e><player.item_in_hand.flag[size]>"
        - narrate "<&6>The size of your remover is now: <&e><player.item_in_hand.flag[size]><&6>x<&e><player.item_in_hand.flag[size]>"
    on player right clicks block with:scythe_*:
      - determine passively cancelled
      - ~modifyblock <context.location.relative[-<context.item.flag[size].sub[2]>,-<context.item.flag[size].sub[2]>,-<context.item.flag[size].sub[2]>].to_cuboid[<context.location.relative[<context.item.flag[size].sub[2]>,<context.item.flag[size].sub[2]>,<context.item.flag[size].sub[2]>]>].blocks[tall_grass|grass|dandelion|poppy|blue_orchid|allium|azure_bluet|red_tulip|orange_tulip|white_tulip|pink_tulip|oxeye_daisy|cornflower|lily_of_the_valley|wither_rose|sunflower|lilac|rose_bush|peony|moss_carpet|azalea|flowering_azalea]> air source:<player> naturally:<player.item_in_hand.material.name>
      - define slot <player.held_item_slot>
      - define value <context.item.flag[size].mul[<context.item.flag[size]>]>
      - inject custom_durability_process_task
