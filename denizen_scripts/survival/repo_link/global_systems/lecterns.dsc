lecterns_events:
  type: world
  debug: false
  events:
    on player clicks lectern priority:150:
      - if <context.click_type.starts_with[RIGHT]> && !<player.is_sneaking>:
        - if <inventory[lectern_<context.location.simple>]||null> == null:
          - note <inventory[lectern_inventory]> as:lectern_<context.location.simple>
        - inventory open d:<inventory[lectern_<context.location.simple>]>
        - determine passively cancelled
    on player breaks lectern priority:150:
      - if <inventory[lectern_<context.location.simple>]||null> != null:
        - foreach <inventory[lectern_<context.location.simple>].list_contents> as:item:
          - drop <[item]> <context.location>
        - note remove as:lectern_<context.location.simple>
    on piston extends:
      - foreach <context.blocks> as:block:
        - if <inventory[lectern_<[block].simple>]||null> != null:
          - determine passively cancelled
    on piston retracts:
      - foreach <context.blocks> as:block:
        - if <inventory[lectern_<[block].simple>]||null> != null:
          - determine passively cancelled
    on player clicks in lectern_inventory:
      - if !<list[book|writable_book|written_book|enchanted_book|air].contains[<context.item.material.name.to_lowercase>]>:
        - determine passively cancelled

lectern_inventory:
  type: inventory
  debug: false
  title: <&e>◆ <&6><&n><&l>Lectern<&r> <&e>◆
  inventory: chest
  size: 9
  slots:
  - [standard_filler] [standard_filler] [standard_filler] [] [] [] [standard_filler] [standard_filler] [standard_filler]
