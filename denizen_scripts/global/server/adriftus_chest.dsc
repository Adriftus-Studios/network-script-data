adriftus_chest_inventory_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[adriftus_chest_inventory]>
    - foreach <yaml[global.player.<player.uuid>].read[adriftus.chest.contents_map]||<map>>:
      - inventory set slot:<[key]> o:<[value]> d:<[inventory]>
    - inventory open d:<[inventory]>

adriftus_chest_inventory:
  type: inventory
  inventory: chest
  title: <&f><&font[adriftus:guis]><&chr[F808]><&chr[6930]>
  size: 45
  data:
    on_close: adriftus_chest_save
    any_click: adriftus_chest_handle_click

adriftus_chest_save:
  type: task
  debug: false
  script:
    - define items <context.inventory.map_slots>
    - wait 1t
    - define contents <context.inventory.map_slots>
    - define map <map>
    - foreach <[contents]> key:slot as:item:
      - if <[item].has_flag[adriftus.server.bypass]>:
        - define map <[map].with[<[slot]>].as[<[item]>]>
      - else if !<[item].has_flag[adriftus_server]>:
        - define server_name <server.flag[display_name]||<&6><bungee.server.replace[_].with[<&sp>].to_titlecase>>
        - define lore "<[item].lore.include[<&e>Server<&co> <[server_name]>]||<&e>Server<&co> <[server_name]>>"
        - define map <[map].with[<[slot]>].as[<[item].with[lore=<[lore]>;flag=adriftus_server:<bungee.server>]>]>
      - else:
        - define map <[map].with[<[slot]>].as[<[item]>]>
    - run global_player_data_modify def:<player.uuid>|adriftus.chest.contents_map|<[map]>

adriftus_chest_handle_click:
  type: task
  debug: false
  script:
    - if <context.item.has_flag[adriftus_server]> && !<list[<bungee.server>|test|hub].contains[<context.item.flag[adriftus_server]>]>:
      - determine cancelled
    - choose <context.click>:
      - case left right:
        # Left or Right Click IN the Adriftus Chest
        - if <context.clicked_inventory.script.name.if_null[null]> == adriftus_chest_inventory:
          # Cursor Item
          - if <context.cursor_item.material.name> != air:
            - define server_name <server.flag[display_name]||<&6><bungee.server.replace[_].with[<&sp>].to_titlecase>>
            - define lore "<context.cursor_item.lore.include[<&e>Server<&co> <[server_name]>]||<&e>Server<&co> <[server_name]>>"
            - adjust <player> item_on_cursor:<context.cursor_item.with[lore=<[lore]>;flag=adriftus_server:<bungee.server>]>
          # Clicked Item
          - if <context.item.material.name> != air:
            - define lore <context.item.lore.remove[last]>
            - determine <context.item.with[lore=<[lore]>;flag=adriftus_server:!]> if:<context.item.has_flag[adriftus_server]>
      - case shift_right shift_left:
        - if <context.clicked_inventory.script.name.if_null[null]> == adriftus_chest_inventory:
          - if <context.item.material.name> != air:
            - define lore <context.item.lore.remove[last]>
            - determine <context.item.with[lore=<[lore]>;flag=adriftus_server:!]> if:<context.item.has_flag[adriftus_server]>
        - else:
          - define server_name <server.flag[display_name]||<&6><bungee.server.replace[_].with[<&sp>].to_titlecase>>
          - define lore "<context.item.lore.include[<&e>Server<&co> <[server_name]>]||<&e>Server<&co> <[server_name]>>"
          - determine passively <context.item.with[lore=<[lore]>;flag=adriftus_server:<bungee.server>]>
          - wait 1t
          - inventory update
      - default:
        - narrate "<&c>This action is not currently supported."
        - determine cancelled
