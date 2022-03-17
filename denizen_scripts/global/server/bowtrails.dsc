bowtrails_gui_command:
  type: command
  name: bowtrails
  debug: false
  usage: /bowtrails
  description: Used to access and change any unlocked cosmetic bow trails.
  aliases:
    - bowtrail
    - bt
  script:
    - run cosmetic_selection_inventory_open def:bowtrails

bowtrails_equip:
  type: task
  debug: false
  definitions: bowtrail_id
  script:
    - determine passively cancelled
    - define bowtrail_id <context.item.flag[cosmetic].if_null[default]> if:<[bowtrail_id].exists.not>
    - run global_player_data_modify def:<player.uuid>|bowtrails.current|<context.item.flag[cosmetic]>
    - if <context.inventory.exists>:
      - define info_item <context.inventory.slot[<script[cosmetic_selection_inventory_open].data_key[data.slot_data.remove_slot]>]>
      - run cosmetic_selection_inventory_open def:<[info_item].flag[type]>|<[info_item].flag[page]>

bowtrails_unlock:
  type: task
  debug: false
  definitions: bowtrail_id
  script:
    - if <yaml[bowtrails].contains[bowtrails.<[bowtrail_id]>]> && !<yaml[global.player.<player.uuid>].contains[bowtrails.unlocked.<[bowtrail_id]>]>:
      - run global_player_data_modify def:<player.uuid>|bowtrails.unlocked.<[bowtrail_id]>|true

bowtrails_remove:
  type: task
  debug: false
  definitions: bowtrail_id
  script:
    - determine passively cancelled
    - define bowtrail_id <context.item.flag[cosmetic].if_null[default]> if:<[bowtrail_id].exists.not>
    - run global_player_data_modify def:<player.uuid>|bowtrails.current|!
    - if <context.inventory.exists>:
      - define info_item <context.inventory.slot[<script[cosmetic_selection_inventory_open].data_key[data.slot_data.remove_slot]>]>
      - run cosmetic_selection_inventory_open def:<[info_item].flag[type]>|<[info_item].flag[page]>

bowtrails_initialize:
  type: world
  debug: false
  load_yaml:
    - if <yaml.list.contains[bowtrails]>:
      - yaml id:bowtrails unload
    - if <server.has_file[data/global/network/bowtrails.yml]>:
      - ~yaml id:bowtrails load:data/global/network/bowtrails.yml
  events:
    on server start:
      - inject locally path:load_yaml
    on reload scripts:
      - yaml id:bowtrails unload
      - inject locally path:load_yaml