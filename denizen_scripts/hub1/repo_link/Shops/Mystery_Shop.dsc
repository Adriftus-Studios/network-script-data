store_hub_mysteryShop_command:
  type: command
  usage: /openmysteryShop (player)
  description: Opens the mystery shop
  name: openmysteryShop
  script:
    - inventory open d:store_hub_mysteryShop player:<server.match_player[<context.args.first>]||<player>>


store_hub_mysteryShop:
  type: inventory
  debug: false
  inventory: chest
  size: 27
  title: <&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&5>S<&d>h<&5>o<&d>p
  definitions:
    filler: <item[store_hub_mysteryShop_filler]>
  procedural items:
    - foreach <list[boxes]>:
      - define list:->:<item[store_hub_mysteryShop_<[value]>]>
    - determine <[list]>
  slots:
  - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
  - [filler] [filler] [filler] [filler] [] [filler] [filler] [filler] [filler]
  - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]


store_hub_mysteryShop_filler:
 type: item
 material: glass_pane
 display name: <&b>
 enchantments:
 - sharpness:1
 mechanisms:
   hides: ENCHANTS|ATTRIBUTES


store_hub_mysteryShop_filler_events:
  type: world
  events:
    on player clicks store_hub_mysteryShop_filler in store_hub_mysteryShop:
      - determine cancelled


store_hub_mysteryShop_boxes:
 type: item
 material: ender_chest
 display name: <&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>
 enchantments:
 - sharpness:1
 lore:
 - "<&e>Buy some <&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>."
 - "<&e>Redeem these at the Crates area on the Hub."
 - "<&b>You can access your available cosmetics with <&a>/cosmetics"
 mechanisms:
   hides: ENCHANTS|ATTRIBUTES

