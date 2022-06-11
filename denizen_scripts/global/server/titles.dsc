titles_gui_command:
  type: command
  name: titles
  debug: false
  usage: /titles
  description: Used to access and change any unlocked titles.
  script:
    - run cosmetic_selection_inventory_open def:titles

titles_equip:
  type: task
  debug: false
  definitions: title_id|player
  script:
    - adjust <queue> linked_player:<[player]> if:<[player].object_type.equals[Player].if_null[false]>
    - determine passively cancelled
    - define title_id <context.item.flag[cosmetic].if_null[default]> if:<[title_id].exists.not>
    - define map <map[titles.current=<context.item.flag[cosmetic]>;titles.current_tag=<yaml[titles].parsed_key[titles.<context.item.flag[cosmetic]>.tag].parse_color>]>
    - run global_player_data_modify_multiple def:<player.uuid>|<[map]>
    - if <context.inventory.exists>:
      - define info_item <context.inventory.slot[<script[cosmetic_selection_inventory_open].data_key[data.slot_data.remove_slot]>]>
      - run cosmetic_selection_inventory_open def:<[info_item].flag[type]>|<[info_item].flag[page]>

titles_unlock:
  type: task
  debug: false
  definitions: title_id|player
  script:
    - adjust <queue> linked_player:<[player]> if:<[player].object_type.equals[Player].if_null[false]>
    - if <yaml[titles].contains[titles.<[title_id]>]> && !<yaml[global.player.<player.uuid>].contains[titles.unlocked.<[title_id]>]>:
      - run global_player_data_modify def:<player.uuid>|titles.unlocked.<[title_id]>|true

titles_remove:
  type: task
  debug: false
  definitions: title_id|player
  script:
    - adjust <queue> linked_player:<[player]> if:<[player].object_type.equals[Player].if_null[false]>
    - determine passively cancelled
    - define title_id <context.item.flag[cosmetic].if_null[default]> if:<[title_id].exists.not>
    - run global_player_data_modify def:<player.uuid>|titles.current|!
    - if <context.inventory.exists>:
      - define info_item <context.inventory.slot[<script[cosmetic_selection_inventory_open].data_key[data.slot_data.remove_slot]>]>
      - run cosmetic_selection_inventory_open def:<[info_item].flag[type]>|<[info_item].flag[page]>

titles_initialize:
  type: world
  debug: false
  load_yaml:
    - if <yaml.list.contains[titles]>:
      - yaml id:titles unload
    - if <server.has_file[data/global/network/titles.yml]>:
      - ~yaml id:titles load:data/global/network/titles.yml
  events:
    on server start:
      - inject locally path:load_yaml
    on reload scripts:
      - yaml id:titles unload
      - inject locally path:load_yaml