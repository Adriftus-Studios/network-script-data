store_hub_cosmeticShop_assignment:
  type: assignment
  debug: false
  actions:
    on assignment:
    - trigger name:click state:true
    - trigger name:damage state:true
    on damage:
    - inventory open d:store_hub_cosmeticShop
    on click:
    - inventory open d:store_hub_cosmeticShop

store_hub_cosmeticShop:
  type: inventory
  inventory: chest
  debug: false
  size: 27
  title: <&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&5>S<&d>h<&5>o<&d>p
  definitions:
    filler: <item[store_hub_cosmeticShop_filler]>
  procedural items:
    - foreach <list[titles|bowTrails]>:
      - define list:->:<item[store_hub_cosmeticShop_<[value]>]>
    - determine <[list]>
  slots:
  - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
  - [filler] [filler] [filler] [] [filler] [] [filler] [filler] [filler]
  - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

store_hub_cosmeticShop_filler:
  type: item
  material: glass_pane
  display name: <&b>
  enchantments:
  - damage_all:1
  mechanisms:
    hides: all

store_hub_cosmeticShop_filler_events:
  type: world
  events:
    on player clicks store_hub_cosmeticShop_filler in inventory bukkit_priority:LOWEST:
      - determine cancelled

store_hub_cosmeticShop_titles:
  type: item
  material: name_tag
  display name: <&6>Titles
  enchantments:
  - damage_all:1
  lore:
  - <&e>Buy some fancy <&6>Titles<&e> to show off.
  - <&e>Claim these anywhere, they go above your nameplate.
  - <&e>Titles are network wide, and can be accessed anywhere.
  - <&e>You can access your available titles with <&b>/titles
  mechanisms:
    hides: all

store_hub_cosmeticShop_titles_inventory:
  type: inventory
  inventory: chest
  debug: false
  title: <&a>Buying <&6>Titles.
  size: 45
  definitions:
    filler: <item[store_hub_cosmeticShop_filler]>
  slots:
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
    - [filler] [filler] [] [filler] [] [filler] [] [filler] [filler]
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
    - [filler] [filler] [] [filler] [] [filler] [] [filler] [filler]
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]

store_hub_cosmeticShop_title_open:
  type: task
  script:
    - define inventory <inventory[store_hub_cosmeticShop_titles_inventory]>
    - foreach <server.flag[cosmetics_titles_today]> as:tag:
      - if <yaml[global.player.<player.uuid>].read[titles.unlocked].contains[<[tag]>]||false>:
        - define lore "<&c>You already own this title.|<&a>Price<&co><&sp>300<&sp><&b>ⓐ"
      - else:
        - define lore <&a>Price<&co><&sp>300<&sp><&b>ⓐ
      - define item <item[name_tag]>[nbt=<list[price/300|tag/<[tag]>]>;lore=<[lore]>]
      - adjust <[item]> display_name:<yaml[titles].read[titles.<[tag]>.tag].parse_color> save:new
      - define list:->:<entry[new].result>
    - give <[list]> to:<[inventory]>
    - inventory open d:<[inventory]>

