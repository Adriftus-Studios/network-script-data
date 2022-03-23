masks_gui_command:
  type: command
  name: masks
  debug: false
  usage: /masks
  description: Used to access and change any unlocked masks.
  script:
    - run cosmetic_selection_inventory_open def:masks

mask_ender_wizard:
  type: data
  display_data:
    category: Adriftus
    material: end_crystal
    display_name: <&6>Adriftus<&co> <&d>Ender Wizard
    description: "<&d>Free the End!"
  mask_data:
    id: ender_wizard
    display_name: <&d>Ender Wizard
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTYzNjQ3MDc5MzY4NywKICAicHJvZmlsZUlkIiA6ICIwNTVhOTk2NTk2M2E0YjRmOGMwMjRmMTJmNDFkMmNmMiIsCiAgInByb2ZpbGVOYW1lIiA6ICJUaGVWb3hlbGxlIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2Q0ZjdmYTA3YTdlOWY1NzU2ZWMxNGQ0YjUyYmIzNzk5ZjE2N2JkMTgxNjE2YmM5ODQ5ZmI5NGVkZjk1MTFmZjYiLAogICAgICAibWV0YWRhdGEiIDogewogICAgICAgICJtb2RlbCIgOiAic2xpbSIKICAgICAgfQogICAgfQogIH0KfQ==;BnPptUMoz6YAK1UVzGOipaY4a7U28aBhazRO5U7pToBuwMuH2b669AFM0T+/0d0LnmbzzHICFXv0npg+1NEoaCFfWf71koXXfJD/8lnO+ePlIWah7RrWWhha5gYY1UsUggGz7LJeUpieIqFIvRj+ZCF4Tu0nCSrN7O3FftVWWTyhL7CbxXhzlZ21MRwh2SfTDK+F4KdlUA5xfO5X+QL1RO6dSLZ91YHbf1xpkbJO5kxEmLDk77H5aoAUpM7us+FiKsxHDOLzRn6Cqmo4DvueONjWlK4jKuQciu0xDaeopZAgUJqojkdLzb2RGZfMTRmsUSP6g7TF9y1clJnjm165NnwlHG025ZOr0CLdOi/4HJHEHe+ug3h6P0RfKnszUae8flocQlt1vimgt71GgxGvQfdNs2DAKCA/5LeZXT9BZqbHf7AuTZ/KK0t6aSp1xgqETDCaOdgEnyclDQcg0LpV2elSPjyqOgT7A89F8LTAFAxxFrAKj2+BtM83C6BeGiFaAJowyqchDUQbfRhc04g9M8iTtSmacIj6bzLBeBRXjeR4Mqzdx1hfhUXXMzO2J9MMyx0/qOrtgbjDhV6iHyBihrNO3yjkcLJp3rfJa/1tVsvXbhSoGdCAFEuiDH3FGyQi0vzqazdedkLT7d8YnnkDQ0UvX6qfraRwsk1MzvZKYsM=


mask_wear_events:
  type: world
  debug: false
  initialize:
    - flag server masks:!
    - foreach <server.scripts.filter[name.starts_with[mask_]].filter[container_type.equals[DATA]]>:
      - flag server masks.categories.<[value].data_key[display_data.category]>.<[value].data_key[mask_data.id]>:<[value]>
      - flag server masks.ids.<[value].data_key[mask_data.id]>:<[value]>
  events:
    on player joins:
      - waituntil rate:10t <yaml.list.contains[global.player.<player.uuid>].or[<player.is_online.not>]>
      - if !<player.is_online>:
        - stop
      - if !<yaml[global.player.<player.uuid>].contains[defaults.skin_blob]> || <yaml[global.player.<player.uuid>].read[defaults.skin_blob]> != <player.skin_blob>:
        - run global_player_data_modify def:<player.uuid>|defaults.skin_blob|<player.skin_blob>
      - if <yaml[global.player.<player.uuid>].contains[masks.current]>:
        - adjust <player> skin_blob:<yaml[global.player.<player.uuid>].read[masks.current.skin_blob]>
        - adjust <player> name:<yaml[global.player.<player.uuid>].read[masks.current.display_name]>
        - if <yaml[global.player.<player.uuid>].contains[masks.current.attachment]>:
          - run mask_attachment def:<yaml[global.player.<player.uuid>].read[masks.current.attachment]>
        - run network_map_update_name def:<player.uuid>|<yaml[global.player.<player.uuid>].read[masks.current.display_name]>

    on server start:
      - inject locally path:initialize
    on script reload:
      - inject locally path:initialize

mask_unlock:
  type: task
  debug: false
  definitions: mask_id
  script:
    - if <server.has_flag[masks.ids.<[mask_id]>]> && !<yaml[global.player.<player.uuid>].contains[masks.unlocked.<[mask_id]>]||false>:
      - run global_player_data_modify def:<player.uuid>|masks.unlocked.<[mask_id]>|true

mask_wear:
  type: task
  debug: false
  definitions: mask_id
  script:
      - determine passively cancelled
      - define mask_id <context.item.flag[cosmetic].if_null[default]> if:<[mask_id].exists.not>
      - if !<script[mask_<[mask_id]>].exists>:
        - debug error "UNKNOWN MASK<&co> <[mask_id]>"
        - stop
      - inventory close
      - wait 1t
      - define script <script[mask_<[mask_id]>]>
      - run global_player_data_modify def:<player.uuid>|masks.current|<[script].parsed_key[mask_data]>
      - adjust <player> skin_blob:<yaml[global.player.<player.uuid>].read[masks.current.skin_blob]>
      - adjust <player> name:<yaml[global.player.<player.uuid>].read[masks.current.display_name]>
      - if <yaml[global.player.<player.uuid>].contains[masks.current.attachment]>:
        - run mask_attachment def:<yaml[global.player.<player.uuid>].read[masks.current.attachment]>
      - run network_map_update_name def:<player.uuid>|<yaml[global.player.<player.uuid>].read[masks.current.display_name]>

mask_remove:
  type: task
  debug: false
  definitions: mask_id
  script:
    - determine passively cancelled
    - inventory close
    - wait 1t
    - run global_player_data_modify def:<player.uuid>|masks.current|!
    - adjust <player> skin_blob:<yaml[global.player.<player.uuid>].read[defaults.skin_blob]>
    - adjust <player> name:<player.name>
    - remove <player.passengers> if:<player.passenger.entity_type.equals[armor_stand].if_null[false]>
    - run network_map_update_name def:<player.uuid>|<player.name>

mask_attachment:
  type: task
  debug: false
  definitions: item
  script:
    - define item <item[<[item]>]> if:<[item].object_type.equals[ITEM].not>
    - spawn armor_stand[marker=true;visible=false;equipment=air|air|air|<[item]>] <player.location> save:as
    - mount <entry[as].spawned_entity>|<player>
    - flag <entry[as].spawned_entity> on_dismount:cancel
    - flag <entry[as].spawned_entity> on_entity_added:remove_this_entity
    - while <player.is_online> && <player.passenger> == <entry[as].spawned_entity>:
      - look <entry[as].spawned_entity> yaw:<player.location.yaw>
      - wait 1t
    - kill <entry[as].spawned_entity>
    - remove <entry[as].spawned_entity>