store_hub_mysteryShop_assignment:
  type: assignment
  debug: false
  actions:
    on assignment:
    - trigger name:click state:true
    - trigger name:damage state:true
    on click:
    - inventory open d:store_hub_mysteryShop
    on damage:
    - inventory open d:store_hub_mysteryShop

store_hub_mysteryShop:
  type: inventory
  inventory: chest
  debug: false
  size: 27
  title: <&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&5>S<&d>h<&5>o<&d>p
  definitions:
    filler: <item[store_hub_mysteryShop_filler]>
  procedural items:
    - foreach <list[boxes]>:
      - define list:->:<item[store_hub_mysteryShop_<[value]>]>
    - determine <[list]>
  slots:
  - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"
  - "[filler] [filler] [filler] [filler] [] [filler] [filler] [filler] [filler]"
  - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"


store_hub_mysteryShop_filler:
 type: item
 material: glass_pane
 display name: <&b>
 enchantments:
 - sharpness:1
 mechanisms:
   hides: attributes|enchants


store_hub_mysteryShop_filler_events:
  type: world
  debug: false
  events:
    on player clicks store_hub_mysteryShop_filler in store_hub_mysteryShop:
      - determine cancelled


store_hub_mysteryShop_boxes:
  debug: false
  type: item
  material: ender_chest
  display name: <&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>
  enchantments:
  - sharpness:1
  lore:
  - "<&e>Buy some <&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>."
  mechanisms:
    hides: attributes|enchants

store_hub_mysteryShop_boxes_inventory:
    type: inventory
    debug: false
    size: 45
    inventory: chest
    title: <&a>Buying <&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.
    definitions:
      filler: <item[store_hub_mysteryShop_filler]>
      101: <item[ender_chest].with[quantity=1;flag=price:200;flag=number:10flag=stars:1;display_name=<&b>10<&sp><&e>⭐<&7>✩✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>200]>
      251: <item[ender_chest].with[quantity=2;flag=price:400;flag=number:25flag=stars:1;display_name=<&b>25<&sp><&e>⭐<&7>✩✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>400]>
      501: <item[ender_chest].with[quantity=3;flag=price:700;flag=number:50flag=stars:1;display_name=<&b>50<&sp><&e>⭐<&7>✩✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>700]>
      1001: <item[ender_chest].with[quantity=4;flag=price:1000;flag=number:100flag=stars:1;display_name=<&b>100<&sp><&e>⭐<&7>✩✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>1000]>
      102: <item[ender_chest].with[quantity=1;flag=price:400;flag=number:10flag=stars:2;display_name=<&b>10<&sp><&e>⭐⭐<&7>✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>400]>
      252: <item[ender_chest].with[quantity=2;flag=price:800;flag=number:25flag=stars:2;display_name=<&b>25<&sp><&e>⭐⭐<&7>✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>800]>
      502: <item[ender_chest].with[quantity=3;flag=price:1400;flag=number:50flag=stars:2;display_name=<&b>50<&sp><&e>⭐⭐<&7>✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>1400]>
      1002: <item[ender_chest].with[quantity=4;flag=price:2000;flag=number:100flag=stars:2;display_name=<&b>100<&sp><&e>⭐⭐<&7>✩✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>2000]>
      103: <item[ender_chest].with[quantity=1;flag=price:800;flag=number:10flag=stars:3;display_name=<&b>10<&sp><&e>⭐⭐⭐<&7>✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>800]>
      253: <item[ender_chest].with[quantity=2;flag=price:1600;flag=number:25flag=stars:3;display_name=<&b>25<&sp><&e>⭐⭐⭐<&7>✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>1600]>
      503: <item[ender_chest].with[quantity=3;flag=price:2800;flag=number:50flag=stars:3;display_name=<&b>50<&sp><&e>⭐⭐⭐<&7>✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>2800]>
      1003: <item[ender_chest].with[quantity=4;flag=price:4000;flag=number:100flag=stars:3;display_name=<&b>100<&sp><&e>⭐⭐⭐<&7>✩✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>4000]>
      104: <item[ender_chest].with[quantity=1;flag=price:1600;flag=number:10flag=stars:4;display_name=<&b>10<&sp><&e>⭐⭐⭐⭐<&7>✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>1600]>
      254: <item[ender_chest].with[quantity=2;flag=price:3200;flag=number:25flag=stars:4;display_name=<&b>25<&sp><&e>⭐⭐⭐⭐<&7>✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>3200]>
      504: <item[ender_chest].with[quantity=3;flag=price:5600;flag=number:50flag=stars:4;display_name=<&b>50<&sp><&e>⭐⭐⭐⭐<&7>✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>5600]>
      1004: <item[ender_chest].with[quantity=4;flag=price:8000;flag=number:100flag=stars:4;display_name=<&b>100<&sp><&e>⭐⭐⭐⭐<&7>✩<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>8000]>
      105: <item[ender_chest].with[quantity=1;flag=price:3200;flag=number:10flag=stars:5;display_name=<&b>10<&sp><&e>⭐⭐⭐⭐⭐<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>3200]>
      255: <item[ender_chest].with[quantity=2;flag=price:6400;flag=number:25flag=stars:5;display_name=<&b>25<&sp><&e>⭐⭐⭐⭐⭐<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>6400]>
      505: <item[ender_chest].with[quantity=3;flag=price:11200;flag=number:50flag=stars:5;display_name=<&b>50<&sp><&e>⭐⭐⭐⭐⭐<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>11200]>
      1005: <item[ender_chest].with[quantity=4;flag=price:16000;flag=number:100flag=stars:5;display_name=<&b>100<&sp><&e>⭐⭐⭐⭐⭐<&sp><&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>.;lore=<&a>Price<&co><&sp>16000]>
    slots:
      - [101] [251] [501] [1001] [filler] [filler] [filler] [filler] [filler]
      - [102] [252] [502] [1002] [filler] [filler] [filler] [filler] [filler]
      - [103] [253] [503] [1003] [filler] [filler] [filler] [filler] [filler]
      - [104] [254] [504] [1004] [filler] [filler] [filler] [filler] [filler]
      - [105] [255] [505] [1005] [filler] [filler] [filler] [filler] [filler]

store_hub_mysteryShop_boxes_events:
  type: world
  debug: false
  events:
    on player clicks store_hub_mysteryShop_boxes in store_hub_mysteryShop:
      - inventory open d:store_hub_mysteryShop_boxes_inventory
    on player clicks ender_chest in store_hub_mysteryShop_boxes_inventory:
      - determine passively cancelled
      - if <yaml[global.player.<player.uuid>].read[economy.premium.current]> >= <context.item.flag[price]>:
        - yaml id:global.player.<player.uuid> set economy.premium.current:-:<context.item.flag[price]>
        - narrate "<&a>You have succesfully purchased: <&r><context.item.flag[number]> <&e><list.pad_left[<context.item.flag[stars]>].with[⭐].separated_by[]><&7><list.pad_right[<context.item.flag[stars].sub[5].abs>].with[✩].separated_by[]> <&5>M<&d>y<&5>s<&d>t<&5>er<&d>y<&sp><&d>Boxes<&e>."
      - else:
        - narrate "<&c>You do not have enough <&b>Adriftus Coins<&c> for that."
      - inventory close