store_hub_cosmeticShop_titles_events:
  type: world
  events:
    on player clicks store_hub_cosmeticShop_titles in store_hub_cosmeticShop:
      - inject store_hub_cosmeticShop_title_open

    on system time 00:00:
      - inject title_changeover

    on player clicks name_tag in store_hub_cosmeticShop_titles_inventory:
      - determine passively cancelled
      - if <yaml[global.player.<player.uuid>].read[titles.unlocked].contains[<context.item.nbt[tag]>]||false>:
        - narrate "<&c>You already have unlocked this title."
        - stop
      - if !<yaml[global.player.<player.uuid>].contains[economy.premium.current]> || <yaml[global.player.<player.uuid>].read[economy.premium.current]||0> < <context.item.nbt[price]>:
        - narrate "<&c>You do not have enough Adriftus Coins for this purchase."
        - stop
      #- if <server.has_flag[release_stage]> && <server.flag[release_stage]> != alpha:
        #- define newBal <yaml[global.player.<player.uuid>].read[economy.premium.current].sub[<context.item.nbt[price]>]>
      - define tagID <context.item.nbt[tag]>
      - inject title_unlock
      #- if <server.has_flag[release_stage]> && <server.flag[release_stage]> != alpha:
        #- give "<item[title_voucher].with[display_name=<&b>Title Voucher<&co> <yaml[titles].read[titles.<[tagID]>.tag].parse_color>;lore=<&e>Right Click to Redeem;nbt=title/<context.item.nbt[tag]>]>"
      - narrate "<&a>You have succesfully purchased the Title: <yaml[titles].read[titles.<[tagID]>.tag].parse_color><&e>."
      - yaml id:global.player.<player.uuid> set economy.premium.current:-:<context.item.nbt[price]>
      - inject store_hub_cosmeticShop_title_open

title_changeover:
  type: task
  script:
    - flag server cosmetics_titles_today:!|:<yaml[titles].list_keys[titles].filter_tag[<yaml[titles].read[titles.<[filter_value]>.in_shop]||false>].random[18]>

title_voucher:
  type: item
  material: name_tag

title_voucher_events:
  type: world
  events:
    on player right clicks block with:title_voucher bukkit_priority:LOWEST:
      - determine passively cancelled
      - if <yaml[global.player.<player.uuid>].read[titles.unlocked].contains[<context.item.nbt[title]>]||false>:
        - narrate "<&c>You already have unlocked this title."
        - stop
      - if <player.has_flag[title_confirm]>:
        - wait 1t
        - if <player.item_in_hand> == <context.item>:
          - define tagID <context.item.nbt[title]>
          - inject title_unlock
          - take iteminhand quantity:1
          - narrate "<&b>You have redeemed the <yaml[titles].read[titles.<context.item.nbt[title]>.tag].parse_color><&b> title!"
          - flag player title_confirm:!
      - else:
        - flag player title_confirm duration:10s
        - narrate "<&e>Right click again to confirm claiming this title."

store_hub_cosmeticShop_bowTrails:
  type: item
  material: bow
  display name: <&6>Bow Trails
  enchantments:
  - damage_all:1
  lore:
  - <&e>Buy some fancy <&6>Bow Trails<&e> to show off.
  - <&e>Bow Trails are immediately redeemed upon purchase.
  - <&6>Bow Trails <&e>are network wide, and can be accessed anywhere.
  - <&e>You can access your available <&6>Bow Trails<&e> in the <&b>/bowtrails <&e>menu
  mechanisms:
   hides: all

store_hub_cosmeticShop_bowTrails_inventory:
    type: inventory
    inventory: chest
    debug: false
    title: <&a>Buying <&6>Bow Trails<&e>.
    size: 45
    definitions:
      filler: <item[store_hub_cosmeticShop_filler]>
    slots:
      - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
      - [filler] [filler] [] [filler] [] [filler] [] [filler] [filler]
      - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
      - [filler] [filler] [] [filler] [] [filler] [] [filler] [filler]
      - [filler] [] [filler] [] [filler] [] [filler] [] [filler]

store_hub_cosmeticShop_bowtrails_open:
  type: task
  script:
    - define inventory <inventory[store_hub_cosmeticShop_bowTrails_inventory]>
    - foreach <server.flag[cosmetics_bowtrails_today]> as:trail:
      - if <yaml[global.player.<player.uuid>].read[bowtrails.unlocked].contains[<[trail]>]||false>:
        - define lore "<&c>You already own this bow trail.|<&a>Price<&co><&sp>300<&sp><&b>ⓐ"
      - else:
        - define lore <&a>Price<&co><&sp>300<&sp><&b>ⓐ
      - define item <item[<yaml[bowtrails].read[bowtrails.<[trail]>.icon]>].with[nbt=<list[price/300|trail/<[trail]>]>;lore=<[lore]>]>
      - adjust <[item]> display_name:<yaml[bowtrails].read[bowtrails.<[trail]>.name].parse_color> save:new
      - define list:->:<entry[new].result>
    - give <[list]> to:<[inventory]>
    - inventory open d:<[inventory]>

