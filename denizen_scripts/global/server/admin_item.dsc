admin_item:
  type: command
  name: admin_item
  description: admin command, spawns item
  permission: adriftus.admin
  usage: /admin_item (item)
  tab_complete:
    - determine <server.material_types.filter[is_item].include[<server.scripts.filter[container_type.equals[item]].parse[name]>].filter[starts_with[<context.args.get[1]>]]>
  script:
    - if <context.args.size> < 1:
      - narrate "You Dingbat."
      - stop
    - define item <item[<context.args.get[1].parse_color>]||null>
    - if <[item]> == null:
      - narrate "WTF is a <context.args.get[1]>?!"
      - stop
    - repeat 20:
      - playeffect effect:squid_ink at:<player.location.above[3]> quantity:20 offset:0.3
      - wait 2t
    - spawn dropped_item[item=<[item]>] <player.location.above[3]> save:item
    - shoot <entry[item].spawned_entity> destination:<player.location.forward_flat[5]> origin:<player.location.above[3]>
    - wait 1t
    - repeat 20:
      - playeffect effect:squid_ink at:<entry[item].spawned_entity.location.below[0.5]> quantity:10 offset:0.1
      - wait 2t
    - adjust <entry[item].spawned_entity> custom_name:<entry[item].spawned_entity.item.display||<entry[item].spawned_entity.item.material.translated_name>>
    - adjust <entry[item].spawned_entity> custom_name_visible:true