store_hub_mysteryShop_boxes_inventory:
    type: inventory
    debug: true
    inventory: chest
    title: <&a>Buying <&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.
    size: 45
    definitions:
      filler: <item[store_hub_mysteryShop_filler]>
      101: <item[ender_chest]>[quantity=1;nbt=<list[price/200|number/10|stars/1]>;display_name=<&b>10<&sp><&e>⭐<&7>✩✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>200<&sp><&b>ⓐ]
      251: <item[ender_chest]>[quantity=2;nbt=<list[price/400|number/25|stars/1]>;display_name=<&b>25<&sp><&e>⭐<&7>✩✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>400<&sp><&b>ⓐ]
      501: <item[ender_chest]>[quantity=3;nbt=<list[price/700|number/50|stars/1]>;display_name=<&b>50<&sp><&e>⭐<&7>✩✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>700<&sp><&b>ⓐ]
      1001: <item[ender_chest]>[quantity=4;nbt=<list[price/1000|number/100|stars/1]>;display_name=<&b>100<&sp><&e>⭐<&7>✩✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>1000<&sp><&b>ⓐ]
      102: <item[ender_chest]>[quantity=1;nbt=<list[price/400|number/10|stars/2]>;display_name=<&b>10<&sp><&e>⭐⭐<&7>✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>400<&sp><&b>ⓐ]
      252: <item[ender_chest]>[quantity=2;nbt=<list[price/800|number/25|stars/2]>;display_name=<&b>25<&sp><&e>⭐⭐<&7>✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>800<&sp><&b>ⓐ]
      502: <item[ender_chest]>[quantity=3;nbt=<list[price/1400|number/50|stars/2]>;display_name=<&b>50<&sp><&e>⭐⭐<&7>✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>1400<&sp><&b>ⓐ]
      1002: <item[ender_chest]>[quantity=4;nbt=<list[price/2000|number/100|stars/2]>;display_name=<&b>100<&sp><&e>⭐⭐<&7>✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>2000<&sp><&b>ⓐ]
      103: <item[ender_chest]>[quantity=1;nbt=<list[price/800|number/10|stars/3]>;display_name=<&b>10<&sp><&e>⭐⭐⭐<&7>✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>800<&sp><&b>ⓐ]
      253: <item[ender_chest]>[quantity=2;nbt=<list[price/1600|number/25|stars/3]>;display_name=<&b>25<&sp><&e>⭐⭐⭐<&7>✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>1600<&sp><&b>ⓐ]
      503: <item[ender_chest]>[quantity=3;nbt=<list[price/2800|number/50|stars/3]>;display_name=<&b>50<&sp><&e>⭐⭐⭐<&7>✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>2800<&sp><&b>ⓐ]
      1003: <item[ender_chest]>[quantity=4;nbt=<list[price/4000|number/100|stars/3]>;display_name=<&b>100<&sp><&e>⭐⭐⭐<&7>✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>4000<&sp><&b>ⓐ]
      104: <item[ender_chest]>[quantity=1;nbt=<list[price/1600|number/10|stars/4]>;display_name=<&b>10<&sp><&e>⭐⭐⭐⭐<&7>✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>1600<&sp><&b>ⓐ]
      254: <item[ender_chest]>[quantity=2;nbt=<list[price/3200|number/25|stars/4]>;display_name=<&b>25<&sp><&e>⭐⭐⭐⭐<&7>✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>3200<&sp><&b>ⓐ]
      504: <item[ender_chest]>[quantity=3;nbt=<list[price/5600|number/50|stars/4]>;display_name=<&b>50<&sp><&e>⭐⭐⭐⭐<&7>✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>5600<&sp><&b>ⓐ]
      1004: <item[ender_chest]>[quantity=4;nbt=<list[price/8000|number/100|stars/4]>;display_name=<&b>100<&sp><&e>⭐⭐⭐⭐<&7>✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>8000<&sp><&b>ⓐ]
      105: <item[ender_chest]>[quantity=1;nbt=<list[price/3200|number/10|stars/5]>;display_name=<&b>10<&sp><&e>⭐⭐⭐⭐⭐<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>3200<&sp><&b>ⓐ]
      255: <item[ender_chest]>[quantity=2;nbt=<list[price/6400|number/25|stars/5]>;display_name=<&b>25<&sp><&e>⭐⭐⭐⭐⭐<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>6400<&sp><&b>ⓐ]
      505: <item[ender_chest]>[quantity=3;nbt=<list[price/11200|number/50|stars/5]>;display_name=<&b>50<&sp><&e>⭐⭐⭐⭐⭐<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>11200<&sp><&b>ⓐ]
      1005: <item[ender_chest]>[quantity=4;nbt=<list[price/16000|number/100|stars/5]>;display_name=<&b>100<&sp><&e>⭐⭐⭐⭐⭐<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>16000<&sp><&b>ⓐ]
    slots:
      - [101] [251] [501] [1001] [filler] [filler] [filler] [filler] [filler]
      - [102] [252] [502] [1002] [filler] [filler] [filler] [filler] [filler]
      - [103] [253] [503] [1003] [filler] [filler] [filler] [filler] [filler]
      - [104] [254] [504] [1004] [filler] [filler] [filler] [filler] [filler]
      - [105] [255] [505] [1005] [filler] [filler] [filler] [filler] [filler]

store_hub_mysteryShop_boxes_events:
  type: world
  events:
    on player clicks store_hub_mysteryShop_boxes in store_hub_mysteryShop:
      - inventory open d:store_hub_mysteryShop_boxes_inventory
    on player clicks ender_chest in store_hub_mysteryShop_boxes_inventory:
      - determine passively cancelled
      - if <player.money> >= <context.item.nbt[price]>:
        - yaml id:global.player.<player.uuid> set Economy.AdriftusCoin:-:<context.item.nbt[price]>
        - narrate "<&a>You have succesfully purchased: <&r><context.item.nbt[number]> <&e><list.pad_left[<context.item.nbt[stars]>].with[⭐].separated_by[]><&7><list.pad_right[<context.item.nbt[stars].-[5].abs>].with[✩].separated_by[]> <&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>."
      - else:
        - narrate "<&c>You do not have enough <&b>Adriftus Coins<&c> for that."
      - inventory close