store_hub_cosmeticShop_bowtrails_events:
  type: world
  events:
    on player clicks store_hub_cosmeticShop_bowTrails in store_hub_cosmeticShop:
      - inject store_hub_cosmeticShop_bowtrails_open

    on system time 00:00:
      - inject bowtrail_changeover

    on player clicks item in store_hub_cosmeticShop_bowTrails_inventory:
      - determine passively cancelled
      - if <yaml[global.player.<player.uuid>].read[bowtrails.unlocked].contains[<context.item.nbt[trail]>]||false>:
        - narrate "<&c>You already have unlocked this bow trail."
        - stop
      - if !<yaml[global.player.<player.uuid>].contains[economy.premium.current]> || <yaml[global.player.<player.uuid>].read[economy.premium.current]> < <context.item.nbt[price]>:
        - narrate "<&c>You do not have enough Adriftus Coins for this purchase."
        - stop
      #- if <server.has_flag[release_stage]> && <server.flag[release_stage]> != alpha:
        #- define newBal <yaml[global.player.<player.uuid>].read[economy.premium.current].sub[<context.item.nbt[price]>]>
      - define bowtrail <context.item.nbt[trail]>
      - inject bowtrail_unlock
      #- if <server.has_flag[release_stage]> && <server.flag[release_stage]> != alpha:
        #- give "<item[title_voucher].with[display_name=<&b>Title Voucher<&co> <yaml[titles].read[titles.<[tagID]>.tag].parse_color>;lore=<&e>Right Click to Redeem;nbt=title/<context.item.nbt[tag]>]>"
      - narrate "<&a>You have succesfully purchased the bow trail: <yaml[bowtrails].read[bowtrails.<[bowtrail]>.name].parse_color><&e>."
      - yaml id:global.player.<player.uuid> set economy.premium.current:-:<context.item.nbt[price]>
      - inject store_hub_cosmeticShop_bowtrails_open

bowtrail_changeover:
  type: task
  script:
    - flag server cosmetics_bowtrails_today:!|:<yaml[bowtrails].list_keys[bowtrails].exclude[<yaml[bowtrails].read[shop_blacklist]>].random[18]>

bowtrail_voucher:
  type: item
  material: name_tag

bowtrail_voucher_events:
  type: world
  events:
    on player right clicks block with:bowtrail_voucher bukkit_priority:LOWEST:
      - determine passively cancelled
      - if <yaml[global.player.<player.uuid>].read[bowtrail.unlocked].contains[<context.item.nbt[trail]>]||false>:
        - narrate "<&c>You already have unlocked this bow trail."
        - stop
      - if <player.has_flag[bowtrail_confirm]>:
        - wait 1t
        - if <player.item_in_hand> == <context.item>:
          - define bowtrail <context.item.nbt[trail]>
          - inject bowtrail_unlock
          - take iteminhand quantity:1
          - narrate "<&b>You have redeemed the <yaml[bowtrails].read[bowtrails.<context.item.nbt[trail]>.name].parse_color><&b> title!"
          - flag player bowtrail_confirm:!
      - else:
        - flag player bowtrail_confirm duration:10s
        - narrate "<&e>Right click again to confirm claiming this bow trail."

tempcmd:
  type: command
  name: tmpcmd
  debug: false
  permission: tsegdsgdsgdsfg
  script:
    - foreach <yaml[bbt].list_keys[Menu]> as:particleItem:
      - define item <yaml[bbt].read[Menu.<[particleItem]>.Item]>
      - ~bungeetag server:factions <item[<[item]>]> save:item
      - flag server <yaml[bbt].read[Menu.<[particleItem]>.Item].replace[<&co>].with[]>:<entry[item].result>
