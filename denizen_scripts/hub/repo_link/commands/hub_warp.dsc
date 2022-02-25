warps_main_command:
    type: command
    name: warp
    description: A command used to access warps created around the hub
    usage: /warp
    aliases:
    - warps
    tab completions:
        1: Crates|Spawn|Towny|Shops
    script:
        - if <context.args.size> > 0:
            - run hub_warp_to def:<player>|<context.args.get[1]>
        - else:
            - define inventory <inventory[hub_warp_inventory]>
            - inventory open d:<[inventory]>

hub_warp_inventory:
  type: inventory
  inventory: chest
  size: 27
  title: <&f><&font[adriftus:guis]><&chr[F808]><&chr[6909]>
  gui: true
  definitions:
    f: <item[standard_filler]>
  slots:
  - [] [] [] [] [] [] [] [] []
  - [] [hub_warp_spawn_icon] [hub_warp_spawn_icon] [hub_warp_spawn_icon] [] [hub_warp_crates_icon] [hub_warp_crates_icon] [hub_warp_crates_icon] []
  - [] [hub_warp_towny_icon] [hub_warp_towny_icon] [hub_warp_towny_icon] [] [hub_warp_shops_icon] [hub_warp_shops_icon] [hub_warp_shops_icon] []

hub_warp_inventory_events:
  type: world
  events:
    on player clicks in hub_warp_inventory:
    - if <context.item.script.data_key[data.warp].exists>:
      - define warp <context.item.script.data_key[data.warp]>
      - run hub_warp_to def:<player>|<[warp]>
      - inventory close

hub_warp_to:
    type: task
    definitions: player|warpName
    script:
        - if <location[hub_warp_<[warpName]>].exists>:
            - teleport <[player]> hub_warp_<[warpName]>
            - playsound <[player]> sound:ENTITY_ENDERMAN_TELEPORT
            - playeffect effect:PORTAL at:<player.location> visibility:500 quantity:500 offset:1.0
            - actionbar "<proc[reverse_color_gradient].context[Teleporting to <[warpName]>|#6DD5FA|#FFFFFF]>"
        - else:
            - narrate "Invalid warp name"

reverse_color_gradient:
    type: procedure
    definitions: text|hex1|hex2
    script:
        - define firstHalf <[text].substring[1,<[text].length.div_int[2].sub[1]>]>
        - define secondHalf <[text].substring[<[text].length.div_int[2]>,<[text].length>]>
        - determine <[firstHalf].color_gradient[from=<[hex1]>;to=<[hex2]>]><[secondHalf].color_gradient[from=<[hex2]>;to=<[hex1]>]>

hub_warp_crates_icon:
  type: item
  material: chest
  data:
    warp: crates
  display name: "<&6><&l>Crates"
  lore:
    - <&r><&7>Try your luck in in some loot crates!
    - <&r><&7>Lots of prizes available including
    - <&r><&7>cosmetics and more!
    - <&r>
    - <&r><element[➤ Click to Warp].color_gradient[from=#af782b;to=#ffa832]>

hub_warp_spawn_icon:
  type: item
  material: grass_block
  data:
    warp: spawn
  display name: "<&a><&l>Spawn"
  lore:
    - <&r><&7>This is where you're journey begins!
    - <&r><&7>Teleports you back to the spawn in
    - <&r><&7>the hub!
    - <&r>
    - <&r><element[➤ Click to Warp].color_gradient[from=#57854b;to=#64b74e]>

hub_warp_towny_icon:
  type: item
  material: bookshelf
  data:
    warp: towny
  display name: "<&e><&l>Towny"
  lore:
    - <&r><&7>Join us in the world's greatest Towny server!
    - <&r><&7>A truly custom experience, fit only
    - <&r><&7>for the strongest of towny players!
    - <&r>
    - <&r><element[➤ Click to Warp].color_gradient[from=#dab92f;to=#fee98f]>

hub_warp_shops_icon:
  type: item
  material: crafting_table
  data:
    warp: shop
  display name: "<&4><&l>Shops"
  lore:
    - <&r><&7>Come here to waste your money!
    - <&r><&7>We have cosmetics, ranks, and more only
    - <&r><&7>for the players who truly want to show off!
    - <&r>
    - <&r><element[➤ Click to Warp].color_gradient[from=#7c1212;to=#e13838]>