teleportation_animation_run:
  type: task
  debug: false
  definitions: destination
  script:
    - if <yaml[global.player.<player.uuid>].contains[animations.teleportation.current.colorable]>:
      - define color <yaml[global.player.<player.uuid>].read[animations.teleportation.current.color]>
    - else:
      - define color white
    - if <yaml[global.player.<player.uuid>].contains[animations.teleportation.current]>:
      - inject <yaml[global.player.<player.uuid>].contains[animations.teleportation.current.task]>
    - else:
      - inject teleportation_animation_default_run

teleportation_animation_aggregator:
  type: world
  debug: false
  create_flag:
    - flag server animations.teleportation:!
    - foreach <server.scripts.filter[name.starts_with[teleportation_animation_]].filter[container_type.equals[DATA]]>:
      - flag server animations.teleportation.<[value].data_key[name]>:<[value]>
  events:
    on server start:
      - inject locally path:create_flag
    on script reload:
      - inject locally path:create_flag

teleportation_animation_set:
  type: task
  debug: false
  definitions: animation_name
  script:
    - define animation_name <context.item.flag[animation]> if:<[animation_name].exists.not>
    - run global_player_data_modify def:<player.uuid>|animations.teleportation.current|<server.flag[animations.teleportation.<[animation_name]>].data_key[]>
    - run teleportation_animation_inventory_open

teleportation_animation_inventory_open:
  type: task
  debug: false
  script:
    - define animations <yaml[global.player.<player.uuid>].read[animations.teleportation.unlocked]>
    - foreach <[animations].keys> as:anim:
      - define material <server.flag[animations.teleportation.<[anim]>].data_key[display_material]>
      - define name <server.flag[animations.teleportation.<[anim]>].data_key[name]>
      - define lore <server.flag[animations.teleportation.<[anim]>].data_key[description]>
      - define item_list:|:<item[<[material]>[display=<[name]>;lore=<[lore]>;flag=run_script:teleportation_animation_set;flag=animation:<[anim]>]]>
    - define slots <script[teleportation_animation_inventory].data_key[data.fill_slots]>
    - define inventory <inventory[teleportation_animation_inventory]>
    - foreach <[item_list]> as:icon:
      - inventory set slot:<[slots].get[<[loop_index]>]> o:<[icon]> d:<[inventory]>
    - inventory open d:<[inventory]>

teleportation_animation_inventory:
  type: inventory
  debug: false
  title: <&d>Teleportation Animations
  data:
    fill_slots: 20|21|22|23|24|25|26|29|30|31|32|33|34|35|38|39|40|41|42|43|44
  inventory: chest
  slots:
   - [] [] [] [] [] [] [] [] []
   - [] [] [] [] [] [] [] [] []
   - [] [] [] [] [] [] [] [] []
   - [] [] [] [] [] [] [] [] []
   - [] [] [] [] [] [] [] [] []
   - [] [] [] [] [] [] [] [] []