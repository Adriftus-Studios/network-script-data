
bookshelves_events:
  type: world
  events:
    on player clicks bookshelf:
      - if <context.click_type.starts_with[RIGHT]> && !<player.is_sneaking>:
        - if <inventory[bookshelf_<context.location.simple>]||null> == null:
          - note <inventory[bookshelves_inventory]> as:bookshelf_<context.location.simple>
        - inventory open d:<inventory[bookshelf_<context.location.simple>]>
        - determine passively cancelled
    on player breaks bookshelf:
      - if <inventory[bookshelf_<context.location.simple>]||null> != null:
        - foreach <inventory[bookshelf_<context.location.simple>].list_contents> as:item:
          - drop <[item]> <context.location>
        - note remove as:bookshelf_<context.location.simple>
    on piston extends:
      - foreach <context.blocks> as:block:
        - if <inventory[bookshelf_<[block].simple>]||null> != null:
          - determine passively cancelled
    on piston retracts:
      - foreach <context.blocks> as:block:
        - if <inventory[bookshelf_<[block].simple>]||null> != null:
          - determine passively cancelled
    on player clicks in bookshelves_inventory:
      - if !<list[book|writable_book|written_book|enchanted_book|air].contains[<context.item.material.name.to_lowercase>]>:
        - determine passively cancelled

bookshelves_inventory:
  type: inventory
  title: <&6>◆ <&a><&n><&l>Bookshelf<&r> <&6>◆
  size: 9
  slots:
  - "[] [] [] [] [] [] [] [] []"
