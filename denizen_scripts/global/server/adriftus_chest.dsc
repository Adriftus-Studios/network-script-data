adriftus_chest_inventory_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[adriftus_chest_inventory]>
    - foreach <yaml[global.player.<player.uuid>].read[adriftus.chest.contents_map]||<map>>:
      - if ( <[value].has_flag[adriftus_server]> && <list[hub|<[value].flag[adriftus_server]>].contains[<bungee.server>]> ) || <[value].flag[adriftus_server]> == hub:
        - inventory set slot:<[key]> o:<[value].with[flag=adriftus_server:!;lore=<[value].lore.remove[last]>;flag=run_script:!]> d:<[inventory]>
      - else:
        - inventory set slot:<[key]> o:<[value]> d:<[inventory]>
    - inventory open d:<[inventory]>

adriftus_chest_inventory:
  type: inventory
  inventory: chest
  title: <&f><&font[adriftus:guis]><&chr[F808]><&chr[6930]>
  size: 45
  data:
    on_close: adriftus_chest_save
    any_click: adriftus_chest_validate_server

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
        - define map <[map].with[<[slot]>].as[<[item].with[lore=<[lore]>;flag=adriftus_server:<bungee.server>;flag=run_script:cancel]>]>
      - else:
        - define map <[map].with[<[slot]>].as[<[item]>]>
    - run global_player_data_modify def:<player.uuid>|adriftus.chest.contents_map|<[map]>

adriftus_chest_validate_server:
  type: task
  debug: false
  script:
    - if <context.item.has_flag[adriftus_server]>:
      - if <context.item.flag[adriftus_server]> != hub && !<list[hub|<context.item.flag[adriftus_server]>].contains[<bungee.server>]>:
        - determine cancelled